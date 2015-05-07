% set 'file' var first.
% add file path in home->setPath in matlab itself, point
% to the log folder of the github project ;)
% --> eg: file = '../logs/accelLog1430829445327.txt'


% LOG LAYOUT:
% timestamp,run,accuracy,motiontype,x,y,z
% -> (long,int,int,int,float,float,float)
% where:
% -> motiontype: Walking(3), Queueing(2), Idle(1)

file =  'accelLog1430829445327.txt';

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
% RAW DATA

figure(1)
clf
hold on
plot(timestamps, accel);
plot(timestamps, motiontype, 'Color',[0,0,0]);
plot(timestamps, magnitude, 'Color',[0,1,1]);
legend('accel','motiontype','magnitude');
title('raw accel data ({m/s^2})', 'FontWeight','bold')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PDF - RAW DATA

% matlab does not has a round-operation to 0.1 digits (as done in the paper)
% hence: multiply magnitude with 10, cast to in, and calculate pdf;
mag10_idle    = round(magnitude(motiontype==1)*10);
mag10_queue   = round(magnitude(motiontype==2)*10);
mag10_walking = round(magnitude(motiontype==3)*10);

%calculate histogram
[mag10_idle_h,mag10_idle_x] = hist(mag10_idle,unique(mag10_idle))
[mag10_walk_h,mag10_walk_x] = hist(mag10_walking,unique(mag10_walking))
[mag10_queue_h,mag10_queue_x] = hist(mag10_queue,unique(mag10_queue))

%normalize histogram
mag10_idle_h  = mag10_idle_h  ./ sum(mag10_idle_h)
mag10_walk_h  = mag10_walk_h  ./ sum(mag10_walk_h)
mag10_queue_h = mag10_queue_h ./ sum(mag10_queue_h)

figure(2)
clf
hold on
plot(mag10_idle_x/10, mag10_idle_h, 'Color',[1,0,0]);
plot(mag10_walk_x/10, mag10_walk_h, 'Color',[0,1,0]);
plot(mag10_queue_x/10, mag10_queue_h, 'Color',[0,0,1]);
legend('idle','walk','queue');
title('pdf of raw accel data ({m/s^2})', 'FontWeight','bold')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PDF - RAW DATA - 50 sample bin (~1s)

%following the paper:
% - calculate standard deviation of 1s of samples (50hz)
% - generate histogram/pdf from this
% - < 0.01 should be idle!

% two versions:
% 1) handle each run as a seperate instance
% 2) assume all runs are 1 'big' run, hence the 1s window will cross different motiontypes

% OPTION 1:
minrun = min(run);
maxrun = max(run);

std_idle = 0; 
std_walk = 0;

% for each run
for r=minrun:maxrun

    % get magnitude
    mag = magnitude(run==r);
    mt  = motiontype(run==r);

    % check if there are at least 50 samples 
    % ASSUMPTION: all 50 samples have an equal motiontype!!
    maxidx = size(mag,1) - 50;
    if (maxidx > 1)
        for idx=1:maxidx

            %calculate deviation over 1s (50sample) window
            % and store deviation in correct array (walk/idle)
            if (mt(idx) == 1) %idle
                std_idle(end+1) = std(mag(idx:idx+50));
            end
            if (mt(idx) == 3) %walking
                std_walk(end+1) = std(mag(idx:idx+50));
            end
        end
    end
end

std_idle = round(std_idle*10);
std_walk = round(std_walk*10);

%calculate histogram
[std_idle_h,std_idle_x] = hist(std_idle,unique(std_idle))
[std_walk_h,std_walk_x] = hist(std_walk,unique(std_walk))

%normalize histogram
std_idle_h  = std_idle_h  ./ sum(std_idle_h)
std_walk_h  = std_walk_h  ./ sum(std_walk_h)

figure(3)
clf
hold on
plot(std_idle_x/10, std_idle_h, 'Color',[1,0,0]);
plot(std_walk_x/10, std_walk_h, 'Color',[0,1,0]);
legend('idle','walk');
title('pdf std id raw accel data ({m/s^2})', 'FontWeight','bold')



