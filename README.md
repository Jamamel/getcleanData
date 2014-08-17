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

Below is a preview of the resulting data.table *castdt* as the final output object in run_analysis.R (exported as `tidydataoutput.txt`):

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

It also uses some string manipulation functions from the [stringr](http://cran.r-project.org/web/packages/stringr/index.html). The script `run_analysis.R` is annotated throughout in order to show the steps implemented. 

[plyr](http://cran.r-project.org/web/packages/plyr/index.html) is also used in functions that setup the data loading routines.

##Comments

The code still suffers from a noticeable bottleneck when loading the different files. A rough application of `read.table` could be improved to make this part of the process a lot quicker and efficient.

The code hasn't been modularized at all into functions and as a consequence of that, quite a lot of objects are created. As of now, the extimated memory usage of the workspace after successful completion of the scrit is around **610 MB** or RAM.

I believe there is a way to split a string column into multiple columns using `strsplit` (or equivalents) more efficiently. This is the second, smaller bottleneck in the code.

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