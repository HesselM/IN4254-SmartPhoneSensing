function f = featureImport(fname)
    % parse accel-log into matlab usabel vectors;
    % INPUT
    % file     = filename, e.g. 'features1431006940761.txt'

    if exist(file, 'file')
        sysvector = tdfread(file, ',');
    else 
        disp(['file: ' file ' does not exist' char(10)]);
        return
    end

    t = sysvector.type;
    s = sysvector.std;
    m = sysvector.mean;
    n = sysvector.nasc;
    
    % feature vector
    f = [t s m n];
end
