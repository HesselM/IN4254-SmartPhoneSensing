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

### calcPdfStd
!!-TO BE UPDATED: REMOVE CATEGORISATION AND ADD DISTRIBUTION FIT--!!
```
[hi, xi, hs, xs, hw, xw] = calcPdfStd(wsize, r, m, signal, binacc)
```
INPUT
- wsize  = number which specifies the width of the sliding window to calculate the std over.
- r      = [1xM] run id vector of imported log
- m      = [1xM] annotated motion type of each value in signal
- signal = [1xM] vector to generate PDF from. 
- binacc = accuracy factor 'f', see [getNormHist](#getnormhistsignal)

OUTPUT
- hi = [1xN] histogram values (pdf) of the std of 'idle'
- xi = [1xN] x-values of histogram of the std of  'idle'
- hs = [1xO] histogram values (pdf) of the std of 'step'
- xs = [1xO] x-values of histogram of the std of 'step'
- hw = [1xP] histogram values (pdf) of the std of 'step'
- xw = [1xP] x-values of histogram of  the std of 'walk'

This function calculates the standard deviation of an sample `n` in `signal` using an sliding window of `wsize` samples. The samples used for the standard deviation are chosen to be at position `n:n+wsize`. 

### compPdf


### NASC

## plot-functions

### plotPdfStd

## test-functions
### testNASC
### testPdfStd


