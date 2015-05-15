function [stdi, stds, stdw] = calcStd(wsize, run, m, signal)
 % INPUT:
    % wsize     = number of samples used in a moving window
    % run       = annotation of run-number           nx1
    % m         = type of motion of accel-sample     nx1
    % signal    = signal used for the std            nx1
    % binacc    = multiplication value for bin accuracy (1x1)
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
    stdi = 0; %zeros(sum(m==1),1); 
    stdw = 0; %zeros(sum(m==3),1); 
    stds = 0; %zeros(sum(m==4),1); 

    % for each run
    for r=minrun:maxrun

        % get signal
        sig = signal(run==r);
        mt  = m(run==r);

        % check if there are at least wsize samples 
        % ASSUMPTION: all wsize samples have an equal m!!
        maxidx = size(sig,1) - wsize;
        if (maxidx > 1)
            for idx=1:maxidx

                %get datawindow
                dwindow = sig(idx:idx+wsize);
                
                %determine std of datawindow
                std_dwindow = std(dwindow);
                
                %determine std of datawindow
                mtype = mt(idx); 
                % add std to correct array (walk/idle/step)
                if (mtype == 1) %idle
                    stdi(end+1) = std_dwindow;
                end
                if (mtype == 3) %walk
                    stdw(end+1) = std_dwindow;
                end
                if (mtype == 4) %step
                    stds(end+1) = std_dwindow;
                end
            end
        end
    end
end