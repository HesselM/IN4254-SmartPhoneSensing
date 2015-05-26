function [m_log m_math] = smoothm5(m, factor)

    idle = 1;
    step = 4;
    walk = 3;

    maxidx = size(m,1);
    m_erode = zeros(size(m));
    m_erode(1) = idle;
    m_math = m_erode;

    erode_i = false;
    to_i    = 0;
    from_i  = 0;

    f2 = round(factor/2);

    

    
    %time taken for filtering: 2*factor
    % factor = 10 --> 20 samples = 2/5 of a second
    for i=2:maxidx-factor

        %erode idle
        dwindow = m((i-1):(i+factor));
        [erode_i, from_i, to_i] = erode(dwindow, factor, idle, i, erode_i, from_i, to_i);

        if erode_i
            m_erode(i) = idle;
        else
            m_erode(i) = m(i);
        end

        % remove glitches
        if (i > factor)
            start = max(1, i-factor);
            m_math(i-f2) = mode(m_erode(start:i));
        end
    end



    %time taken for processing motion
    minwalk = 200; %4seconds = minimal time a 'walk' should take
    minidle = 100; %4seconds = minimal an 'idle' moment should take


    %tracking indices for beginning and end of 'idle' motion
    istart = 0;
    iend = 0
    
    %boolean to track if we are still in motion..
    inmotion = false;

    %counters to determine number of idle, step or walk samples
    icount = 0;
    scount = 0;
    wcount = 0;

    %result motiontype of logical operate
    m_log = ones(size(m_math));

    for i=2:maxidx-factor
        
        if (i > 9199) && (i < 9647)
            disp(sprintf('%d - i:%d s:%d w:%d', i, icount, scount, wcount));
        end

        %check if motion has ended
        if (icount >= minidle) && (istart > iend) && (inmotion) && ((scount > 0) || (wcount > 0))

            % If stepcount > walkcount: more steps detected
            % we found a step if walk < minwalk
            if (istart-iend < minwalk)
                if (scount > wcount)
                    disp(sprintf('MOTION(step): %d-%d', iend, istart));
                    m_log(iend:istart) = step;
                else
                    disp(sprintf('MOTION(?short walk?): %d-%d s/w: %.2f/%.2f', iend, istart, scount/(wcount+scount), wcount/(wcount+scount)));
                    m_log(iend:istart) = walk;
                end
            else
                if (scount > wcount)
                    disp(sprintf('MOTION(?large step?): %d-%d s/w: %.2f/%.2f', iend, istart, scount/(wcount+scount), wcount/(wcount+scount)));
                    m_log(iend:istart) = step;
                else
                    disp(sprintf('MOTION(walk): %d-%d', iend, istart));
                    m_log(iend:istart) = walk;
                end
            end
            
            scount = 0;
            wcount = 0;
            inmotion = false;
        end


        %idle to motion
        if  (m_math(i-1) == idle) && (m_math(i) ~= idle)
            if ((istart + minidle) < i)
                disp(sprintf('%d: transition to motion detected', i));
                scount = 0;
                wcount = 0;
                iend   = i;
                inmotion = true;
            else
                disp(sprintf('%d: idle glitch detected', i));
            end
            icount = 0;
        end

        %motion to idle
        if  (m_math(i-1) ~= idle) && (m_math(i) == idle)
            disp(sprintf('%d: transition to idle detected', i));
            istart = i;
        end


        %step and walk counters
        if (m_math(i) == step)
            scount = scount + 1;
        end

        if (m_math(i) == walk)
            wcount = wcount + 1;
        end

        if (m_math(i) == idle)
            icount = icount + 1;
        end

    end

end



function [doerosion, from, to] = erode(window, factor, type, i, doerosion, from, to)
    % window(2) = m(i);

    % if we transit from 'type', start erosion
    if  (window(1) == type) && (window(2) ~= type)
        doerosion = true;
        from = i;
        %disp(sprintf('start %d (from)', i));
    end

    %stop erosion after factor-elements (unless 'to'-transition is detected)
    if (doerosion) && ((i - from) == factor)
        if (from > to)
            doerosion = false;
        end
        from = 0;
        %disp(sprintf('stop %d (from)', i));
    end
    
    % if we detect a transit over 'factor' samples to idle, start erosion
    if (window(factor+1) ~= type) && (window(factor+2) == type)    
        doerosion = true;
        to        = i+factor;
        %disp(sprintf('start %d (to)', i));
    end

    %if we transit to idle, stop erosion, unless we have detected a new signal
    if (window(1) ~= type) && (window(2) == type)
        if (to > from)
            doerosion = false;
            from      = 0;
        end
        to        = 0;
        %disp(sprintf('stop %d (to)', i));
    end
end

