#Functions

## log

### logImport(file, plot_raw)
```
[t, r, a, m, accel, mag] = logImport(file, plot_raw)
```
Import a logfile. The file should start with a description (name) of each column. Each consecutive line should contain a value of the coresponsing column, seperated with a comma. e.g:
```
timestamp,run,accuracy,motiontype,x,y,z
8098936385000,1,3,0,1.00603710,-0.65838695,0.52148950
8098956771000,1,3,0,0.88303035,-0.73011756,0.43729820
...
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


### logExport(usedLog,t,r,a,m,xyz) 

### fixAnnotation(rid, is, ie, nt, m, r, sig, fign)
```
m = fixAnnotation(rid, is, ie, nt, m, r, sig, fign)
```
Adjust annotation of motiontypes. It can be used to specify or correct errors when recording a dataset. To start using this function, first run it without specifying `is` and `ie`:
```
m = fixAnnotation(rid, -1, -1, -1, m, r, sig, fign)
```
This wil show the signal and motiontype in `figure(fign)`. Using the values of the x-axis, `is` and `ie` can be set to cover the section of which the motiontype should be updated.

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




## data

'[hi, xi, hs, xs, hw, xw] = calcPdfStd(wsize, run, motiontype, magnitude, binacc)'


