#Code Book

This document describes the data set produced by the script [run.analysis.R](https://github.com/Jamamel/getcleanData/blob/master/run_analysis.R). It reads in a collection of datasets, split by subject group **test** or **train**. There are **2 consistently formatted groups of 12 datasets** per group.

For specifics about the contents of each data set please refer to the original study's [Code Book](https://github.com/Jamamel/getcleanData/blob/master/UCI%20HAR%20Dataset/README.txt).

```R
List of 2
 $ test :List of 12
 $ train:List of 12
```

Each data set was named by extracting the generic roots from their file name  (e.g. `X_test.txt` became `X`, row 11 in tables below).

```R
Test Group
Total: 42MB
           NAME  NROW MB
 1:  body_acc_x 2,947  3
 2:  body_acc_y 2,947  3
 3:  body_acc_z 2,947  3
 4: body_gyro_x 2,947  3
 5: body_gyro_y 2,947  3
 6: body_gyro_z 2,947  3
 7:     subject 2,947  1
 8: total_acc_x 2,947  3
 9: total_acc_y 2,947  3
10: total_acc_z 2,947  3
11:           X 2,947 13
12:           y 2,947  1

Train Group
Total: 106MB
           NAME  NROW MB
 1:  body_acc_x 7,352  8
 2:  body_acc_y 7,352  8
 3:  body_acc_z 7,352  8
 4: body_gyro_x 7,352  8
 5: body_gyro_y 7,352  8
 6: body_gyro_z 7,352  8
 7:     subject 7,352  1
 8: total_acc_x 7,352  8
 9: total_acc_y 7,352  8
10: total_acc_z 7,352  8
11:           X 7,352 32
12:           y 7,352  1
```

The output of this script is a data table (in `*.txt` format), of which this is a preview:

```R
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

The resulting dataset is a data table with **3,060 rows** and **6 variables**.

##Variable Description

- `Group` identifies whether the subject belonged to either  *test* or *train* group.

```R
   Group    N Perc
1:  test  918  0.3
2: train 2142  0.7
```

- `SubjectID` identifies one of 30 subjects. It is therefore an *integer class variable* that ranges from 1 to 30.

- `Activity` identifies one of 6 possible activites identified in the experimental design.

```R
             Activity   N      Perc
1:            walking 510 0.1666667
2:   walking_upstairs 510 0.1666667
3: walking_downstairs 510 0.1666667
4:            sitting 510 0.1666667
5:           standing 510 0.1666667
6:             laying 510 0.1666667
```

- `feature` refers to every feature and its subsequent transformation. See **Variable Transformation** section for more details. 

```R
 [1] fBodyAcc             fBodyAccJerk         fBodyAccMag         
 [4] fBodyBodyAccJerkMag  fBodyBodyGyroJerkMag fBodyBodyGyroMag    
 [7] fBodyGyro            tBodyAcc             tBodyAccJerk        
[10] tBodyAccJerkMag      tBodyAccMag          tBodyGyro           
[13] tBodyGyroJerk        tBodyGyroJerkMag     tBodyGyroMag        
[16] tGravityAcc          tGravityAccMag 
```

- `mean` is the average of all mean scores for each `feature`. Some  *features* were measured across 3 axes (*XYZ*), in which case the corresponding average is across all 3 dimensions.

- `std` is the analogous of `mean` for standard deviations across the same *features* as described above.

##Variable Transformation

All datasets were merged into one, and the relevant variables of mean and standard deviations of measurements extracted, along with subject , group, and activity id's.

This data table was then molten and re-cast by feature measurement, aggregating across axes and activity to produce the tidy output dataset `tidydataoutput.txt`. 

For more details around all transformation and data manipulation, please refer to the well commented [run_analysis.R](https://github.com/Jamamel/getcleanData/blob/master/run_analysis.R) script.