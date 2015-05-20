% J.Miog
% H.van der Molen

function [mcor, cor, rnew, mnew] = calcNASC(tmin, tmax, run, m, signal)
    % INPUT
    % tmin   = minimal windowsize to test for correlation
    % tmax   = maximal windowsize to test for correlation
    % run    = [1xN] annotation of run-number 
    % m      = [1xN] type of motion of signal
    % signal = [1xN] signal to check for NASC 
    % OUTPUT
    % mcor   = [1xN] maximum correlation for all samples between mmin->mmax
    % cor    = [tmax-tmin x N] correlation for all samples between mmin->mmax
    % rnew   = run-annotation of mcor
    % mnew   = motion-annotation of mnew
    
    %minimum and maximum run-number
    minrun = min(run);
    maxrun = max(run);

    cor = [];
    mcor = [];
    rnew = [];
    mnew = [];

    for r=minrun:maxrun
        % get signal of run
        sig  = signal(run==r);
        msig = m(run==r);
        rsig = run(run==r);

        %correct max for tmax
        mmax = size(sig, 1);
        mmax = mmax - 2*tmax;

        %check if there are enough samples in sig
        if (mmax > 1)
            %init correlation array
            sig_cor = zeros(mmax,tmax-tmin+1);

            %detemine correlation
            for t = tmin:tmax
                sig_cor(:,t-tmin+1) = autocorrelation(sig, 1:mmax, t);
            end

            %get maximum correlation for each sample
            sig_mcor = max(sig_cor')';
                           
            %attach to results
            cor  = [cor ; sig_cor]; 
            mcor = [mcor; sig_mcor];
            rnew = [rnew; rsig(1:mmax)];
            mnew = [mnew; msig(1:mmax)];
        end
    end
end


function x = autocorrelation(a,m,t)	
    % INPUT
    % a = signal (nx1)
    % m = vector of indices of samples to calculate autocorrelation on (mx1)
    % t = width of window to use in the correlation calculation
    % OUTPUT
    % x = vector of autocorrelation values of all m-samples (mx1)
    
    %matrix: represents index m+k, for all m-samples and all k=0...k=t+1 values
    m_k = coloncatrld(m, m+t-1);

    % SETTING SLIDING WINDOWS

    % start:m, width:t
    %matrix: represents all indices for samples from index m..m+t-1
    %m_t = coloncatrld(m, m+t-1);
    % ==> it turns out m_t equals m_k, when matrices are used
    m_t = m_k;
              
    % start:m+t, width:t
    %matrix: represents all indices for samples from index m+t..m+t+t-1
    mt_t = coloncatrld(m+t, m+t+t-1);
              
    % MEAN CALCULATIONS
    %mean of sliding window for sample m, in range m..m+t-1
    % size: 1*size(m,1)
    %  mean needs to be subtracted from all signal values a(m+k):
    %   matrix a(m_k) = t*size(m,1);  
    %   so we need to repeat the mean t-times    mean_m_t = mean(a(m_t));
              
    mean_m_t = mean(a(m_t));
    mean_m_t = mean_m_t(ones(1,t),:);
    
    %mean of sliding window for sample m, in range m+t..m+t+t-1
    mean_mt_t = mean(a(mt_t));
    mean_mt_t = mean_mt_t(ones(1,t),:);
    
    % EXPECTED VALUE              
    s = sum( (a(m_k) - mean_m_t) .* (a(m_k+t) - mean_mt_t) );
      
    % NORMALISATION (?) 
    % autocor: sum / variation
    x = s ./ (t * std(a(m_t)) .* std(a(mt_t)));
end

% source: http://blogs.mathworks.com/loren/2008/10/13/vectorizing-the-notion-of-colon/
function x = coloncatrld(start, stop)
    % COLONCAT Concatenate colon expressions
    %    X = COLONCAT(START,STOP) returns a vector containing the values
    %    [START(1):STOP(1) START(2):STOP(2) START(END):STOP(END)].

    % Based on Peter Acklam's code for run length decoding.
    len = stop - start + 1;
      
    % keep only sequences whose length is positive
    pos = len > 0;
    start = start(pos);
    stop = stop(pos);
    len = len(pos);
    if isempty(len)
        x = [];
    return;
    end
      
    % expand out the colon expressions
    endlocs = cumsum(len);  
    incr = ones(1, endlocs(end));  
    jumps = start(2:end) - stop(1:end-1);  
    incr(endlocs(1:end-1)+1) = jumps;
    incr(1) = start(1);
    x = cumsum(incr);
              
    rows = size(start,2);
    cols = size(x,2)/rows;
    x = reshape(x, cols, rows);
end