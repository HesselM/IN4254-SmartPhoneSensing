function [result cmall] = calcNASCProb(Y, K, k, r, m, accel, sname)
    % calculate the probabilty of (mis)classification of 
    %   the standard deviation of a given signal and annotation
    % wsize = [1xM] different window sizes to apply the mean on
    % Y     = max Y value (used for plotting)
    % K     = max X value (comparisaon is from x=0:x=K)
    % k     = stepsize of x
    % r     = run id
    % m     = annotated motion
    % signal = signal to be used
    % sname  = name of signal (for plotting)

    %resultmatrix
    result = zeros(4, 10);
    
    addpath('lib');


    cmall = [];


    cm = 0;
    c = 0;
    rnew = 0;
    mnew = 0;

    for i=1:5
        rold = rnew;    
        mold = mnew;
        if i==4
            [cm, c, rnew, mnew] = calcNASC(40, 100, r, m, sqrt(accel(:,1).^2 + accel(:,2).^2 + accel(:,3).^2));
        elseif i==5;
            cm = max(cmall(:,1:3)')'; % max over all xyz accel measurements
        else
            [cm, c, rnew, mnew] = calcNASC(40, 100, r, m, accel(:,i));
        end
        %should be 0!
        sum(rnew-rnew)
        sum(mold-mnew)
                     
        cmall = [cmall cm];

        nasci = cm(mnew==1);
        nascw = cm(mnew==3);
        nascs = cm(mnew==4);

        %get pdfs
        [dgev, hi, xi, hs, xs, hw, xw] = calcPdfHist(nasci, nascs, nascw, K, k);
        hi_gev = dgev(1,:);
        xi_gev = dgev(2,:);
        hs_gev = dgev(3,:);
        xs_gev = dgev(4,:);
        hw_gev = dgev(5,:);
        xw_gev = dgev(6,:);
        
        %plot data
        ftitle = 'normalised pdf of NASC(';
        ftitle = strcat(ftitle, sname);
        ftitle = strcat(ftitle, ') dx=');
        ftitle = strcat(ftitle, num2str(k));
        ftitle = strcat(ftitle, ' i=');
        ftitle = strcat(ftitle, num2str(i));

        expfig = false;
        fname  = 'results/nasc';
        fname  = strcat(fname, sname);

        plotPDF(Y, K, dgev, hi, xi, hs, xs, hw, xw, i, ftitle, expfig, fname)

        %compare pdfs (probability of (mis)classification)
        prob = compPdf(hi_gev, xi_gev, hs_gev, xs_gev, hw_gev, xw_gev);

        %set result values
        result(i,:) = [i, prob(:,1)' prob(:,2)' prob(:,3)'];
                       
    end
                   
    rmpath('lib');
end



