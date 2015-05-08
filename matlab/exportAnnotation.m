function exportAnnotation(usedLog,t,r,a,m,xyz);
% follow var-order of app:

%used name of old file to generate new filename
filename = usedLog(1:end-4); % remove '.txt'
filename = strcat(filename, '_corrected');
filename = strcat(filename, '.txt');

%open file
fileID = fopen(filename,'w');
fprintf(fileID,'timestamp,run,accuracy,motiontype,x,y,z\n');
for i=1:size(t,1)
    fprintf(fileID,'%d,%d,%d,%d,%.8f,%.8f,%.8f\n',t(i),r(i),a(i),m(i),xyz(i,1), xyz(i,2), xyz(i,3));
end
fclose(fileID);