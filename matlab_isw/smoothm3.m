function mnew = smoothm2(m, factor)
% Erosion and dilation
% loop over all types t=1,3,4
%   - erode t ~= m, with factor/2
%   - dilate t = m, with factor/2

maxidx = size(m,1);

mnew = m;

%always start in idle state
mnew(1) = 1;

erodei = 0; %index

for i=2:maxidx

    % if we transit from idle, start erosion
    if (m(i-1) == 1) &&  (m(i) ~= 1)
        erodei = i;
    end

    %apply erosion if we have not yet transited back to idle
    if (erodei > 0) && ((i - erodei) == factor)
        mnew(erodei:(i-1)) = ones(1, factor);
        erodei = 0;
    end

    % if we transit to idle, erode previous elements
    if (m(i-1) ~= 1) && (m(i) == 1 )
        start = max(i - factor, 1);
        if erodei > 0
            start = erodei;
        end
        
        %apply erosion
        mnew(start:i-1) = 1;

        erodei = 0;
    end
end


