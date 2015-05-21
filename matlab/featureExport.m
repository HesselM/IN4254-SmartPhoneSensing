function featureExport(f) 
    %use name of old file to generate new filename
    timestamp = num2str(round(8.64e7 * (now - datenum('1970', 'yyyy'))));
    fname = strcat('features', timestamp);
    fname = strcat(fname, '.txt');

    %open file
    fileID = fopen(fname,'w');
    
    % follow var-order of app:
    fprintf(fileID,'type,std,mean,nasc\n');
    
    %write all entries
    for i=1:size(t,1)
        fprintf(fileID,'%d,%.8f,%.8f,%.8f\n',f(i,1),f(i,2),f(i,3),f(i,4));
    end
    
    %close file
    fclose(fileID);
end