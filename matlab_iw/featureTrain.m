function [features ftype] = featureTrain(run, motiontype, accel, wstd, wmean, offset)
    % all input-vectors are equal length

    % OUTPUT:
    % features : [4xM] feature matrix
    %               1 = motiontype (1=idle, 3=walk)
    %               2 = std(mag), magnitude of accel, standard deviation, wsize=wstd
    %               3 = mean(head), heading of accel, mean, not normalised, wsize=wmean

    %RENAME MOTION TYPES
    % step (4) => walk (3)
    % walk (3) => walk (2)
    % idle (1) => idle (1)
    % undef(0) => idle (1)
    motiontype(motiontype==4) = 2;
    motiontype(motiontype==3) = 2;
    motiontype(motiontype==1) = 1;
    motiontype(motiontype==0) = 1;

    %calculate magnitude
    magnitude = sqrt(sum(accel.^2, 2));

    %init features vector
    features = zeros(0,3);

    %minimum and maximum run-number
    minrun = min(run);
    maxrun = max(run);

    ftype = zeros(size(run,1),1);
    for r=minrun:maxrun

        %select data from specified run
        accel_r  = accel(run==r, :);
        run_r    = run(run==r);
        motion_r = motiontype(run==r);
        mag_r    = magnitude(run==r);

        %number of elements in current run
        maxidx = sum(run==r);

        % set maximum window for all calculations
        max_std  = maxidx - wstd;
        max_mean = maxidx - wmean;
        maxidx   = min(max_std, max_mean);

        %index a which this run starts
        start = sum(run<r);

        %do calculations
        if (maxidx > 1)
            for i=1:maxidx
                %progress counter
                %if (mod(i,100) == 0)
                %    disp(sprintf('r:%d/%d i:%d/%d',r, maxrun, i,maxidx));
                %end

                %Standard Deviation of magnitude
                mag_std  =  std(mag_r(i:i+wstd));

                %Mean of Heading
                a1   = accel_r(i+0:i-1+wmean,:);
                a2   = accel_r(i+1:i+0+wmean,:);
                h_mean = mean(sqrt(sum((a2 - a1).^2, 2)));
            
                %select type based on features, 
                % the type indicated by most features is assumed to be correct.
                type = motion_r(i+offset);

                %record type and features
                ftype(start+i) = type;
                features(end+1,:) = [type, mag_std, h_mean];
            end
        end
    end
end