function m = fixAnnotation(rid, is, ie, nt, m, r, sig, fign)
% rid   = ridID of sequence to be corrected
% is    = start index of sequence (read from graph!) 
%    -1 = ignore
%     0 = start 
% ie    = end index of sequence (read from graph!) 
%    -1 = ignore
%     0 = end 
% nt    = correct annotation of sequence
% m     = motiontype array of log
% r     = signal used for correction

idx_start = 0;
idx_end   = 0;
% translate start-index to index in array
if (is > -1)
    idx_start = is + min(find(r==rid));
end

% translate end-index to index in array
if (ie > -1)
    if (ie == 0)
        idx_end = max(find(r==rid));
    else 
    	idx_end = idx_start + (ie-is);
    end
end

% update motion array
if ((idx_start > 0) && (idx_end > 0))
   m(idx_start:idx_end) = nt;
end


%%%%%%%%%%%
% PLOT GRAPHS

m_rid   =   m(r==rid);
sig_rid = sig(r==rid);

% raw data
figure(fign);clf;hold on;
plot(sig_rid, 'Color',[0,0,1]);
plot(  m_rid, 'Color',[1,0,0]);
legend('signal','motiontype');
title('Annotated signal', 'FontWeight','bold');