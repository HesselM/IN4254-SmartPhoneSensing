function result = calcStdProb(wsize, Y, K, k, r, m, signal, sname)
    % calculate the probabilty of (mis)classification of 
    %   the standard deviation of a given signal and annotation
    % wsize = [1xM] different window sizes to apply the std on
    % Y     = max Y value (used for plotting)
    % K     = max X value (comparisaon is from x=0:x=K)
    % k     = stepsize of x
    % r     = run id
    % m     = annotated motion
    % signal = signal to be used
    % sname  = name of signal (for plotting)

    %resultmatrix
    result = zeros(size(wsize,2), 10);
    
    addpath('lib');

    %test each windowsize
    for w=1:size(wsize,2)
        %calculate std of different sizes
        [stdi, stds, stdw] = calcStd(wsize(w), r, m, signal);
        
        %get pdfs
        [dgev, hi, xi, hs, xs, hw, xw] = calcPdfHist(stdi, stds, stdw, K, k);
        hi_gev = dgev(1,:);
        xi_gev = dgev(2,:);
        hs_gev = dgev(3,:);
        xs_gev = dgev(4,:);
        hw_gev = dgev(5,:);
        xw_gev = dgev(6,:);
        
        %plot data
        ftitle = 'normalised pdf of std(';
        ftitle = strcat(ftitle, sname);
        ftitle = strcat(ftitle, ') dx=');
        ftitle = strcat(ftitle, num2str(k));
        ftitle = strcat(ftitle, ' wsize=');
        ftitle = strcat(ftitle, num2str(wsize(w)));
        
        expfig = false;
        fname  = 'results/std';
        fname  = strcat(fname, num2str(wsize(w)));
        fname  = strcat(fname, sname);

        plotPDF(Y, K, dgev, hi, xi, hs, xs, hw, xw, wsize(w), ftitle, expfig, fname)

        %compare pdfs (probability of (mis)classification)
        prob = compPdf(hi_gev, xi_gev, hs_gev, xs_gev, hw_gev, xw_gev);

        %set result values
        result(w,:) = [wsize(w), prob(:,1)' prob(:,2)' prob(:,3)'];
    end
 
    rmpath('lib');
end



