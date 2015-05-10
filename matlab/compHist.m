function o = compHist(hi, xi, hs, xs, hw, xw)
%
% hi = histogram values of 'idle'
% xi = x-values of histogram of 'idle'
% hs = histogram values of 'step'
% xs = x-values of histogram of 'step'
% hw = histogram values of 'step'
% xw = x-values of histogram of 'walk'

% find overlap of 'idle' and 'step'
[o_is, o_si, i_is, i_si, x_is] = overlap(hi, xi, hs, xs);

% find overlap of 'step' and 'walk'
[o_sw, o_ws, i_sw, i_ws, x_sw] = overlap(hs, xs, hw, xw);

% find overlap of 'walk' and 'idle'
[o_wi, o_iw, i_wi, i_iw, x_wi] = overlap(hw, xw, hi, xi);

% find overlap of 'walk', 'idle' and 'step'
% intersect(intersect(idle, step), walk)
[x_isw, i_isw, i_wis] = intersect(x_is, xw);
o_wis = sum(hw(i_wis));
o_isw = sum(hi(i_is(i_isw)));
o_swi = sum(hs(i_si(i_isw)));

% compute missing overlaps:
o_isw = o_isw;        % sum of h-values of idle: overlap with step and walk
o_is  = o_is - o_isw; % sum of h-values of idle: overlap with step, without walk
o_iw  = o_iw - o_isw; % sum of h-values of idle: overlap with walk, without step
o_i   = sum(hi) - o_isw - o_is - o_iw; % sum of h-values of idle: without any overlap 

o_swi = o_swi;        % sum of h-values of step: overlap with walk and idle
o_si  = o_si - o_swi; % sum of h-values of step: overlap with idle, without walk
o_sw  = o_sw - o_swi; % sum of h-values of step: overlap with walk, without idle
o_s   = sum(hs) - o_swi - o_si - o_sw; % sum of h-values of step: without any overlap 

o_wis = o_wis;        % sum of h-values of walk: overlap with idle and step
o_wi  = o_wi - o_wis; % sum of h-values of walk: overlap with idle, without step
o_ws  = o_ws - o_wis; % sum of h-values of walk: overlap with step, without idle
o_w   = sum(hw) - o_wis - o_wi - o_ws; % sum of h-values of walk: without any overlap 

%put everything in a matrix
%overlap: none idle  step  walk all
o =     [ o_i  0.00  o_is  o_iw  o_isw;
          o_s  o_si  0.00  o_sw  o_swi;
          o_w  o_wi  o_ws  0.00  o_wis ];
      
%normalise overlap
s = sum(o,2);
s = s(:, ones(1, size(o,2)));
o = o ./ s;
  
end

function [overlap_12, overlap_21, idx1, idx2, xval] = overlap(h1, x1, h2, x2)

    % find equal x-values of 'x1' and 'x2'
    [xval, idx1, idx2] = intersect(x1, x2);

    % determine amount of overlap
    overlap_12 = sum(h1(idx1));
    overlap_21 = sum(h2(idx2));

end