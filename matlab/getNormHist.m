function [h, x] = getNormHist(signal)
    %calculate histogram
    [h, x] = hist(signal,unique(signal));
    %normalize
    h  = h  ./ sum(h);
end