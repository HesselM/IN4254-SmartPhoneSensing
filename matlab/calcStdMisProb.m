function result = calcStdMisProb(wsize, K, k, r, m, signal)
    %resultmatrix
    result = zeros(size(wsize,2), 10);
    
    %test each windowsize
    for w=1:size(wsize,2)
        %calculate std of different sizes
        [stdi, stds, stdw] = calcStd(wsize(w), r, m, signal);
        
        %get histograms of: discretised, normalised, generalised extreme
        %                      value distribution fit of the data
        [hi_gev,xi_gev] = discNormGev(stdi, K, k);
        [hs_gev,xs_gev] = discNormGev(stds, K, k);
        [hw_gev,xw_gev] = discNormGev(stdw, K, k);
        
        % get histogram without fit
        [hi,xi] = getNormHist(round(stdi*(1/k)));
        [hs,xs] = getNormHist(round(stds*(1/k)));
        [hw,xw] = getNormHist(round(stdw*(1/k)));
        hi = hi / sum(hi*k);
        hs = hs / sum(hs*k);
        hw = hw / sum(hw*k);
        xi = xi / (1/k);
        xs = xs / (1/k);
        xw = xw / (1/k);

        %plot data
        dgev = [hi_gev; xi_gev; hs_gev; xs_gev; hw_gev; xw_gev];
        plotData(wsize(w), K, dgev, hi, xi, hs, xs, hw, xw)

        %determine probabilites of (mis)classification
        prob = compPdf(hi_gev, xi_gev, hs_gev, xs_gev, hw_gev, xw_gev);
        
        %set result values
        result(w,:) = [wsize(w), prob(:,1)' prob(:,2)' prob(:,3)'];
    end
end

function [y,x] = discNormGev(data, K, k)
    parmhat = gevfit(data);
    pk = parmhat(1); %shape, k
    ps = parmhat(2); %scale, sigma
    pm = parmhat(3); %location, mu

    %set x axis
    x = [0:k:K];

    %get y values
    y = gevpdf(x,pk,ps,pm);
    
    %normalise
    y = y / sum(y*k);
end

function plotData(w, K, dgev, hi, xi, hs, xs, hw, xw)
    hi_gev = dgev(1,:);
    xi_gev = dgev(2,:);
    hs_gev = dgev(3,:);
    xs_gev = dgev(4,:);
    hw_gev = dgev(5,:);
    xw_gev = dgev(6,:);

    %clear figure
    figure(w);clf;hold on;
    
    %setup histograms
    bi = bar(xi, hi, 'r', 'stacked');
    bs = bar(xs, hs, 'g', 'stacked');
    br = bar(xw, hw, 'b', 'stacked');
    alpha(get(bi,'children'),.25)
    alpha(get(bs,'children'),.25)
    alpha(get(br,'children'),.25)

    %show dicretised generelized extreme value fit
    plot(xi_gev, hi_gev, 'Color',[1,0,0],'LineWidth',2);
    plot(xs_gev, hs_gev, 'Color',[0,1,0],'LineWidth',2);
    plot(xw_gev, hw_gev, 'Color',[0,0,1],'LineWidth',2);

    %set x-axis limit
    xlim([0 K]);
    
    %set legend
    legend('idle','step', 'walk','idle (gev)','step (gev)', 'walk (gev)');
end