#index

- [Functions](#Functions)
- - [logfile-functions](#logfile-functions)
- - - [logImport(file, plot_raw)](#logimportfile-plot_raw)
- - - [logExport(file,t,r,a,m,accel)](#logexportfiletramaccel)
- - [fixAnnotation(rid, is, ie, nt, m, r, sig, fign)](#fixannotationrid-is-ie-nt-m-r-sig-fign)
- - [data-functions](#data-functions)
- - - [getNormHist(signal)](#getnormhistsignal)
- - - [calcPdf(m, signal, binacc)](#calcpdfm-signal-binacc)
- - - [calcStd(wsize, r, m, signal, binacc)](#calcstdwsize-r-m-signal-binacc)
- - - [compPdf(hi, xi, hs, xs, hw, xw)](#comppdfhi-xi-hs-xs-hw-xw)
- - - [NASC(mmin, mmax, tmin, tmax, signal)](#nascmmin-mmax-tmin-tmax-signal)
- - [plot-functions](#plot-functions)
- - - [plotPdfStd](#plotpdfstd)
- - [test-functions](#test-functions)
- - - [testNASC](#testnasc)
- - - [testPdfStd(wsize, r, m, signal)](#testpdfstdwsize-r-m-signal)

#Functions

## logfile-functions

### logImport(file, plot_raw)
```
[t, r, a, m, accel, mag] = logImport(file, plot_raw)
```
INPUT:
- file     = filename, e.g. '../logs/log_accelActivity1431006940761.txt'
- plot_raw = true/false, plot raw values in graph

OUTPUT:
- t        = [1xM] timestamp of each record
- r        = [1xM] run id of record
- a        = [1xM] accuracy of measurement
- m        = [1xM] annotated motion type (idle=1, walk=3, step=4)
- accel    = [3xM] accelerometer data of each record (x=1, y=2, z=3)
- mag      = [1xM] magnitude of accelerometer


Import a logfile. The file should start with a description (name) of each column. Each consecutive line should contain a value of the coresponsing column, seperated with a comma. e.g:
```
timestamp,run,accuracy,motiontype,x,y,z
8098936385000,1,3,0,1.00603710,-0.65838695,0.52148950
8098956771000,1,3,0,0.88303035,-0.73011756,0.43729820
...
```


### logExport(file,t,r,a,m,accel) 
```
logEmport(file,t,r,a,m,accel) 
```
INPUT:
- file     = filename of original log, e.g. '../logs/log_accelActivity1431006940761.txt'
- t        = [1xM] timestamp of each record
- r        = [1xM] run id of record
- a        = [1xM] accuracy of measurement
- m        = [1xM] annotated motion type (idle=1, walk=3, step=4)
- accel    = [3xM] accelerometer data of each record (x=1, y=2, z=3)

Export an (adjusted) (imported) log. The exported logfile wil have the same name as the filename of the imported logfile, extended with "_corrected". The format of the exported file equals the same format as the imported file, e.g:
```
timestamp,run,accuracy,motiontype,x,y,z
8098936385000,1,3,0,1.00603710,-0.65838695,0.52148950
8098956771000,1,3,0,0.88303035,-0.73011756,0.43729820
...
```


### fixAnnotation(rid, is, ie, nt, m, r, sig, fign)
```
m = fixAnnotation(rid, is, ie, nt, m, r, sig, fign)
```
INPUT:
- rid   = run-id to fix annotation of
- is    = start index of section to update (ignore=-1, start=0)
- ie    = end index of section to update (ignore=-1, end=0)
- nt    = new type of selected region
- m     = [1xM] annotated motion type of imported log (idle=1, walk=3, step=4)
- r     = [1xM] run id vector of imported log
- sig   = signal to use annoation with
- fign  = figure number of figrue to show data in

OUTPUT:
- m     = [1xM] updated annotated motion type (idle=1, walk=3, step=4)


Adjust annotation of motiontypes. It can be used to specify or correct errors when recording a dataset. To start using this function, first run it without specifying `is` and `ie`:
```
m = fixAnnotation(rid, -1, -1, -1, m, r, sig, fign)
```
This wil show the signal and motiontype in `figure(fign)`. Using the values of the x-axis, `is` and `ie` can be set to cover the section of which the motiontype should be updated.


## data-functions

###getNormHist(signal)
!!-TO BE UPDATED: REMOVE CATEGORISATION AND ADD DISTRIBUTION FIT--!!
!!-USES DEPRECADED HIST-FUNCTION OF MATLAB-!!
```
[h, x] = getNormHist(signal)
```
INPUT
- signal = [1xM] vector to generate histogram from. 

OUTPUT
- h = [1xN] value of each bin
- x = [1xN] 'category' of each bin (that is, the value in signal, of which 'h(i)' is the frequency from)

NOTE: signal has to be a categorised signal, that is, it should only contain integers. Hence data to generate a histogram of, should be multiplied by a factor 'f' and rounded to the nearest integer, mainting a resolution of '1/f'. 


### calcPdf(m, signal, binacc)
!!-TO BE UPDATED: REMOVE CATEGORISATION AND ADD DISTRIBUTION FIT--!!
```
[hi, xi, hs, xs, hw, xw] = calcPdf(m, signal, binacc)
```
INPUT
- m      = [1xM] annotated motion type of each value in signal
- signal = [1xM] vector to generate PDF from. 
- binacc = accuracy factor 'f', see [getNormHist](#getnormhistsignal)

OUTPUT
- hi = [1xN] histogram values (pdf) of 'idle'
- xi = [1xN] x-values of histogram of 'idle'
- hs = [1xO] histogram values (pdf) of 'step'
- xs = [1xO] x-values of histogram of 'step'
- hw = [1xP] histogram values (pdf) of 'step'
- xw = [1xP] x-values of histogram of 'walk'

This function creates a pdf of a given signal. 

### calcStd(wsize, r, m, signal, binacc)
```
[stdi, stds, stdw] = calcStd(wsize, r, m, signal, binacc)
```
INPUT
- wsize  = number which specifies the width of the sliding window to calculate the std over.
- r      = [1xM] run id vector of imported log
- m      = [1xM] annotated motion type of each value in signal
- signal = [1xM] vector to generate PDF from. 

OUTPUT
- stdi = [1xN] standard deviation of all `idle` samples, given a window size `wsize`
- stds = [1xO] standard deviation of all `step` samples, given a window size `wsize`
- stdw = [1xP] standard deviation of all `walk` samples, given a window size `wsize`

This function calculates the standard deviation of a sample `n` in `signal` using an sliding window of `wsize` samples. The samples used for the standard deviation are chosen to be at position `n:n+wsize`. 

### compPdf(hi, xi, hs, xs, hw, xw)
```
pmatrix = compPdf(hi, xi, hs, xs, hw, xw)
```

INPUT
- hi = [1xN] histogram values (pdf/pdfstd) of 'idle'
- xi = [1xN] x-values of histogram of 'idle'
- hs = [1xO] histogram values (pdf/pdfstd) of the std of 'step'
- xs = [1xO] x-values of histogram of 'step'
- hw = [1xP] histogram values (pdf/pdfstd) of the std of 'step'
- xw = [1xP] x-values of histogram of  'walk'

OUTPUT
- pmatrix = [3x3] a matrix containing probabilities of misclassification:
```
 pmatrix = 3x3 matrix = 
        i s w
        ------
    i | a b c
    s | d e f
    w | g h j
```
- a = Probability that a sample of type 'i' is (correctly) classified as i
- b = Probability that a sample of type 'i' is (mis)-classified as s
- c = Probability that a sample of type 'i' is (mis)-classified as w
- d = Probability that a sample of type 's' is (mis)-classified as i
- e = Probability that a sample of type 's' is (correctly) classified as s
- f = Probability that a sample of type 's' is (mis)-classified as w
- g = Probability that a sample of type 'w' is (mis)-classified as i
- h = Probability that a sample of type 'w' is (mis)-classified as s
- j = Probability that a sample of type 'w' is (correctly) classified as w

This function calculates (using the given pdfs) the probability of missclassication.
It can be used to determine which set of pdfs provides more distinct features. Ideally
`pmatrix` should look like an 3x3 identity matrix with only zeros and ones at the diagonal, indicating that each sample will be correctly classified.

### NASC(mmin, mmax, tmin, tmax, signal)
```
[cor, hist_y, hist_x] = NASC(mmin, mmax, tmin, tmax, signal)
```

INPUT
- mmin   = start index of sequence of samples to apply NASC on
- mmax   = end index of sequence of samples to apply NASC on
- tmin   = minimal windowsize to test for correlation
- tmax   = maximal windowsize to test for correlation
- signal = signal to check for NASC 

OUTPUT:
- cor    = [1x(mmax-mmin)] maximum correlation of interval tmin-tmax of each sample in interval mmin->mmax
- h      = [1xN] value of each bin ( see [getNormHist](#getnormhistsignal) )
- x      = [1xN] 'category' of each bin ( see [getNormHist](#getnormhistsignal) )

This function computes the 'Normalized Auto-correlation based Step Counting' of each sample, based on the function described [by A. Rai et al.](http://research.microsoft.com/pubs/166309/com273-chintalapudi.pdf)

## plot-functions

### plotPdfStd
Plot pdf in a figure


## test-functions
### testNASC
still buggy. Needs to be defined as function. Can be used to test NSAC on different signals


### testPdfStd(wsize, r, m, signal)
DEPRECATED. NEW VERSION IS [`calcStdMisProb.m`](../matlab/calcStdMisProb/m)

```
pmatrix = testPdfStd(wsize, r, m, signal)
```

INPUT
- wsize = [1xN] N different windowsizes to test the [calcPdfStd](#calcpdfstdwsize-r-m-signal-binacc) function
- r     = [1xM] run id vector of imported log
- m     = [1xM] annotated motion type of imported log (idle=1, walk=3, step=4)
- sig   = [1xM] signal for pdf

OUTPUT:
- pmatrix = [Nx10] each row contains the wsize used to calculate the probability of misclassification of the pdfstd and the 9 probabilities calculated by [compPdf](#comppdfhi-xi-hs-xs-hw-xw)

Computes a probability matrix which can be used to compare differen windowsizes to determine which windowsize might be best suitable for feature definition.

Example:
```
>> testPdfStd([10,20,30],run,motiontype,magnitude)

ans =

wsize      a         b         c         d         e         f         g         h         j 
10.0000    0.7208    0.2254    0.0538    0.2254    0.5029    0.2718    0.0538    0.2718    0.6744
20.0000    0.7681    0.1954    0.0365    0.1954    0.5477    0.2569    0.0365    0.2569    0.7066
30.0000    0.7596    0.2038    0.0367    0.2038    0.5595    0.2367    0.0367    0.2367    0.7266

```

