#getcleanData

getcleanData is course project repo for Module 3: Getting and Cleaning Data on John Hopkins's Data Scientist Coursera.

It provides all elements required (input & output data, scripts) to meet the required elements in the assignment:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set.
4. Appropriately labels the data set with descriptive variable names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

##Content

Included in this repo are the following folders and files:

- `README.md` -  Markdown file describing how the script works.
- `run_analysis.R` - R script to be run **after** the working directory has been set to the same where all input data is stored.
- `UCI HAR Dataset` - Folder containing all input and example output (i.e. `extidydataoutput.txt`) data

Files contained in *UCI HAR Dataset* folder includes:

- `extidataoutput.txt` - Example of resulting data.table providing averages of mean & std. deviations by subject, activity, and feature (variable, across all 3 axes when available)
- `README.txt` - Please refer to this file for all relevant information regarding all background regarding input data and folder/file structure.

##Setup

To run this script you'll need to do quick bits for setup:

- the latest versions of the following libraries from CRAN are required:

```R
install.packages(c("data.table","reshape2","stringr","plyr"))
```

- you will need to make **UCI HAR Dataset** your WD, so that the script recursively looks for any folders of equivalent files (e.g. "test","train"), and knows the location of the other required files (i.e. `activity_labels.txt`, `features.txt`, `features_info.txt`).

##Running

All you need do now is source the R script `run_analysis.R`. The code will generate a file `tidydataoutput.txt` satisfying the project objective (as described above). The file will be generated in your WD. Please see the included Code Book for a description of output data.

Below is a preview of the resulting data.table `castdt` as the final output object in run_analysis.R (exported as `tidydataoutput.txt`):

```R
castdt

      Group SubjectID Activity              feature        mean        std
   1:  test         2  walking             fBodyAcc -0.27391978 -0.3606977
   2:  test         2  walking         fBodyAccJerk -0.31277871 -0.3151814
   3:  test         2  walking          fBodyAccMag -0.32428943 -0.5771052
   4:  test         2  walking  fBodyBodyAccJerkMag -0.16906435 -0.1640920
   5:  test         2  walking fBodyBodyGyroJerkMag -0.58324929 -0.5581046
  ---                                                                     
3056: train        30   laying        tBodyGyroJerk -0.06677954 -0.9816339
3057: train        30   laying     tBodyGyroJerkMag -0.98508641 -0.9761771
3058: train        30   laying         tBodyGyroMag -0.96228492 -0.9512644
3059: train        30   laying          tGravityAcc  0.35646090 -0.9839231
3060: train        30   laying       tGravityAccMag -0.96982998 -0.9601679
```

##Details

The script follows the principles of [tidy data (as described by Hadley Wickham)](http://vita.had.co.nz/papers/tidy-data.pdf). It applies the notions of *melting*, *splitting*, *applying*, and *casting*. 

It takes advantage of the very recent [data.table](http://cran.r-project.org/web/packages/data.table/index.html) package, in combination with functions `melt` and `dcast.data.table` in the [reshape2](http://cran.r-project.org/web/packages/reshape2/index.html) package. 

It also uses some string manipulation functions from [stringr](http://cran.r-project.org/web/packages/stringr/index.html). The script `run_analysis.R` is annotated throughout in order to show the steps implemented. 

[plyr](http://cran.r-project.org/web/packages/plyr/index.html) is also used in functions that setup data loading routines (e.g. `alply`).

##Comments

The code hasn't been modularized at all into functions and as a consequence of that, quite a lot of objects are created. As of now, the extimated memory usage of the workspace after successful completion of the scrit is around **610 MB** of RAM. I'm running the script on a **2010 MacBook Pro**, with a **2.4 GHz Intel Core i5**,**4 GB 1067 MHz DDR3 of RAM Memory**, and **OSX 10.9.4**.

Running a quick benchmark and profiling test:

- processing time is around 70 seconds after 10 iterations (I was streaming "Match of the Day"" and committing to Github at the time... hehe).
```R
Unit: seconds
           expr      min       lq   median       uq     max neval
 run_analysis.R 66.13029 66.60161 69.96732 80.04303 83.4226    10
```

```R
     time   alloc release   dups                         ref                     src
1   0.002   0.212   0.000    448  .active-rstudio-document#9 output/alply           
2  44.042 432.283 353.887 468505 .active-rstudio-document#12 output/lapply          
3   0.004   0.450   0.000   1205 .active-rstudio-document#31 output/[               
4   0.454  50.857  44.920  52584 .active-rstudio-document#34 output/rbindlist       
5   0.031   0.011   0.000    804 .active-rstudio-document#36 output/setkeyv         
6   0.002   0.207   0.000     61 .active-rstudio-document#40 output/fread           
7   0.001   0.096   0.000    187 .active-rstudio-document#49 output/[               
8   0.001   0.137   0.000    134 .active-rstudio-document#52 output/paste           
9   0.063   3.207  34.874   3473 .active-rstudio-document#59 output/[               
10  0.015   2.273   0.000    322 .active-rstudio-document#67 output/melt            
11  0.050   1.659   2.450    503 .active-rstudio-document#71 output/[               
12  1.456  39.187   1.329      8 .active-rstudio-document#73 output/strsplit        
13  1.766 600.547 532.320    146 .active-rstudio-document#74 output/as.data.table   
14  0.120   3.585  67.257    156 .active-rstudio-document#77 output/cbind           
15  0.032   0.716   0.000    519 .active-rstudio-document#78 output/setkeyv         
16  0.088   4.484   0.000    728 .active-rstudio-document#86 output/[               
17  0.101   6.859   0.000    771 .active-rstudio-document#91 output/dcast.data.table
18  0.025   0.369   0.000    786 .active-rstudio-document#94 output/write.table     
```

The code still suffers from a noticeable bottleneck when loading all files. How could the rough application of `read.table` over a loop and into lists be improved to make this part of the process a lot quicker and efficient? *(see row 2 in table above)*

I believe there is a way to split a string column into multiple columns using `strsplit` (or equivalents) more efficiently. This is the second, slightly smaller bottleneck in the code. *(see rows 12 & 13 in table above)*

Below is a printout of my session so that R version and packages loaded can be compared and results replicated successfully. 

```R
R version 3.1.1 (2014-07-10)
Platform: x86_64-apple-darwin13.1.0 (64-bit)

locale:
[1] en_GB.UTF-8/en_GB.UTF-8/en_GB.UTF-8/C/en_GB.UTF-8/en_GB.UTF-8

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] stringr_0.6.2    reshape2_1.4     data.table_1.9.2 plyr_1.8.1      

loaded via a namespace (and not attached):
[1] digest_0.6.4     evaluate_0.5.5   formatR_0.10     htmltools_0.2.4 
[5] knitr_1.6        Rcpp_0.11.2      rmarkdown_0.2.50 tools_3.1.1 
```