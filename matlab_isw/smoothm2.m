function [mnewi, mnewi2] = smoothm2(m, factor)

    idle = 1;
    step = 4;
    walk = 3;

    maxidx = size(m,1);
    mnewi = zeros(size(m));
    mnewi(1) = idle;
    mnewi2 = mnewi;

    erode_i = false;
    to_i    = 0;
    from_i  = 0;

    f2 = round(factor/2);

    for i=2:maxidx-factor
        mnewi(i) = m(i);
%{
        dwindow = m((i-1):(i+factor));
        [erode_i, from_i, to_i] = erode(dwindow, factor, idle, i, erode_i, from_i, to_i);

        if erode_i
            mnewi(i) = idle;
        else
            mnewi(i) = m(i);
        end
%}
        if (i > factor)
            start = max(1, i-factor);
            mnewi2(i-round(factor/2)) = mode(mnewi(start:i));
        end

    end
end



function [doerosion, from, to] = erode(window, factor, type, i, doerosion, from, to)
    % window(2) = m(i);

    % if we transit from 'type', start erosion
    if  (window(1) == type) && (window(2) ~= type)
        doerosion = true;
        from = i;
    disp(sprintf('start %d (from)', i));
    end

    %stop erosion after factor-elements (unless 'to'-transition is detected)
    if (doerosion) && ((i - from) == factor)
        if (from > to)
            doerosion = false;
        end
        from = 0;
        disp(sprintf('stop %d (from)', i));
    end
    
    % if we detect a transit over 'factor' samples to idle, start erosion
    if (window(factor+1) ~= type) && (window(factor+2) == type)    
        doerosion = true;
        to        = i+factor;
        disp(sprintf('start %d (to)', i));
    end

    %if we transit to idle, stop erosion, unless we deteced a new signal
    if (window(1) ~= type) && (window(2) == type)
        if (to > from)
            doerosion = false;
            from      = 0;
        end
        to        = 0;

        disp(sprintf('stop %d (to)', i));
    end
end

