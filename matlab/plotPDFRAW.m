%mutiplication by 10 is done for bin-purposes, 
%   to get the histogram accurate at 0.1
mag_idle = round(magnitude(motiontype==1)*10);
mag_walk = round(magnitude(motiontype==3)*10);
mag_step = round(magnitude(motiontype==4)*10);

[hist_y_idle, hist_x_idle] = getNormHist(mag_idle);
[hist_y_walk, hist_x_walk] = getNormHist(mag_walk);
[hist_y_step, hist_x_step] = getNormHist(mag_step);

figure(2)
clf
hold on
plot( hist_x_idle/10, hist_y_idle, 'Color',[1,0,0]);
plot( hist_x_walk/10, hist_y_walk, 'Color',[0,1,0]);
plot( hist_x_step/10, hist_y_step, 'Color',[0,0,1]);
legend('idle','walk', 'qstep');
title('pdf of magnitude ({m/s^2})', 'FontWeight','bold')