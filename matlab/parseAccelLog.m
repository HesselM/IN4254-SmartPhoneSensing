% set 'file' var first.
% --> eg: file = '../logs/accelLog1430829445327.txt'


% LOG LAYOUT:
% timestamp,run,accuracy,motiontype,x,y,z
% -> (long,int,int,int,float,float,float)
% where:
% -> motiontype: Walking(3), Queueing(2), Idle(1)

if exist(file, 'file')
    sysvector = tdfread(file, ',');
else 
    disp(['file: ' file ' does not exist' char(10)]);
end