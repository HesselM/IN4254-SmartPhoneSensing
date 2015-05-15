function features = trainFeatures(timestamps, run, accuracy, motiontype, accel)
% all input-vectors are equal length

%calculate magnitude
mag = sqrt(sum(accel.^2, 2));

% number of features:
% i=1 -> motiontype
% i=2 -> mean(mag), width = x1
% i=3 -> mean(mag), width = x2
% i=4 ->  std(mag), width = x3
% i=5 ->  std(mag), width = x4
% i=6 -> autocor
nFeatures = 6;

%init features vector
features = zeros(size(accel,1),1);

%assign motiontype to first column
features(:,1) = motiontype;

% mean calculation..

% std calculataion..

% autocorrelation..
