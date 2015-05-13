
#Activity Monitoring 

## 1 - Initial decisions

### 1.1 - Sensor selection
Android has 2 different accelerometer options: [TYPE_ACCELEROMETER` and `TYPE_LINEAR_ACCELERATION` [from](http://developer.android.com/guide/topics/sensors/sensors_motion.html ). The first option returns raw accelerometer data, including the gravity pull, while the latter is a software filtered version of the first, which filters out the gravity pull and uses the gyroscope for stabilisation. This software-sensor is part of the Android Open Source Project (AOSP). Since we want to detect motion regardless of device orientation, we have chosen to go with the second option. It has to be noted that his software filters requires bias-calibration: the resulting values will have an offset when the accelerometer is not moving, which needs to be removed.

Following the paper, we record accelerometer data at a frequency of at most 50 Hz (data analysis showes an average frequency of roughly 49.8 Hz). 


### 1.2 - Classification
Several classifiers can be used and are suitable. 

Initially we have chosen to use the k-NN classifier as it was mentioned during the lectures. 

However, since there is a lot a noise in the data, and several datapoints can be collected, a neural-network might be a very good alternative option. Inputs can be set the raw accelerometer data of each axis for m-samples, via a hidden layer (we a working with a non-linear separable space, hence hidden layers are needed) to 3 output nodes, each being activated if a step, walk or idle is observed. Backpropagation (with sigmoid) can be used to train and if the outputs are normalised, we can estimate with a probability which type is best suitable for the given inputs. 

Accelerometer data can be annotated with a training-interface in the app. After importing this data into matlab, data annotation can be corrected with the [fixAnnotation](link-to-fixAnnotation-tool) tool.

### 1.3 - Feature selection
Determining features requires some data insights. Initial insights were given by the the paper of [A. Rai et. al. ](http://research.microsoft.com/pubs/166309/com273-chintalapudi.pdf) as the standard deviation and autocorrelation of the magnitude of the accelerometer give hints about a person not moving or walking. To gather more insights several dataset have been recorded. Based on observations of the data, 3 motiontypes have been determined:
                                                                                                                    
- idle: the user is standing still, resulting in a device which is barely moving.
- step: a single step of an user, observed when the user in standing in a queue.
- walking: The user walks a constant speed walk.

Used features:
- mean(magnitude): The magnitude shows unidirectional movement. It is expected that when idle, the magnitude is low, when a step is taken several peaks will be observed and when an user is walked a longer streak of peaks are shown. Initially, the magnitude of a sample `m` does not use a sliding window. Using an sliding window may improve the stability, since this would smooth-out (average) peaks, which might be caused by noise.
- std(magnitude): The standard deviation is applied to a sliding window. As indicated by the A. Rai et al. a very small deviation indicates no movement. A deviation should be able to discriminate between idle, step and walk, but step and walk might be observed as very similar.
- NASC (autocorrelation): This is used to determine if a constant frequency is observed in the data, indicating a repeating pattern, such as walking. 

Extra features may be added, and the above described features may change as we will gather more insights during the project.

## 2 - Progress

### 2.1 - Done so-far (May 13th 2015)

#### 2.1.1 - App
An app is created with the following functionality


Using the research of A.Rai et al. as lead, several window sizes `w` for the mean and standard deviation (std) of the magnitude where used. Determining the mean or std for a sample `i` is done by using all samples between `i:i+w`, which will result in a non-real time application (since at least `w`-samples are needed to compute the features of sample `i`). 

Combining all test-data, pdf’s are generated for different window sizes. Window-sizes for feature detection are chosen, based on the amount of overlap of each pdf. The lower the overlap, the better such an window-size is suitable. 



#### 2.1.3 - Current open issues/TODO's
Upgrade the static calibration step of app with the more dynamic Kalman filter. The basic idea is explained [here](http://www.gamasutra.com/view/feature/129919/wheres_the_wiimote_using_kalman_.php?page=4). Requesting the user to put the phone on an table we can signal if the estimated bias does not change, e.g. has reached the 'true' offset of the accelerometer. This bias can be used to correct measurements. Removing the static calibration step ensures we are less likely to measure data with a faulty bias, hence do incorrect predictions.

Upgrade start/stop of accelerometer in the app with start/stop/pause. In the current implementation the accelero meter is unregisterd if an user want to stop measuring (temporarily). Starting the accelerometer requires a new bias-estimate since the bias changes on accelerometer-booting. By introducing an 'pause' button the accelerometer can keep running, while data is not stored in the database. Current flags to do this are already (partially) in place

More datasets! We need more! And a list for each dataset/run to determine amount of applied noise

Tool to concat datasets. 

PDF-fitting. All current matlab tools compute histograms and pdfs using the deprecated 'hist'-function. The get better estimates (for example for the [compPdf](compPdf) function), it might be better to use a fit on the (differently calculated?) histogram and use this fit compare different windowsizes. The function [alldistfit](http://www.mathworks.com/matlabcentral/fileexchange/34943-fit-all-valid-parametric-probability-distributions-to-data) at matlab exchange (referenced from [this](http://blogs.mathworks.com/pick/2012/02/10/finding-the-best/) article) might be a good start. 

NASC: update code to select step-frequency. Current results of NASC show the maximum auto correlation for all t-values for each sample, which might introduce a lot of error. We might need to introduce/design an extra functions which tries to figure out the stepping frequency `t`, which than (just as in the paper) can be used to decrease the interval at which NASC is calculated: going from `40:100`, to `t-10:t+10`. This function eventually needs to be implemented into the app

NASC: Figuring out a proper way to train NASC. Each sequence of 'walk' samples should be interpreted as a seperate sequence. if multiple (different) walk-sequences are 'concataned' (as is done in the current implementation) we get a region where the frequencies do not overlap and will mess op the results.

NASC: Currently autocorrelation is calculated differently as the other initial features: the dataset is split into chunks with equal motion type, and then on each motiontype we test NASC, while the std and mean just start at the beginning of the data set and runs till the end. The label of a feature in the latter approach is set to the label of the first sample of the running window. Maybe we should also take this approach for NASC? 

Feature selection: based on all research, determine features and generate feature data-file.

Feature update: The magnitude can of a sample, can als be calculated (just as the std) as the mean over the magnitude of n-samples. This would remove peaks introduced by noise

Feature update: the initial set of features does not the option to determine the direction of an acceleration and if an user is shaking an device. When direction is included, shaking gestures (noise) can be interpreted and removed. It is however net yet clear how much effect shaking behavior has at the current set of selected features.

Test classification: using the feature-file and datasets to classify data. Using cross-validation we can setup an confusion matrix and determine accuracy of the features. 

Entropy: perhaps we could use entropy-calculations to determin if we have redundent features?

App-upgrade: database-table to hold activity features

App-upgrade: function to import activity features from file into the database of the app

App-upgrade: kNN implementation

App-upgrade: option to start recording data for classification 

App-upgrade: NASC

App-upgrade: feature extractation of recording data


### 2.2 - After May 13th 2015
(will be regulary updated)





## 3 - Extra ideas




## 4 - Final design
(describes our final design for activity monitoring)
(will be used in our report)


##Evaluation Setup : Training and testing


----
QUESTIONS
----

