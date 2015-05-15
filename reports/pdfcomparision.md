# Feature selection

One of the most challenging tasks is to select the correct features. While a trail-and-error approach might give nice results, we believe a deeper understanding of the data might result in better classification. As indicated by [A. Rai et. al. ](http://research.microsoft.com/pubs/166309/com273-chintalapudi.pdf), the mean and standard deviation of a signal gives good insights of the type of motion. One important question remains: what window-size should be taken to calculate the standard deviation on? 

Different windows-sizes result in different pdfs of. The figure below shows several pdfs of step, walk and idle given different window-sizes. 

## Data fitting
Since we are not able to observe all possible idle-, walk- and step- motions, the generated pdfs might miss some data. To smoothen our results and overcome the issue of missing data, we do a fit on the pdf. As can be observed from the previous images, a Gaussian might not fit the bill. In order to determine which distribution fit best, we make use of a function developed by Mike Sheppard: [`allfitdist`](http://www.mathworks.com/matlabcentral/fileexchange/34943-fit-all-valid-parametric-probability-distributions-to-data).


The `allfitdist` function tries to fit different distributions and returns a vector of the the top-7 best fits. We have tested several (11) windowsizes: 10, 20, 30, 40, 50, 75, 100, 125, 150, 175 and 200 samples, ranging from 1/5th of a second to a window of 4 seconds. Each windowsize generates 3 fits, one for each activity: walking, idle and step. In total, 33 fits are generated. In the table below the cumulative top-3 fit of each sample is shown.

|distribution                 |  1  |  2  |  3  |
| --------------------------- | --- | --- | --- |
| generalized extreme value   |  30 |  0  |  3  |
| generalized pareto          |  2  |  14 |  3  |
| tlocationscale              |  0  |  18 |  4  |
| logistic                    |  0  |  0  |  15 |
| exponential                 |  1  |  1  |  8  |


From this, it can observed that the 'generalized extreme value'-distribution might be to correct approximation for our data. It is returned as the best fit for all samples, except for the pdf of a windowsize of 10, which probably does not contain enough samples for a good fit.

By using the matlab functions `gevfit` and `gevpdf` we can now compute the probability of (mis)classification, based on a fit of the generalized extreme value distribution.

## Probability of (mis) classification

A 'good' window-size would be a width for which the probability of correct classification is high and the probability for mis-classification is low. By discretising and normalising the pdfs, these probabilities can be calculated.

First, a vector representing the x-axis is assumed to run from 0 to some value K in steps of k, resulting in K/k values. For each x-value, the corresponding y-value of each (idle, step and walk) pdf is calculated, resulting in 3 new vectors, each K/k elements long. These 4 vectors together represent the 3 histograms of each motion-type. 

Normalisation of each histogram is needed to be able to calculate the probability of (mis) classification and is done by dividing each element in the histogram by the sum of each element, multiplied by k, or in matlab notiation:

```
% hist = [K/k x 1]-vector of y-values of a pdf, calculated for each x in 0:k:K
hist_norm = hist / sum(hist*k)
```

We are looking for the probability of (mis)classification of a motiontype `T`, that is: `P(T=i|T=j)`, where `i,j = 1,2,3`, representing the motiontypes idle(1), step(2) and walk(3). Since we use a normalised histogram of a pdf, we know that each value of the histogram represents the probability that, given motiontype `j` is picked, the corresponding x-value is measured: `P(X=x|T=j)`. For each x-value we can also calculate the probability, that given a x-value `x` is sampled, the probability that a certain motiontype `i` is observed: `P(T=i|X=x)`. Since we have discretised the histogram, multiplying the two latter probabilities, results in the first: `P(T=i|T=j) = P(T=i|X=x)*P(X=x|T=j)`. 

Eventually, we get 3x3 = 9 different probabilities:
- `P(T=1|T=1)`: The probability of correctly classifying 'idle'
- `P(T=2|T=1)`: The probability of mis-classifying 'idle' as 'step'
- `P(T=3|T=1)`: The probability of mis-classifying 'idle' as 'walk'
- `P(T=1|T=2)`: The probability of mis-classifying 'step' as 'idle'
- `P(T=2|T=2)`: The probability of correctly classifying 'step'
- `P(T=3|T=2)`: The probability of mis-classifying 'step' as 'walk'
- `P(T=1|T=3)`: The probability of mis-classifying 'walk' as 'idle'
- `P(T=2|T=3)`: The probability of mis-classifying 'walk' as 'step'
- `P(T=3|T=3)`: The probability of correctly classifying 'walk'

Ideally we want to pick a windowsize where the probability of misclassification is 0, and the probability of correct classification is 1. This might not happen, hence windowsizes for which the misclassification of a certain motiontype is low, are preferable for feature selection: e.g. a window in which the probability of misclassification of 'step' for 'idle' is low, while 'walk' for 'idle' is high, might still provide useful cues (when combined with other features) for kNN to classify 'idle' as 'idle' (or certainly, prohibit kNN to classify the sample as 'step'). 

## Results

Just as with the distribution fit test, the following windowsizes are used: 10, 20, 30, 40, 50, 75, 100, 125, 150, 175 and 200 samples, ranging from 1/5th of a second to a window of 4 seconds.


RESULTS FOLLOW WHEN ENOUGH DATASETS ARE COLLECTED.
PRELIMINARIY RESULTS:

```
file = '../logs/log_accelActivity1431006940761_corrected.txt'
sum(motiontype==1) = 8532 % idle samples
sum(motiontype==3) = 6843 % walk samples
sum(motiontype==4) = 3116 % step samples

calcStdMisProb([10 20 30 40 50 75 100 125 150 175 200], 2, 0.01, run, motiontype, magnitude)

ans =
%wsize P(T=1|T=1) P(T=2|T=1) P(T=3|T=1) P(T=1|T=2) P(T=2|T=2) P(T=3|T=2) P(T=1|T=3) P(T=2|T=3) P(T=3|T=3)
10.0000    0.7310    0.2228    0.0462    0.2228    0.5186    0.2586    0.0462    0.2586    0.6951
20.0000    0.7779    0.1893    0.0328    0.1893    0.5696    0.2411    0.0328    0.2411    0.7261
30.0000    0.7775    0.1944    0.0280    0.1944    0.5657    0.2399    0.0280    0.2399    0.7321
40.0000    0.7607    0.2074    0.0319    0.2074    0.5420    0.2506    0.0319    0.2506    0.7175
50.0000    0.7435    0.2188    0.0377    0.2188    0.5302    0.2510    0.0377    0.2510    0.7113
75.0000    0.6758    0.2656    0.0586    0.2656    0.5078    0.2266    0.0586    0.2266    0.7148
100.0000    0.6081    0.3092    0.0827    0.3092    0.4936    0.1972    0.0827    0.1972    0.7201
125.0000    0.5535    0.3404    0.1061    0.3404    0.4865    0.1730    0.1061    0.1730    0.7209
150.0000    0.5062    0.3657    0.1281    0.3657    0.4827    0.1515    0.1281    0.1515    0.7204
175.0000    0.4428    0.4087    0.1485    0.4087    0.4647    0.1266    0.1485    0.1266    0.7249
200.0000    0.4152    0.4298    0.1549    0.4298    0.4680    0.1022    0.1549    0.1022    0.7429
```
