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
magnitude   = sqrt(sum(accel.^2,2));

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
% crunching data to magnitudes of corresponding motiontype

%walking
%with filter now

accel_walk = accel(motiontype==3,:);
magnitudeWalk = sqrt(sum(accel_walk.^2,2));
motiontype_walk = motiontype(motiontype==3);
%filter num => use fdatool in command window
% 30 hz, cutuff = 250
motiontype_walk = conv(motiontype_walk,Num);

% idle
accel_idle = accel(motiontype==1,:);
magnitudeIdle = sqrt(sum(accel_idle.^2,2));
motiontype_idle = motiontype(motiontype==1);
%filter 
motiontype_idle = conv(motiontype_idle,Num);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCULATE STANDARD  DEVIATION OF MAGNITUDE

figure(2)
hold on
h = histogram(magnitudeWalk,'Normalization','probability');
p = histogram(magnitudeIdle,'Normalization','probability');
legend('walk,idle');
title('standard deviation in magnitude of acceleration(m/s^2)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCUTE AUTOCORRELATION 
%
% m = samplenumber;
%  t = lag;
%  k = 0;
%
m_offset = 1;
m_max = length(magnitudeWalk)-200;
t_min = 40;
t_max = 100;
y_walk = zeros(m_max, 1);

for m = 1:m_max
    for t = t_min:t_max
       cor = auto_cor(magnitudeWalk, m+m_offset, t);
       y_walk(m) = max(cor, y_walk(m));     
    end
end

m_offset = 1;
m_max = length(magnitudeIdle)-200;
t_min = 40;
t_max = 100;

y_idle = zeros(m_max, 1);

for m = 1:m_max
    for t = t_min:t_max
       cor = auto_cor(magnitudeIdle, m+m_offset, t);
       y_idle(m) = max(cor, y_idle(m));     
    end
end

%plot data itsel
figure(4)
hold on
nbins = 20;
h = histogram(y_walk,nbins,'Normalization','probability');
p = histogram(y_idle,nbins,'Normalization','probability');
legend('walk','idle');
title('maximum normalized auto-correlation');

