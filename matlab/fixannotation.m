function [arr_motion] = fixannotation(run, astart, aend, type, arr_motion, arr_run, arr_magnitude, wsize, show_pdf)
% run    = runID of sequence to be corrected
% astart = start index of sequence (read from graph!) 
%       -1 = ignore
%        0 = start 
% aend = end index of sequence (read from graph!) 
%       -1 = ignore
%        0 = end 
% type       = correct annotation of sequence
% arr_motion = motionType array of log
% arr_run    = run array of log
% arr_magnitude = magnitude array determined from log
% wsize         = windowsize for pdf standard deviation
% show_pdf      = true/false, show pdf


idx_start = 0;
idx_end   = 0;
% translate start-index to index in array
if (astart > -1)
    idx_start = astart + min(find(arr_run==run));
end

% translate end-index to index in array
if (aend > -1)
    if (aend == 0)
        idx_end = max(find(arr_run==run));
    else 
    	idx_end = idx_start + (aend-astart);
    end
end

% update motion array
if ((idx_start > 0) && (idx_end > 0))
   arr_motion(idx_start:idx_end) = type;
end


%%%%%%%%%%%
% PLOT GRAPHS

arr_motion_run    = arr_motion(arr_run==run);
arr_magnitude_run = arr_magnitude(arr_run==run);

% raw data
figure(1)
clf
hold on
plot(arr_magnitude_run, 'Color',[0,1,1]);
plot(arr_motion_run, 'Color',[1,0,0]);
legend('magnitude','motiontype');
title('raw accel data ({m/s^2})', 'FontWeight','bold')

if (show_pdf)
    % pdf
    % get & plot histograms
    [idle_h, idle_x] = getNormHist(round(arr_magnitude_run(arr_motion_run==1)*10));
    [walk_h, walk_x] = getNormHist(round(arr_magnitude_run(arr_motion_run==3)*10));
    [step_h, step_x] = getNormHist(round(arr_magnitude_run(arr_motion_run==4)*10));

    figure(2)
    clf
    hold on
    plot(idle_x/10, idle_h, 'Color',[1,0,0]);
    plot(walk_x/10, walk_h, 'Color',[0,1,0]);
    plot(step_x/10, step_h, 'Color',[0,0,1]);
    legend('idle','walk', 'step');
    title('pdf of raw accel data ({m/s^2})', 'FontWeight','bold')

    % pdf of sd of wsize samples

    % check if there are at least wsize
    std_idle = 0;
    std_walk = 0;
    std_step = 0;
    maxidx = size(arr_magnitude_run,1) - wsize;
    if (maxidx > 1)
        for idx=1:maxidx
            %determine motiontype which occures the most in the sampled window
            data_window = arr_motion_run(idx:idx+wsize);
            [h,x] = hist(data_window, unique(data_window));
            mostType = x(h==max(h));
            mostType = mostType(1); %choose first item when even.
            
            %calculate deviation over wsize samples
            % and store deviation in correct array (walk/idle/step)
            if (mostType == 1) %idle
                std_idle(end+1) = std(arr_magnitude_run(idx:idx+wsize));
            end
            if (mostType == 3) %walk
                std_walk(end+1) = std(arr_magnitude_run(idx:idx+wsize));
            end
            if (mostType == 4) %step
                std_step(end+1) = std(arr_magnitude_run(idx:idx+wsize));
            end
        end
    end

    %calculat histogram
    % get & plot histograms
    [std_idle_h, std_idle_x] = getNormHist(round(std_idle*10));
    [std_walk_h, std_walk_x] = getNormHist(round(std_walk*10));
    [std_step_h, std_step_x] = getNormHist(round(std_step*10));

    figure(3)
    clf
    hold on
    plot(std_idle_x/10, std_idle_h, 'Color',[1,0,0]);
    plot(std_walk_x/10, std_walk_h, 'Color',[0,1,0]);
    plot(std_step_x/10, std_step_h, 'Color',[0,0,1]);
    legend('idle','walk', 'step');
    title('pdf of std of raw accel data ({m/s^2})', 'FontWeight','bold')

    end
end

function [mag_hist_pdf, mag_x] = getNormHist(mag)
    %calculate histogram
    [mag_hist, mag_x] = hist(mag,unique(mag));
    %normalize
    mag_hist_pdf  = mag_hist  ./ sum(mag_hist);
end