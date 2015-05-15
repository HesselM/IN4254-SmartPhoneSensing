# feature selection

One of the most challenging tasks is to select the correct features. While a trail-and-error approach might give nice results, we believe a deeper understanding of the data might result in better classification. As indicated by [A. Rai et. al. ](http://research.microsoft.com/pubs/166309/com273-chintalapudi.pdf), the mean and standard deviation of a signal gives good insights of the type of motion. One important question remains: what window-size should be taken to calculate the standard deviation on? 

Different windows-sizes result in different pdfs of. The figure below shows several pdfs of step, walk and idle given different window-sizes. 



## data fitting
Since we are not able to observe all possibile idle, walk and step motions, the generated pdfs might miss on some data. To smoothen our results and overcome the issuing of missing data, we do a fit on the pdf. As can be observerd from the previous images, an gaussion might not fit the bill, hence we made used of a function developed by Mike Sheppard: [`allfitdist`](http://www.mathworks.com/matlabcentral/fileexchange/34943-fit-all-valid-parametric-probability-distributions-to-data).


The `allfitdist` funtion tries to fit different distributions, and returns a vector of the the top-7 best fits. We have tested several (11) windowsizes: 10, 20, 30, 40, 50, 75, 100, 125, 150, 175 and 200 samples, ranging from 1/5th of a second to a window of 4 seconds. Each windowsize genereates 3 fits, one for each activity: walking, idle and step. In total, 30 fits are generated. In the table below the cumaltative top 3 fit of each sample is shown.

|distribution                 |  1  |  2  |  3  |
| --------------------------- | --- | --- | --- |
| generalized extreme value   |  30 |  0  |  3  |
| generalized pareto          |  2  |  14 |  3  |
| tlocationscale              |  0  |  18 |  4  |
| logistic                    |  0  |  0  |  15 |
| exponential                 |  1  |  1  |  8  |


From this, it can observed that the 'generalized extreme value'-distribution might be to correct approximation for our data. It is returned as the best fit for all samples, except for the pdf of a windowsize of 10, which probably does not contain enough samples for a good fit.

By using the matlab functions `gevfit` and `gevpdf` we can now compute the probability of (mis) classification, based on a fit on the generalized extreme value distribution.

## probability of (mis) classification


A 'good' window-size would be a width for which the probability of correct classification is high and the probaiblity for mis-classification is low. By discretizing and normalizing the pdfs, these probabilities can be calculated.

First, a vector represeting the x-axis is assumed to run from 0 to some value K in steps of k, resulting in K/k values. For each x-value, the corresponding pdf-value of each (idle, step and walk) pdf is calculated, resulting in 3 new vectors, each K/k elements long. These 4 vectors together represent the 3 histograms of each motion-type. 

Normalization of each histogram is needed to be able to calculate the probability of (mis) classification and is done by dividing each element in the histogram by the sum of each element, multiplied by k, or in matlab notiation:

```
% hist = [K/k x 1]-vector of y-values of a pdf, calculated for each x in 0:k:K
hist_norm = hist / sum(hist*k)
```

We are looking for the probability of (mis)classification of a motiontype `T`, that is: `P(T=i|T=j)`, where `i,j = 1,2,3`, representing the motiontypes idle(1), step(2) and walk(3). Since we use a normalized histogram of an pdf, we know that each value of the histrogram represents the probability that, given motiontype t is picked, the corresponding x-value is measured: `P(X=x|T=j)`. For each x-value we can also calculate the probability, that given that value is samples, the probability that a certain motiontype is observed: `P(T=i|X=x)`. Since we discretized the histogram, multiplying the two functions probabilities, results in the first: `P(T=i|T=j) = P(T=i|X=x)*P(X=x|T=j)`. 

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

Ideally we want to pick an windowsize where the probability of misclassification is 0, and the probabilty of correct classification is 1. This might not happen, hence windowsizes for which the misclassification of a certain motiontype is low, are preferable for feature selection: e.g. a window in which the probabilty of misclassifcation of 'step' for 'idle' is low, while 'walk' for 'idle' is high, might still provide usefull cues (when combined with other features) for kNN to classify 'idle' as 'idle' (or certainly, prohibit kNN to classify the sample as 'step'). 

## Results

Just as with the distribution fit test, the following windosizes are used: 10, 20, 30, 40, 50, 75, 100, 125, 150, 175 and 200 samples, ranging from 1/5th of a second to a window of 4 seconds.



