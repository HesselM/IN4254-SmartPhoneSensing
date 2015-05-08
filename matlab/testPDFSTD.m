%test different sizes

windowsize = 10;
plotPDFSTD;

hist_y_std_idle10 = hist_y_std_idle;
hist_x_std_idle10 = hist_x_std_idle;
hist_y_std_walk10 = hist_y_std_walk;
hist_x_std_walk10 = hist_x_std_walk;
hist_y_std_step10 = hist_y_std_step;
hist_x_std_step10 = hist_x_std_step;

windowsize = 20;
plotPDFSTD;

hist_y_std_idle20 = hist_y_std_idle;
hist_x_std_idle20 = hist_x_std_idle;
hist_y_std_walk20 = hist_y_std_walk;
hist_x_std_walk20 = hist_x_std_walk;
hist_y_std_step20 = hist_y_std_step;
hist_x_std_step20 = hist_x_std_step;

windowsize = 30;
plotPDFSTD;

hist_y_std_idle30 = hist_y_std_idle;
hist_x_std_idle30 = hist_x_std_idle;
hist_y_std_walk30 = hist_y_std_walk;
hist_x_std_walk30 = hist_x_std_walk;
hist_y_std_step30 = hist_y_std_step;
hist_x_std_step30 = hist_x_std_step;

windowsize = 50;
plotPDFSTD;

hist_y_std_idle50 = hist_y_std_idle;
hist_x_std_idle50 = hist_x_std_idle;
hist_y_std_walk50 = hist_y_std_walk;
hist_x_std_walk50 = hist_x_std_walk;
hist_y_std_step50 = hist_y_std_step;
hist_x_std_step50 = hist_x_std_step;

windowsize = 75;
plotPDFSTD;

hist_y_std_idle75 = hist_y_std_idle;
hist_x_std_idle75 = hist_x_std_idle;
hist_y_std_walk75 = hist_y_std_walk;
hist_x_std_walk75 = hist_x_std_walk;
hist_y_std_step75 = hist_y_std_step;
hist_x_std_step75 = hist_x_std_step;

windowsize = 100;
plotPDFSTD;

hist_y_std_idle100 = hist_y_std_idle;
hist_x_std_idle100 = hist_x_std_idle;
hist_y_std_walk100 = hist_y_std_walk;
hist_x_std_walk100 = hist_x_std_walk;
hist_y_std_step100 = hist_y_std_step;
hist_x_std_step100 = hist_x_std_step;

windowsize = 150;
plotPDFSTD;

hist_y_std_idle150 = hist_y_std_idle;
hist_x_std_idle150 = hist_x_std_idle;
hist_y_std_walk150 = hist_y_std_walk;
hist_x_std_walk150 = hist_x_std_walk;
hist_y_std_step150 = hist_y_std_step;
hist_x_std_step150 = hist_x_std_step;

windowsize = 200;
plotPDFSTD;

hist_y_std_idle200 = hist_y_std_idle;
hist_x_std_idle200 = hist_x_std_idle;
hist_y_std_walk200 = hist_y_std_walk;
hist_x_std_walk200 = hist_x_std_walk;
hist_y_std_step200 = hist_y_std_step;
hist_x_std_step200 = hist_x_std_step;


windowsize = 250;
plotPDFSTD;

hist_y_std_idle250 = hist_y_std_idle;
hist_x_std_idle250 = hist_x_std_idle;
hist_y_std_walk250 = hist_y_std_walk;
hist_x_std_walk250 = hist_x_std_walk;
hist_y_std_step250 = hist_y_std_step;
hist_x_std_step250 = hist_x_std_step;


%plot results


%plot figure
figure(10);clf;hold on
plot( hist_x_std_idle10, hist_y_std_idle10, 'Color',[1,0,0]);
plot( hist_x_std_walk10, hist_y_std_walk10, 'Color',[0,1,0]);
plot( hist_x_std_step10, hist_y_std_step10, 'Color',[0,0,1]);
legend('idle','walk', 'qstep');
title('pdf of std(magnitude), size=10 ({m/s^2})', 'FontWeight','bold')

