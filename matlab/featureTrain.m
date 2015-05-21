function features = featureTrain(run, motiontype, accel, wstd, wmean, tmin, tmax)
    % all input-vectors are equal length
    %
    % 
    %
    %
    % OUTPUT:
    % features : [4xM] feature matrix
    %               1 = motiontype (1=idle, 3=walk, 4=step)
    %               2 = std(mag), magnitude of accel, standard deviation, wsize=125
    %               3 = mean(head), heading of accel, mean, not normalised, wsize=200
    %               4 = max(NASC), max( NASC(each accel axis) ), t=40:100


    %calculate magnitude
    magnitude = sqrt(sum(accel.^2, 2));

    %init features vector
    features = zeros(0,4);

    %minimum and maximum run-number
    minrun = min(run);
    maxrun = max(run);

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
        max_nasc = maxidx - 2*tmax;
        maxidx   = min(max_std, min(max_mean, max_nasc));

        if (maxidx > 1)
            for i=1:maxidx

                %Standard Deviation of magnitude
                mag_std  =  std(   mag_r(i:i+wstd));
                mag_type = mode(motion_r(i:i+wstd));

                %Mean of Heading
                a1   = accel_r(i+0:i-1+wmean,:);
                a2   = accel_r(i+1:i+0+wmean,:);
                magh = mean(sqrt(sum((a2 - a1).^2, 2)));
                magh_type = mode(motion_r(i:i+wmean));
            
                %NASC
                cor1 = nasc(i, accel_r(:,1), tmin, tmax);
                cor2 = nasc(i, accel_r(:,2), tmin, tmax);
                cor3 = nasc(i, accel_r(:,3), tmin, tmax);
                cor  = max(cor1, max(cor2, cor3));
                cor_type = motion_r(i);
            
                %select type based on features, 
                % the type indicated by most features is assumed to be correct.
                type = mode([cor_type, magh_type, mag_type]);

                features(end+1,:) = [type, mag_std, magh, cor];
            end
        end
    end
end


function cor = nasc(m, a, tmin, tmax)
    cor = 0;
    for t=tmin:tmax
        s = 0;
        mt      = m:m+t-1;
        mtt     = mt + t;
        meanmt  = mean(a(mt));
        meanmtt = mean(a(mtt));
        for k = 0:t-1
            s = s + ((a(m+k) - meanmt) * (a(m+k+t) - meanmtt));
        end
        cor = max(cor, s / (t*std(a(mt))*std(a(mtt))));
    end
end
