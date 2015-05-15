# feature selection

One of the most challenging tasks is to select the correct features. While a trail-and-error approach might give nice results, we believe a deeper understanding of the data might result in better classification. As indicated by [A. Rai et. al. ](http://research.microsoft.com/pubs/166309/com273-chintalapudi.pdf), the mean and standard deviation of a signal gives good insights of the type of motion. One important question remains: what window-size should be taken to calculate the standard deviation on? 

Different windows-sizes result in different pdfs of. The figure below shows several pdfs of step, walk and idle given different window-sizes. 



## data fitting
Since we are not able to observe all possibile idle, walk and step motions, the generated pdfs might miss on some data. To smoothen our results and overcome the issuing of missing data, we do a fit on the pdf. As can be observerd from the previous images, an gaussion might not fit the bill, hence we made used of a function developed by Mike Sheppard: [`alldistfit`](http://www.mathworks.com/matlabcentral/fileexchange/34943-fit-all-valid-parametric-probability-distributions-to-data).


The `alldistfit` funtion tries to fit different distributions, and returns a vector of the the top-7 best fits. We have tested several (11) windowsizes: 10, 20, 30, 40, 50, 75, 100, 125, 150, 175 and 200 samples, ranging from 1/5th of a second to a window of 4 seconds. Each windowsize genereates 3 fits, one for each activity: walking, idle and step. In total, 30 fits are generated. In the table below the cumaltative top 3 fit of each sample is shown.

| distribution                | 1  | 2  | 3  | 
| --------------------------- | -- | -- | -- |
| generalized extreme value   | 30 | 0  | 3  |
| generalized pareto          | 2  | 14 | 3  |
| tlocationscale              | 0  | 18 | 4  |
| logistic                    | 0  | 0  | 15 |
| exponential                 | 1  | 1  | 8  |


From this, it can observed that the 'generalized extreme value'-distribution might be to correct approximation for our data. It is returned as the best fit for all samples, except for the pdf of a windowsize of 10, which probably does not contain enough samples for a good fit.

By using the matlab functions `gevfit` and `gevpdf` we can now compute the probability of (mis) classification.

## probability of (mis) classification


A 'good' window-size would be a width for which the probability of correct classification is high and the probaiblity for mis-classification is low. By discretizing and normalizing the pdfs, these probabilities can be calculated:



If we assume a vector 'i', representing the normalized pdf of 'idle', containing N elements,  