figure(20);clf;hold on
plot( hist_x_std_idle20, hist_y_std_idle20, 'Color',[1,0,0]);
plot( hist_x_std_walk20, hist_y_std_walk20, 'Color',[0,1,0]);
plot( hist_x_std_step20, hist_y_std_step20, 'Color',[0,0,1]);
legend('idle','walk', 'qstep');
title('pdf of std(magnitude), size=20 ({m/s^2})', 'FontWeight','bold')

figure(30);clf;hold on
plot( hist_x_std_idle30, hist_y_std_idle30, 'Color',[1,0,0]);
plot( hist_x_std_walk30, hist_y_std_walk30, 'Color',[0,1,0]);
plot( hist_x_std_step30, hist_y_std_step30, 'Color',[0,0,1]);
legend('idle','walk', 'qstep');
title('pdf of std(magnitude), size=30 ({m/s^2})', 'FontWeight','bold')

figure(50);clf;hold on
plot( hist_x_std_idle50, hist_y_std_idle50, 'Color',[1,0,0]);
plot( hist_x_std_walk50, hist_y_std_walk50, 'Color',[0,1,0]);
plot( hist_x_std_step50, hist_y_std_step50, 'Color',[0,0,1]);
legend('idle','walk', 'qstep');
title('pdf of std(magnitude), size=50 ({m/s^2})', 'FontWeight','bold')

figure(75);clf;hold on
plot( hist_x_std_idle75, hist_y_std_idle75, 'Color',[1,0,0]);
plot( hist_x_std_walk75, hist_y_std_walk75, 'Color',[0,1,0]);
plot( hist_x_std_step75, hist_y_std_step75, 'Color',[0,0,1]);
legend('idle','walk', 'qstep');
title('pdf of std(magnitude), size=75 ({m/s^2})', 'FontWeight','bold')

figure(100);clf;hold on
plot( hist_x_std_idle100, hist_y_std_idle100, 'Color',[1,0,0]);
plot( hist_x_std_walk100, hist_y_std_walk100, 'Color',[0,1,0]);
plot( hist_x_std_step100, hist_y_std_step100, 'Color',[0,0,1]);
legend('idle','walk', 'qstep');
title('pdf of std(magnitude), size=100 ({m/s^2})', 'FontWeight','bold')

figure(150);clf;hold on
plot( hist_x_std_idle150, hist_y_std_idle150, 'Color',[1,0,0]);
plot( hist_x_std_walk150, hist_y_std_walk150, 'Color',[0,1,0]);
plot( hist_x_std_step150, hist_y_std_step150, 'Color',[0,0,1]);
legend('idle','walk', 'qstep');
title('pdf of std(magnitude), size=150 ({m/s^2})', 'FontWeight','bold')

figure(200);clf;hold on
plot( hist_x_std_idle200, hist_y_std_idle200, 'Color',[1,0,0]);
plot( hist_x_std_walk200, hist_y_std_walk200, 'Color',[0,1,0]);
plot( hist_x_std_step200, hist_y_std_step200, 'Color',[0,0,1]);
legend('idle','walk', 'qstep');
title('pdf of std(magnitude), size=200 ({m/s^2})', 'FontWeight','bold')

figure(250);clf;hold on
plot( hist_x_std_idle250, hist_y_std_idle250, 'Color',[1,0,0]);
plot( hist_x_std_walk250, hist_y_std_walk250, 'Color',[0,1,0]);
plot( hist_x_std_step250, hist_y_std_step250, 'Color',[0,0,1]);
legend('idle','walk', 'qstep');
title('pdf of std(magnitude), size=250 ({m/s^2})', 'FontWeight','bold')