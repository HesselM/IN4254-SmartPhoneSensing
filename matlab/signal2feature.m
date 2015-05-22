function f = signal2feature(accel, wstd, wmean, tmin, tmax)
    %number of elements in accel
    maxidx = size(accel,1);

    % set maximum window for all calculations
    max_std  = maxidx - wstd;
    max_mean = maxidx - wmean;
    max_nasc = maxidx - 2*tmax;
    maxidx   = min(max_std, min(max_mean, max_nasc));

    %init features vector
    f = zeros(maxidx,3);
    
    for i=1:maxidx

        if (mod(i,100) == 0)
            disp(sprintf('i:%d/%d',i,maxidx));
        end

        %Standard Deviation of magnitude
        mag_std = std(sqrt(sum(accel(i:i+wstd,:).^2, 2)));

        %Mean of Heading
        a1   = accel(i+0:i-1+wmean,:);
        a2   = accel(i+1:i+0+wmean,:);
        magh = mean(sqrt(sum((a2 - a1).^2, 2)));

        %NASC
        [cor1,t1] = nasc(i, accel(:,1), tmin, tmax);
        [cor2,t2] = nasc(i, accel(:,2), tmin, tmax);
        [cor3,t3] = nasc(i, accel(:,3), tmin, tmax);
        cor  = max(cor1, max(cor2, cor3));

        %add to feature vector
        f(i,:) = [mag_std, magh, cor];
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
