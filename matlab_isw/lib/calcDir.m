function [angle mnew rnew] = calcDir(run, m, accel, normalise)
 % INPUT:
    % run       = annotation of run-number           nx1
    % m         = type of motion of accel-sample     nx1
    % signal    = signal used for the head           nx3 (accel: xyz)
    % normalise = true/false, normalise accel samples

    %minimum and maximum run-number
    minrun = min(run);
    maxrun = max(run);

    %init values
    meani = 0; %zeros(sum(m==1),1); 
    meanw = 0; %zeros(sum(m==3),1); 
    means = 0; %zeros(sum(m==4),1); 

    angle = 0;

    mnew = 0;
    rnew = 0;

    for r=minrun:maxrun
        % get signal
        sig = accel(run==r, :);
        mrun = m(run==r);
        rrun = run(run==r);

        maxidx = size(sig,1);
        if (maxidx > 1)
            for idx=2:maxidx
                a1 = sig(idx-1,:);
                a2 = sig(idx  ,:);

                if (normalise)
                    a1 = a1 / sqrt(a1(1).^2 + a1(2).^2 + a1(3).^2);
                    a2 = a2 / sqrt(a2(1).^2 + a2(2).^2 + a2(3).^2);
                end

                %change in direction
                da = a2 - a1;
                mag = sqrt(da(1).^2 + da(2).^2 + da(3).^2);


                angle(end+1) = mag;

                %mag1 = sqrt(a1(1).^2 + a1(2).^2 + a1(3).^2);
                %mag2 = sqrt(a2(1).^2 + a2(2).^2 + a2(3).^2);
                %angle(end+1) = acos( (a1(1)*a2(1) + a1(2)*a2(2) + a1(3)*a2(3)) / (mag1*mag2) );


                mnew(end+1) = mrun(idx);
                rnew(end+1) = mrun(idx);
            end
        end
    end
end