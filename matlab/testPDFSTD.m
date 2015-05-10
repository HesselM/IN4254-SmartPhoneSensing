%test different sizes

function testPDFSTD
testPDFSTDw(10);
testPDFSTDw(20);
testPDFSTDw(30);
end

function testPDFSTDw(wsize)
windowsize = wsize;
plotPDFSTD;
figure(wsize);clf;hold on
plot( hist_x_std_idle, hist_y_std_idle, 'Color',[1,0,0]);
plot( hist_x_std_walk, hist_y_std_walk, 'Color',[0,1,0]);
plot( hist_x_std_step, hist_y_std_step, 'Color',[0,0,1]);
legend('idle','walk', 'qstep');
t = 'pdf of std(magnitude), size=';
t = strcat(t, wsize);
t = strcat(t, ' ({m/s^2})');
title(t, 'FontWeight','bold')
end

