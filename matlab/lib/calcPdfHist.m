function [dgev, hi, xi, hs, xs, hw, xw] = calcPdfHist(idle, step, walk, K, k)
    %get histograms of: discretised, normalised, generalised extreme
    %                      value distribution fit of the data
    [hi_gev,xi_gev] = getNormGev(idle, K, k);
    [hs_gev,xs_gev] = getNormGev(step, K, k);
    [hw_gev,xw_gev] = getNormGev(walk, K, k);
    %bundle data
    dgev = [hi_gev; xi_gev; hs_gev; xs_gev; hw_gev; xw_gev];

    % get histogram without fit
    [hi,xi] = getNormHist(round(idle*(1/k)), k);
    [hs,xs] = getNormHist(round(step*(1/k)), k);
    [hw,xw] = getNormHist(round(walk*(1/k)), k);
    xi = xi / (1/k);
    xs = xs / (1/k);
    xw = xw / (1/k);
end

function [y,x] = getNormGev(data, K, k)
    %return discretised and normalised values of 
    % a generlised extreme value fit using x-values of 0:k:K
    
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

function [h, x] = getNormHist(signal, k)
    %calculate histogram
    [h, x] = hist(signal,unique(signal));
    %normalize
    h  = h  ./ sum(h*k);
end
