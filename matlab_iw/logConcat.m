function [t, r, a, m, accel, mag] = logConcat(log1, log2)

[t1, r1, a1, m1, accel1, mag1] = logImport(log1, false);
[t2, r2, a2, m2, accel2, mag2] = logImport(log2, false);

%update run numbers
maxr = max(r1);
r2 = r2 + maxr;

%concat arrays:
t = [t1; t2];
r = [r1; r2];
a = [a1; a2];
m = [m1; m2];
accel = [accel1; accel2];
mag = [mag1; mag2];

%current epoch
%http://stackoverflow.com/questions/12661862/converting-epoch-to-date-in-matlab
fname = num2str(round(8.64e7 * (now - datenum('1970', 'yyyy'))));
fname = strcat('../logs/log_accelActivity',fname);
fname = strcat(fname, '.txt');

logExport(fname, t, r, a, m, accel);