function [h, x] = getNormHist(signal)
    %calculate histogram
    [h, x] = hist(signal,50);
    %normalize
    h  = h  ./ sum(h);
end