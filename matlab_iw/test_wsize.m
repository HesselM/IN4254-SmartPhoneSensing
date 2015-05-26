function r = test_wsize(wsize, run, mt, accel)
%wsize = Nx1 vector with different wsizes
%run   = Mx1 run-id of sample
%mt    = Mx1 motiontype of sample
%accel = Mx3 of xyz accel measurements

    IDLE = 1;
    WALK = 2;

    % x = 0:k:K
    % --> K = max x-value to evaluate
    % --> k = step size of x-value
    K = 2;
    k = 0.01;

    %use libs
    addpath('lib');
    
    %r = [ wstd wmean offset P(T=i|T=i) P(T=w|T=i) P(T=i|T=w) P(T=w|T=w) ..
    %      wstd wmean offset P(T=i|T=i) P(T=w|T=i) P(T=i|T=w) P(T=w|T=w) ..
    %      ...
    %      wstd wmean offset P(T=i|T=i) P(T=w|T=i) P(T=i|T=w) P(T=w|T=w) ]
    r = zeros(0, 7);

    for wstd = wsize
        for wmean = wsize
            disp(sprintf('wstd:%d wmean:%d', wstd, wmean));
            
            %determine offset (correction for 'wsize')
            offset = round((wmean + wstd)/4);

            %calculate features with given sizes
            %f(:,1) = mt
            %f(:,2) = std
            %f(:,3) = mean
            f = featureTrain(run, mt, accel, wstd, wmean, offset); 

            %categorise features
            f_idle_s = f(f(:,1)==IDLE, 2); %std
            f_walk_s = f(f(:,1)==WALK, 2);
            f_idle_m = f(f(:,1)==IDLE, 3); %mean
            f_walk_m = f(f(:,1)==WALK, 3);

            %determine pdf of features space
            dgev_s = calcPdfHist(f_idle_s, f_walk_s, K, k);
            dgev_m = calcPdfHist(f_idle_m, f_walk_m, K, k);

            %generate combined pdf
            hi_gev_s = dgev_s(1,:); %histogram: idle, std
            hw_gev_s = dgev_s(3,:); %histogram: walk, std
            hi_gev_m = dgev_m(1,:); %histogram: idle, mean
            hw_gev_m = dgev_m(3,:); %histogram: walk, mean

            %pdf of idle of complete feature space
            pdf_i1 = hi_gev_m(ones(size(hi_gev_m,2),1),:);
            pdf_i2 = hi_gev_s(ones(size(hi_gev_s,2),1),:);
            pdfi  = pdf_i1 .* pdf_i2';

            %pdf of walk of complete feature space
            pdf_w1 = hw_gev_m(ones(size(hw_gev_m,2),1),:);
            pdf_w2 = hw_gev_s(ones(size(hw_gev_s,2),1),:);
            pdfw  = pdf_w1 .* pdf_w2';

            %compute probabilites of (mis)-classification in combined feature space
            prob = compPdf2(pdfi, pdfw);

            %store result
            r(end+1,:) = [wstd wmean offset prob(:,1)' prob(:,2)'];
        end
    end

    rmpath('lib');
end