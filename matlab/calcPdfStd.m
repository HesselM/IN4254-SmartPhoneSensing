function [hi, xi, hs, xs, hw, xw] = calcPdfStd(wsize, run, motiontype, magnitude, binacc)
    % INPUT:
    % wsize       = number of samples used in a moving window
    % run         = annotation of run-number           nx1
    % motiontype  = type of motion of accel-sample     nx1
    % magnitude   = magnitude of accel-sample          nx1
    % binacc      = multiplication value for bin accuracy (1x1)
    %                   accuracy = 1/binacc
    % OUTPUT:
    % hi = histogram values of 'idle'
    % xi = x-values of histogram of 'idle'
    % hs = histogram values of 'step'
    % xs = x-values of histogram of 'step'
    % hw = histogram values of 'step'
    % xw = x-values of histogram of 'walk'

    %minimum and maximum run-number
    minrun = min(run);
    maxrun = max(run);

    %init values
    std_idle = 0; 
    std_walk = 0;
    std_step = 0;

    % for each run
    for r=minrun:maxrun

        % get magnitude
        mag = magnitude(run==r);
        mt  = motiontype(run==r);

        % check if there are at least wsize samples 
        % ASSUMPTION: all wsize samples have an equal motiontype!!
        maxidx = size(mag,1) - wsize;
        if (maxidx > 1)
            for idx=1:maxidx

                %get datawindow
                dwindow = mag(idx:idx+wsize);
                
                %determine std of datawindow
                std_dwindow = std(dwindow);
                
                %determine std of datawindow
                mtype = mt(idx); 
                % add std to correct array (walk/idle/step)
                if (mtype == 1) %idle
                    std_idle(end+1) = std_dwindow;
                end
                if (mtype == 3) %walk
                    std_walk(end+1) = std_dwindow;
                end
                if (mtype == 4) %step
                    std_step(end+1) = std_dwindow;
                end
            end
        end
    end

    %mutiplication by 10 is done for bin-purposes, 
    %   to get the histogram accurate at 0.1

    % get normalised histograms
    [hi, xi] = getNormHist(round(std_idle*binacc));
    [hw, xw] = getNormHist(round(std_walk*binacc));
    [hs, xs] = getNormHist(round(std_step*binacc));

    xi = xi/binacc;
    xw = xw/binacc;
    xs = xs/binacc;
end