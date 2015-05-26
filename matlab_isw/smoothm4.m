function mnew = smoothm4(m)
maxidx = size(m,1);

    idle = 1;
    step = 4;
    walk = 3;


    mnew = zeros(size(m));
    mnew(1:3) = m(1:3);

    for i=4:maxidx-3
        
        mnew(i) = m(i);
        if (m(i-2) == m(i-1)) && (m(i-1) == m(i+1)) && (m(i+1) == m(i+2))
            mnew(i) = m(i-1);
        end

        if (m(i-2) == m(i-1)) && (m(i-1) == m(i+2)) && (m(i+2) == m(i+3))
            mnew(i) = m(i-1);
        end
            
        if (m(i-3) == m(i-2)) && (m(i-2) == m(i+1)) && (m(i+1) == m(i+2))
            mnew(i) = m(i-2);
        end
            
    end
end

