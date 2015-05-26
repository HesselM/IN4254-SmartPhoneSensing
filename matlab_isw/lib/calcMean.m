function [meani, means, meanw] = calcMean(wsize, run, m, signal)
 % INPUT:
    % wsize     = number of samples used in a moving window
    % run       = annotation of run-number           nx1
    % m         = type of motion of accel-sample     nx1
    % signal    = signal used for the mean           nx1

    %minimum and maximum run-number
    minrun = min(run);
    maxrun = max(run);

    %init values
    meani = 0; %zeros(sum(m==1),1); 
    meanw = 0; %zeros(sum(m==3),1); 
    means = 0; %zeros(sum(m==4),1); 

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
                mean_dwindow = mean(dwindow);
                
                %determine motiontype of datawindow
                mwindow = mt(idx:idx+wsize);
                [y,x] = hist(mwindow,unique(mwindow));
                maxx  = x(y==max(y));
                if isempty(maxx)
                    mtype  = mwindow(1);
                else
                    mtype  = maxx(1);
                end


                % add std to correct array (walk/idle/step)
                if (mtype == 1) %idle
                    meani(end+1) = mean_dwindow;
                end
                if (mtype == 3) %walk
                    meanw(end+1) = mean_dwindow;
                end
                if (mtype == 4) %step
                    means(end+1) = mean_dwindow;
                end
            end
        end
    end
end