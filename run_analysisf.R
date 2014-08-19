library(plyr)
library(data.table)
library(reshape2)
library(stringr)

# run_analysis.R wrapper function
# wrapping the run_analysis.R into a function for benchmarking and
# profiling purposes.

output <- function(){
	
	######### Set WD to same folder as datasets.
	
	#### Load all relevant datasets into a list that mimics original folder structure
	
	## create list "datalist" containing all datasets
	# create "datalist" structure based on folder/file structure in WD
	pathlist <- alply(list.dirs(getwd(),recursive = F),1,list.files,pattern = '*.txt',full.names = T,recursive = T)
	
	# create dataset list, mimicing folder/file structure
	datalist <- lapply(pathlist,sapply,
										 function(x) {
										 	initial <- read.table(x, nrows = 50)
										 	classes <- sapply(initial, class)
										 	tabAll <- data.table(read.table(x,colClasses = classes))
										 })
	
	# name lists and elements within lists mimicing folder/file structure
	groups <- list.dirs(recursive = F,full.names = F)
	names(datalist) <- groups
	
	# names of individual data.tables become generic, removing "_test/trial.txt" substring
	for(i in seq_along(groups)) names(datalist[[i]]) <- sub(paste('_',groups[i],'.txt',sep = ''),'',basename(names(datalist[[i]])))
	
	# cbind all data.tables in each list element of datalist
	datalist2 <- lapply(datalist,function(x) do.call(cbind.data.frame,x))
	
	# add a test vs. trial identifier variable "Group" as a factor
	# notice number of groups and datasets is dynamic based on original number of data folders
	for(i in seq_along(groups)) datalist2[[i]][,Group := factor(groups[i],levels = groups)]
	
	# merge all datasets into single dataset using "rbind" action
	fdata <- rbindlist(datalist2)
	setnames(fdata,c('subject.V1','y.V1'),c('SubjectID','ActivityCode'))
	setkeyv(fdata,c('Group','SubjectID','ActivityCode'))
	
	
	## loads features metadata into R
	metad <- fread('features.txt',colClasses = c('integer','character'))
	setnames(metad,1:2,c('FeatureCode','FeatureDescr'))
	setkey(metad,'FeatureCode')
	
	# identify feature codes for mean & std. deviation variables for each measure
	# meanFreq feature is excluded due to ambiguity in requirement on course project description
	extractcols <- grep('mean\\(\\)|std\\(\\)',metad$FeatureDescr,value = T)
	
	# extract feature codes
	codes <- metad[metad$FeatureDescr %in% extractcols,'FeatureCode',with = F]
	
	# transform to match column names in fdata relating to code
	xcodes <- paste('X.V',codes$FeatureCode,sep = '')
	
	# extracts relevant columns:
	#		Group as test/trial group identifier
	#		SubjectID as observation identifier
	#		ActivityCode as activity identifier
	#		xcodes variable names corresponding to all available mean & std. deviation measurments
	measured <- fdata[,c(key(fdata),xcodes),with = F]
	
	# rename measurement varaibles to something cleaner and tidier
	newnames <- metad[codes,'FeatureDescr',with = F]$FeatureDescr
	newnames <- gsub('\\(\\)','',newnames)
	setnames(measured,xcodes,newnames)
	
	# melt data.table
	moltmeas <- melt(measured,id.vars = key(measured))
	
	# extract (transformed) signal, statistic calculated for said measurement, and dimensions
	#		- axis takes vlues "X", "Y", or "Z", altneratively remaning missing (NA) for those signals averaged across all 3 dimensions (e.g. "fBodyBodyGyroJerkMag")
	moltmeas[,variable := as.character(moltmeas$variable)]
	
	x <- strsplit(moltmeas$variable,split = '-')
	x1 <- as.data.table(t(sapply(x,function(x) if(length(x) == 2) x = c(x,NA) else x)))
	splitnames <- c('feature','stat','axis')
	setnames(x1,splitnames)
	moltmeas <- cbind(moltmeas,x1)
	setkeyv(moltmeas,c('Group','SubjectID','ActivityCode'))
	
	# load activity codes into R
	metad2 <- fread('activity_labels.txt',colClasses = c('integer','character'))
	setnames(metad2,1:2,c('ActivityCode','ActivityDescr'))
	setkey(metad2,'ActivityCode')
	
	# define activity code as factor and add labels
	moltmeas[,ActivityCode := factor(moltmeas$ActivityCode,labels = tolower(metad2$ActivityDescr))]
	setnames(moltmeas,'ActivityCode','Activity')
	
	# cast data.table to achieve tidy, workable format
	# resulting data.table provides averages of mean & std. deviations by subject, activity, and feature (variable, across all 3 axes when available)
	castdt <- dcast.data.table(moltmeas[,-c(4,8),with = F],Group + SubjectID + Activity + feature ~  stat,value.var = 'value',fun.aggregate = mean)
	
	# output as "tidydataoutput.txt" to working directory
	write.table(castdt,file = 'tidydataoutput.txt',row.names = F)
	
}
