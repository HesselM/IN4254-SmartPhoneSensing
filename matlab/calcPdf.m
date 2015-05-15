function [hi, xi, hs, xs, hw, xw] = calcPdf(m, signal, binacc)


%mutiplication by 10 is done for bin-purposes, 
%   to get the histogram accurate at 0.1


[hi, xi] = getNormHist(round(signal(m==1)*binacc));
[hw, xw] = getNormHist(round(signal(m==3)*binacc));
[hs, xs] = getNormHist(round(signal(m==4)*binacc));

xi = xi / binacc;
xs = xs / binacc;
xw = xw / binacc;

end