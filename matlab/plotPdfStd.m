%requires to following variables:
% windowsize  = number of samples used in a moving window
% run         = annotation of run-number           nx1
% motiontype  = type of motion of accel-sample     nx1
% magnitude   = magnitude of accel-sample          nx1


minrun = min(run);
maxrun = max(run);

std_idle  = 0; 
std_walk  = 0;
std_step = 0;

% for each run
for r=minrun:maxrun

    % get magnitude
    mag = magnitude(run==r);
    mt  = motiontype(run==r);

    % check if there are at least 50 samples 
    % ASSUMPTION: all 50 samples have an equal motiontype!!
    maxidx = size(mag,1) - windowsize;
    if (maxidx > 1)
        for idx=1:maxidx
            %determine motiontype which occures the most in the sampled window
            data_window = mt(idx:idx+windowsize);
            mostType = data_window(1); %if all types are equal
            if (mean(data_window ~= data_window(1)))
                [h,x] = hist(data_window, unique(data_window));
                mostType = x(h==max(h));
                mostType = mostType(1); %choose first item when even.
            end

            %calculate deviation over wsize samples
            % and store deviation in correct array (walk/idle/step)
            if (mostType == 1) %idle
                std_idle(end+1) = std(mag(idx:idx+windowsize));
            end
            if (mostType == 3) %walk
                std_walk(end+1) = std(mag(idx:idx+windowsize));
            end
            if (mostType == 4) %step
                std_step(end+1) = std(mag(idx:idx+windowsize));
            end
        end
    end
end

%mutiplication by 10 is done for bin-purposes, 
%   to get the histogram accurate at 0.1

std_idle = round(std_idle*10);
std_walk = round(std_walk*10);
std_step = round(std_step*10);

% get normalised histograms
[hist_y_std_idle, hist_x_std_idle] = getNormHist(std_idle);
[hist_y_std_walk, hist_x_std_walk] = getNormHist(std_walk);
[hist_y_std_step, hist_x_std_step] = getNormHist(std_step);

hist_x_std_idle = hist_x_std_idle/10;
hist_x_std_walk = hist_x_std_walk/10;
hist_x_std_step = hist_x_std_step/10;

%plot figure
figure(3)
clf
hold on
plot( hist_x_std_idle, hist_y_std_idle, 'Color',[1,0,0]);
plot( hist_x_std_walk, hist_y_std_walk, 'Color',[0,1,0]);
plot( hist_x_std_step, hist_y_std_step, 'Color',[0,0,1]);
legend('idle','walk', 'qstep');
title('pdf of std(magnitude) ({m/s^2})', 'FontWeight','bold')