% run NASC on dataset in 'file'
% J.Miog
% H. van der Molen

%load datafile
[timestamps, run, accuracy, motiontype, accel, magnitude] = loadLog(file);

%NASC on motion
signal = magnitude(motiontype==3); %walk

%filter signal
% TODO: create code implementation instead of toolbox, so we can use the
% code also in the app.
%signal = conv(signal,Num);
mmin   = 1;
mmax   = size(signal,1);
tmin   = 40;
tmax   = 100;
[cor_walk, hist_y_walk, hist_x_walk] = NASC(mmin, mmax, tmin, tmax, signal);

%NASC when idle
signal = magnitude(motiontype==1); %idle
%filter signal
% TODO: create code implementation instead of toolbox, so we can use the
% code also in the app.
%signal = conv(signal,Num);

mmin   = 1;
mmax   = size(signal,1);
tmin   = 40;
tmax   = 100;
[cor_idle, hist_y_idle, hist_x_idle] = NASC(mmin, mmax, tmin, tmax, signal);

%plot figure
figure(10);
clf;
hold on
plot(hist_x_walk, hist_y_walk, 'Color', [1 0 0]);
plot(hist_x_idle, hist_y_idle, 'Color', [0 1 0]);
legend('walk', 'idle');
title('pdf of autocorrelation of magnitude', 'FontWeight','bold')