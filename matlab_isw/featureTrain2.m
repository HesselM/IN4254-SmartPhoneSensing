function [features ftype] = feature2Train(run, motiontype, accel, wstd, wmean, tmin, tmax)
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
    features = zeros(0,3);

    %minimum and maximum run-number
    minrun = min(run);
    maxrun = max(run);

    ftype = zeros(size(run,1),1);


    offset = round((wmean + wstd)/4);
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
        %max_nasc = maxidx - 2*tmax;
        max_nasc = maxidx;
        maxidx   = min(max_std, min(max_mean, max_nasc));


        start = sum(run<r);
        if (maxidx > 1)
            for i=1:maxidx
                if (mod(i,100) == 0)
                    %disp(sprintf('r:%d/%d i:%d/%d',r, maxrun, i,maxidx));
                end

                %Standard Deviation of magnitude
                mag_std  =  std(mag_r(i:i+wstd));

                %Mean of Heading
                a1   = accel_r(i+0:i-1+wmean,:);
                a2   = accel_r(i+1:i+0+wmean,:);
                h_mean = mean(sqrt(sum((a2 - a1).^2, 2)));
            
                %select type based on features, 
                % the type indicated by most features is assumed to be correct.
                ftype(start+i) = motion_r(i+offset);
                
                features(end+1,:) = [motion_r(i+offset), mag_std, h_mean];
            end
        end
    end
end


function [cor tcor] = nasc(m, a, tmin, tmax)
    cor  = 0;
    tcor = 0;
    for t=tmin:tmax
        s = 0;
        mt      = m:m+t-1;
        mtt     = mt + t;
        meanmt  = mean(a(mt));
        meanmtt = mean(a(mtt));
        for k = 0:t-1
            s = s + ((a(m+k) - meanmt) * (a(m+k+t) - meanmtt));
        end

        chi = s / (t*std(a(mt))*std(a(mtt)));

        if (chi > cor)
            cor  = chi;
            tcor = t; 
        end
    end
end
