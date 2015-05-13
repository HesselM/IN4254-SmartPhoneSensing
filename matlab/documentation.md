#Functions

## log

### logImport(file, plot_raw)
`[t, r, a, m, accel, m] = logImport(file, plot_raw)`
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
- t        = timestamp of each record
- r        = run id of record
- a        = accuracy of measurement
- m        = annotated motion type (idle=1, walk=3, step=4)
- accel    = 


function logExport(usedLog,t,r,a,m,xyz) 
function [arr_motion] = fixAnnotation(run, astart, aend, type, arr_motion, arr_run, arr_magnitude, wsize, show_pdf)



## data

'[hi, xi, hs, xs, hw, xw] = calcPdfStd(wsize, run, motiontype, magnitude, binacc)'


