function [hi, xi, hs, xs, hw, xw] = calcPdf(motiontype, magnitude, binacc)


%mutiplication by 10 is done for bin-purposes, 
%   to get the histogram accurate at 0.1


[hi, xi] = getNormHist(round(magnitude(motiontype==1)*binacc));
[hw, xw] = getNormHist(round(magnitude(motiontype==3)*binacc));
[hs, xs] = getNormHist(round(magnitude(motiontype==4)*binacc));

xi = xi / binacc;
xs = xs / binacc;
xw = xw / binacc;

end
%{

figure(2)
clf
hold on
plot( xi, hi, 'Color',[1,0,0]);
plot( xw, hw, 'Color',[0,1,0]);
plot( xs, hs, 'Color',[0,0,1]);
legend('idle','walk', 'qstep');
title('pdf of magnitude ({m/s^2})', 'FontWeight','bold')
    %}