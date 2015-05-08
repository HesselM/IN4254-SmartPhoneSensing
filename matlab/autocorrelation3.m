% J.Miog
% H.van der Molen

function [cor, hist_y, hist_x] = autocorrelation3(mmin, mmax, tmin, tmax, signal)
    %correct max for tmax
    mmax = mmax - 2*tmax;

    %init correlation array
    cor = zeros(mmax-mmin+1,tmax-tmin+1);

    %detemine correlation
    for t = tmin:tmax
        cor(:,t-tmin+1) = auto_cor2(signal, mmin:mmax, t);
    end
    
    %get maximum correlation for each sample
    cor = max(cor')';

    %get normalised histogram
    [hist_y, hist_x] = getNormHist(round(cor*100));

    %correct x for multiplication/int-casting
    hist_x = hist_x ./ 100;
end


function x = auto_cor2(a,m,t)	
    %matrix: represents m+k, for all m-samples and all k=0...k=t+1 values
    m_k = arrayfun(@colon, m, m+t-1, 'Uniform', false);
    m_k = vertcat(m_k{:})';


    % sliding windows

    % start:m, width:t
    %matrix: represents all indices for samples from index m..m+t-1
    m_t = arrayfun(@colon, m, m+t-1, 'Uniform', false);
    m_t = vertcat(m_t{:})';

    % start:m+t, width:t
    %matrix: represents all indices for samples from index m+t..m+t+t-1
    mt_t = arrayfun(@colon, m+t, m+t+t-1, 'Uniform', false);
    mt_t = vertcat(mt_t{:})';
    % autocor: sum

    %mean of sliding window for sample m, in range m..m+t-1
    % size: 1*size(m,1)
    mean_m_t = mean(a(m_t));
    
    %mean needs to be subtracted from all signal values a(m+k):
    % matrix a(m_k) = t*size(m,1);  
    % so we need to repeat the mean t-times
    mean_m_t = mean_m_t(ones(1,t),:);
    
    %mean of sliding window for sample m, in range m+t..m+t+t-1
    mean_mt_t = mean(a(mt_t));
    % matrix a(m_k+t) = t*size(m,1);  
    % so we need to repeat the mean t-times
    mean_mt_t = mean_mt_t(ones(1,t),:);
    
    %differences 
    diff1 = a(m_k) - mean_m_t;
    diff2 = a(m_k+t) - mean_mt_t;

    %mutiplication
    mult = diff1 .* diff2;

    %sum
    s    = sum(mult);
      
    % autocor: sum / variation
    x = s ./ (t * std(a(m_t)) .* std(a(mt_t)));
end

function [h, x] = getNormHist(signal)
    %calculate histogram
    [h, x] = hist(signal,unique(signal));
    %normalize
    h  = h  ./ sum(h);
end