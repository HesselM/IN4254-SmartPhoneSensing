function f = signal2feature(accel, wstd, wmean)
    %number of elements in accel
    maxidx = size(accel,1);

    % set maximum window for all calculations
    max_std  = maxidx - wstd;
    max_mean = maxidx - wmean;
    maxidx   = min(max_std, max_mean);

    %init features vector
    f = zeros(maxidx,2);
    
    for i=1:maxidx

        if (mod(i,100) == 0)
            %disp(sprintf('i:%d/%d',i,maxidx));
        end

        %Standard Deviation of magnitude
        mag_std = std(sqrt(sum(accel(i:i+wstd,:).^2, 2)));

        %Mean of Heading
        a1   = accel(i+0:i-1+wmean,:);
        a2   = accel(i+1:i+0+wmean,:);
        magh = mean(sqrt(sum((a2 - a1).^2, 2)));

        %add to feature vector
        f(i,:) = [mag_std, magh];
    end
end