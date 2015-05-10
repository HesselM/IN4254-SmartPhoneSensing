function result = compHist(hi, xi, hs, xs, hw, xw)
    %INPUT
    % hi = histogram values of 'idle'
    % xi = x-values of histogram of 'idle'
    % hs = histogram values of 'step'
    % xs = x-values of histogram of 'step'
    % hw = histogram values of 'step'
    % xw = x-values of histogram of 'walk'
    %
    %OUTPUT
    % 3x3 matrix:
    %     i s w
    %    ------
    % i | a b c
    % s | d e f
    % w | g h j
    %
    % a = percentage of pdf of 'i' with a probability greater than 's' and 'w'
    % b = percentage of pdf of 'i' with a probability greater than 's'
    % c = percentage of pdf of 'i' with a probability greater than 'w'
    % d = percentage of pdf of 's' with a probability greater than 'i'
    % e = percentage of pdf of 's' with a probability greater than 'w' and 'i'
    % f = percentage of pdf of 's' with a probability greater than 'w'
    % g = percentage of pdf of 'w' with a probability greater than 'i'
    % h = percentage of pdf of 'w' with a probability greater than 's'
    % j = percentage of pdf of 'w' with a probability greater than 'i' and 's'
    %
    % In most ideal situation, the matrix only conatins 1's. This would
    % indicate that none of the pdfs overlap, hence we selected awesome
    % features which are 100% distinguble for each motiontype.
    % >> The best matrix is the matrix with highest values.

    % find percentage of area of 'idle'>'step' and 'step'>'idle'
    [i_s, s_i, xis, his] = overlap(hi, xi, hs, xs);

    % find percentage of area of 'step'>'walk' and 'walk'>'step'
    [s_w, w_s, xsw, hsw] = overlap(hs, xs, hw, xw);

    % find percentage of area of 'walk'>'idle' and 'idle'>'walk'
    [w_i, i_w, xwi, hwi] = overlap(hw, xw, hi, xi);

    % find percentage of area of 'idle&step'>'walk' and 'walk'>'idle&step'
    [is_w, w_is] = overlap(his, xis, hw, xw);

    % find percentage of area of 'step&walk'>'idle' and 'idle'>'step&walk'
    [sw_i, i_sw] = overlap(hsw, xsw, hi, xi);

    % find percentage of area of 'walk&idle'>'step' and 'step'>'walk&idle'
    [wi_s, s_wi] = overlap(hwi, xwi, hs, xs);

    % build matrix
    a = i_sw;
    b = i_s;
    c = i_w;
    d = s_i;
    e = s_wi;
    f = s_w;
    g = w_i;
    h = w_s;
    j = w_is;

    result = [a b c; d e f; g h j];
end

function [h1_prob, h2_prob, x12, h12] = overlap(h1, x1, h2, x2)

    % combined histogram
    x12 = union(x1, x2);
    h12 = zeros(size(x12));
    %assign h1 values
    for i=1:size(x1,2)
       idx_x12 = (x12==x1(i));
       h12(idx_x12) = h1(i);
    end
    %assign h2 values
    for i=1:size(x2,2)
       idx_x12 = (x12==x2(i));
       h12(idx_x12) = max([h12(idx_x12) h2(i)]);
    end
    
    % area estimates
    
    % find equal x-values of 'x1' and 'x2'
    [notused, idx1, idx2] = intersect(x1, x2);

    % get histogram values at intersect-indices
    h1_val = h1(idx1);
    h2_val = h2(idx2);
    
    % determine area of h1 > h2 for each x-value
    h1_top = h1_val - h2_val;           %h1>h2 at interset-window
    h1_top(h1_top < 0) = 0;             %remove negative values (== h2>h1)
    h1_top = sum(h1_val) - sum(h1_top); %area in intersect: h1 < h2
    h1_top = sum(h1) - h1_top;          %area of h1 > h2 

    % get area of h2 which is 'above' h1
    h2_top = h2_val - h1_val;           %h2>h1 at interset-window
    h2_top(h2_top < 0) = 0;             %remove negative values (== h2>h1)
    h2_top = sum(h2_val) - sum(h2_top); %area in intersect: h2 < h1
    h2_top = sum(h2) - h2_top;          %area of h2 > h1
    
    %transform 'area' to probabilities:
    h1_prob = h1_top / sum(h1);
    h2_prob = h2_top / sum(h2);
end