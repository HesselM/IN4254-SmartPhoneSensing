function result = compPdf2(hi, hw)
%INPUT
    % hi = histogram values of 'idle'
    % xi = x-values of histogram of 'idle'
    % hw = histogram values of 'step'
    % xw = x-values of histogram of 'walk'
    %
    %OUTPUT
    % 2x2 matrix:
    %     i w
    %    ----
    % i | a b
    % w | c d
    %
    % a = Probability that a sample of type 'i' is (correctly) classified as i
    % b = Probability that a sample of type 'i' is (mis)-classified as w
    % c = Probability that a sample of type 'w' is (mis)-classified as i
    % d = Probability that a sample of type 'w' is (correctly) classified as w
    %
    % In most ideal situation, the matrix only contains 1's at the diagonal
    % and 0's at the other positions.

    % Assign pdf to correct variables
    % h1 = pdf, with x1 as x-values
    % h2 = pdf, with x2 as x-values
    pdf_h1 = hi;
    pdf_h2 = hw;

    %%%% P(T=t) %%%%
    % What is the probability of picking a sample with type = t from T
    % T = set of all sample types (1, 2)
    % Tt(t) = P(T=t);
    % Note: since each pdf is normalised, P(T=t) should be 1/2 for all t.
    sPdf_h1 = sum(sum(pdf_h1));
    sPdf_h2 = sum(sum(pdf_h2));
    totalh = sPdf_h1+sPdf_h2;
    PTt = [sPdf_h1/totalh, sPdf_h2/totalh];
    
    %%%% P(X=x) %%%%
    % What is the probability of picking x of X (complete set of x's and y's) ?
    % PXx(x) = P(X=x)
    % Since each pdf is equal in size, the probability can be calculated by taking the sum of each individual pdf of that position and normalise it with the total probability of all pdfs together.
    PXx = (pdf_h1+pdf_h2)/ totalh;

    %%%% P(T=t|X=x) %%%%
    % What is the probability of picking an sample with Type t, given that
    % x is chosen.
    % PTtXx(x,t) = P(T=t|X=x) 
    
    PTtXx1 = (pdf_h1 * PTt(1)) ./ PXx;
    PTtXx2 = (pdf_h2 * PTt(2)) ./ PXx;
    
    %remove NaN-values, (caused by division by PXx(i)=0)
    PTtXx1(isnan(PTtXx1)) = 0;
    PTtXx2(isnan(PTtXx2)) = 0;
    
    %%%% P(X=x|T=t) %%%%
    % Given that type = t, what is the probability of getting 'x'?
    % Note, this should equal the pdf..
    % PXxTt(x,t) = P(X=x|T=t) = P(T=t|X=x)*P(x=x)/P(T=t)
    
    PXxTt1 = (PTtXx1 .* PXx) / PTt(1);
    PXxTt2 = (PTtXx2 .* PXx) / PTt(2);

    %remove NaN-values, (caused by division by PTt(i)=0)
    PXxTt1(isnan(PXxTt1)) = 0;
    PXxTt2(isnan(PXxTt2)) = 0;

    %Should be 1:

    %sum(PTt)
    %sum(sum(PXx))
    %sPTtXx = PTtXx1+PTtXx2;                % should be 1 for each value
    %sum(sum(sPTtXx <= 1-1e-10))            % should be 0 (1e-10 is rounding error compensation)
    %sum(sum((PXxTt1 - pdf_h1) >= 1e-10))   % should be 0 (1e-10 is rounding error compensation)
    %sum(sum((PXxTt2 - pdf_h2) >= 1e-10))

    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    % So far we have calculated:
    % - Tt(t)      = P(T=t)
    % - PXx(x)     = P(X=x)
    % - PTtXx(x,t) = P(T=t|X=x)
    % - PXxTt(x,t) = P(X=x|T=t)
    
    % We want to know the probability of mis-classificiation of x
    % That is:
    % P(T=j|T=i), where i = 1,2 and j=1,2
    % T=i can be expanded to x in xi:
    % P(T=j|T=i) = SUM_x=1:end [ P(T=j|X=x)*P(X=x|T=i) ]
    
    % x=xt(1):xt(end), P(T=j|X=x), where t = 1,2 and j=1,2
    
    %P(T=t|T=1)
    
    Pt1t1 = sum(sum(PTtXx1 .* PXxTt1));
    Pt2t1 = sum(sum(PTtXx2 .* PXxTt1));

    Pt1t2 = sum(sum(PTtXx1 .* PXxTt2));
    Pt2t2 = sum(sum(PTtXx2 .* PXxTt2));

    %should be 1:
    sPtxt1 = Pt1t1 + Pt2t1;
    sPtxt2 = Pt1t2 + Pt2t2;

    Pt1t1 = Pt1t1 / sPtxt1;
    Pt2t1 = Pt2t1 / sPtxt1;

    Pt1t2 = Pt1t2 / sPtxt2;
    Pt2t2 = Pt2t2 / sPtxt2;

    % build matrix
    a = Pt1t1;
    b = Pt2t1;
    c = Pt1t2;
    d = Pt2t2;
 
    result = [a b;c d];
end