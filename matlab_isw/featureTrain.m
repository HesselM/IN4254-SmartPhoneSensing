function [features ftype] = featureTrain(run, motiontype, accel, wstd, wmean, tmin, tmax)
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

    ftype = zeros(size(run,1), 4);

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

        if (maxidx > 1)
            for i=1:maxidx
                if (mod(i,100) == 0)
                    disp(sprintf('r:%d/%d i:%d/%d',r, maxrun, i,maxidx));
                end

                %Standard Deviation of magnitude
                mag_std  =  std(   mag_r(i:i+wstd));
                mag_type = mode(motion_r(i:i+wstd));

                %Mean of Heading
                a1   = accel_r(i+0:i-1+wmean,:);
                a2   = accel_r(i+1:i+0+wmean,:);
                magh = mean(sqrt(sum((a2 - a1).^2, 2)));
                magh_type = mode(motion_r(i:i+wmean));
            
                %NASC
                cor = 0;
                cor_type = 0;
%{
                [cor1,t1] = nasc(i, accel_r(:,1), tmin, tmax);
                [cor2,t2] = nasc(i, accel_r(:,2), tmin, tmax);
                [cor3,t3] = nasc(i, accel_r(:,3), tmin, tmax);
                %cor      = max(cor1, max(cor2, cor3));
                %cor_type = motion_r(i);

                %maximum correlation
                cor = cor1;
                tcor = t1;
                if (cor2 > cor)
                    cor  = cor2;
                    tcor = t2;
                end
                if (cor3 > cor)
                    cor  = cor3;
                    tcor = t3;
                end
                %assign type
                cor_type = mode(motion_r(i:i+(tcor*2)));
%}
                %select type based on features, 
                % the type indicated by most features is assumed to be correct.
                %ftype(i,1:3) = [cor_type, magh_type, mag_type];
                %ftype(i,  4) = mode(ftype(i,1:3));
                ftype(i,2:3) = [magh_type, mag_type];
                ftype(i,  4) = mode(ftype(i,2:3));
                %type = ftype(i,4);
                type = magh_type;

                features(end+1,:) = [type, mag_std, magh, cor];
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
