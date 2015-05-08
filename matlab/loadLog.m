function [timestamps, run, accuracy, motiontype, accel, magnitude] = loadLog(file, plot_raw)
    % parse accel-log into matlab usabel vectors;
    % INPUT
    % file     = filename, e.g. '../logs/log_accelActivity1431006940761.txt'
    % plot_raw = true/false, plot raw values in graph

    % LOG LAYOUT:
    % timestamp,run,accuracy,motiontype,x,y,z
    % -> (long,int,int,int,float,float,float)
    % where:
    % -> motiontype: Walking(3), Queueing(2), Idle(1)

    if exist(file, 'file')
        sysvector = tdfread(file, ',');
    else 
        disp(['file: ' file ' does not exist' char(10)]);
        return
    end

    timestamps  = sysvector.timestamp;
    run         = sysvector.run;
    accuracy    = sysvector.accuracy;
    motiontype  = sysvector.motiontype;
    accel       = [sysvector.x, sysvector.y, sysvector.z];
        
    % calculate magnitude
    magnitude   = sqrt(sum(accel.^2, 2));

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % RAW DATA

    if (plot_raw)
        figure(1)
        clf
        hold on
        plot(timestamps, accel);
        plot(timestamps, motiontype, 'Color',[0,0,0]);
        plot(timestamps, magnitude, 'Color',[0,1,1]);
        legend('accel','motiontype','magnitude');
        title('raw accel data ({m/s^2})', 'FontWeight','bold')
    end
end
