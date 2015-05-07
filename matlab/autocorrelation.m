% autocorrelation test
% J.Miog

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% READ SAMPLES FROM LOG
%
%
%%%

if exist(file, 'file')
    sysvector = tdfread(file, ',');
else 
    disp(['file: ' file ' does not exist' char(10)]);
end

timestamps  = sysvector.timestamp;
run         = sysvector.run;
accuracy    = sysvector.accuracy;
motiontype  = sysvector.motiontype;
accel       = [sysvector.x, sysvector.y, sysvector.z];

%remove first 1000 measurements which contains noise due too filter stabilization
if (size(timestamps,1) > 1000)
timestamps = timestamps(1000:end,:);
    run = run(1000:end,:);
    accuracy = accuracy(1000:end,:);
    motiontype = motiontype(1000:end,:);
    accel = accel(1000:end,:);
end

% calculate magnitude
magnitude   = sqrt(sum(accel.^2, 2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RAW DATA PLOT
% includes queuing

figure(1)
clf
hold on
plot(timestamps, accel);
plot(timestamps, motiontype, 'Color',[0,0,0]);
plot(timestamps, magnitude, 'Color',[0,1,1]);
legend('accel','motiontype','magnitude');
title('raw accel data ({m/s^2})', 'FontWeight','bold')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RAW DATA PLOT OF ONLY WALKING

accel_walk = accel(motiontype==3,:);
magnitudeWalk = sqrt(sum(accel_walk.^2,2));
motiontype_walk = motiontype(motiontype==3);

%plot this data
figure(2)
clf
hold on
plot(magnitudeWalk);
plot(motiontype_walk);
legend('walk magnitude','motiontype');
title('magnitude of walking');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCUTE AUTOCORRELATION 
%


