function plotPdfStd(fignum, hi, xi, hs, xs, hw, xw)
    % INPUT:
    % fignum = figure number to use
    % hi = histogram values of 'idle'
    % xi = x-values of histogram of 'idle'
    % hs = histogram values of 'step'
    % xs = x-values of histogram of 'step'
    % hw = histogram values of 'step'
    % xw = x-values of histogram of 'walk'
   
%plot figure
figure(fignum);clf;hold on;
plot( xi, hi, 'Color',[1,0,0]);
plot( xs, hs, 'Color',[0,1,0]);
plot( xw, hw, 'Color',[0,0,1]);
legend('idle','step', 'walk');
title('pdf of std(magnitude) ({m/s^2})', 'FontWeight','bold')