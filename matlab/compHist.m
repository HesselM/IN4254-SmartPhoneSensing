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
    % a = Probability that a sample of type 'i' is (correctly) classified as i
    % b = Probability that a sample of type 'i' is (mis)-classified as s
    % c = Probability that a sample of type 'i' is (mis)-classified as w
    % d = Probability that a sample of type 's' is (mis)-classified as i
    % e = Probability that a sample of type 's' is (correctly) classified as s
    % f = Probability that a sample of type 's' is (mis)-classified as w
    % g = Probability that a sample of type 'w' is (mis)-classified as i
    % h = Probability that a sample of type 'w' is (mis)-classified as s
    % j = Probability that a sample of type 'w' is (correctly) classified as w
    %
    % In most ideal situation, the matrix only contains 1's at the diagonal
    % and 0's at the other positions.

    % Assign pdf to correct variables
    % h1 = pdf, with x1 as x-values
    % h2 = pdf, with x2 as x-values
    % h3 = pdf, with x2 as x-values
    pdf_h1 = hi;
    pdf_h2 = hs;
    pdf_h3 = hw;
    x1 = xi;
    x2 = xs;
    x3 = xw;

    %normalise pdf in case it is not yet normalised
    % by normalizing, we are able to compare each PDF with each other
    pdf_h1 = pdf_h1 / sum(pdf_h1);
    pdf_h2 = pdf_h2 / sum(pdf_h2);
    pdf_h3 = pdf_h3 / sum(pdf_h3);
    totalh = sum(pdf_h1) + sum(pdf_h2) + sum(pdf_h3);
    
    %%%% P(T=t) %%%%
    % What is the probability of picking a sample with type = t from T
    % T = set of all samples (1, 2 and 3)
    % Tt(t) = P(T=t);
    % Note: since each pdf is normalised, P(T=t) should be 1/3 for all t.
    PTt = [sum(pdf_h1)/totalh, sum(pdf_h2)/totalh, sum(pdf_h2)/totalh];
    
    %%%% P(X=x) %%%%
    % What is the probability of picking x of X (complete set of x's) ?
    % PXx(x) = P(X=x)
    
    %get all X-values
    X = union(x1, x2);
    X = union(X , x3);
    
    % get complete Sample space (type independent)
    % S(i) = probability of picking X(i) from X; 
    % ==> P(X = x);
    S = zeros(size(X));
    for i=1:size(X,2)
        tmp1 = pdf_h1(x1==X(i));
        tmp2 = pdf_h2(x2==X(i));
        tmp3 = pdf_h3(x3==X(i));
        if isempty(tmp1);tmp1=0;end
        if isempty(tmp2);tmp2=0;end
        if isempty(tmp3);tmp3=0;end
        S(i) = tmp1 + tmp2 + tmp3;
    end
    %normalize, so P(X = (x=1:end)) = 1.
    PXx = S / (totalh); 
    
    %%%% P(T=t|X=x) %%%%
    % What is the probability of picking an sample with Type t, given that
    % x is chosen.
    % PTtXx(x,t) = P(T=t|X=x) 
    
    PTtXx = zeros(size(X, 2), 3);
    for i=1:size(X,2)
        tmp1 = pdf_h1(x1==X(i));
        tmp2 = pdf_h2(x2==X(i));
        tmp3 = pdf_h3(x3==X(i));
        if isempty(tmp1);tmp1=0;end
        if isempty(tmp2);tmp2=0;end
        if isempty(tmp3);tmp3=0;end
        PTtXx(i,1) = (tmp1 / PXx(i)) / totalh;
        PTtXx(i,2) = (tmp2 / PXx(i)) / totalh;
        PTtXx(i,3) = (tmp3 / PXx(i)) / totalh;
    end
    
    %remove NaN-values, (caused by division by PXx(i)=0)
    PTtXx(isnan(PTtXx)) = 0;
    
    %%%% P(X=x|T=t) %%%%
    % Given that type = t, what is the probability of getting 'x'?
    % Note, this should equal the pdf..
    % PXxTt(x,t) = P(X=x|T=t) = P(T=t|X=x)*P(x=x)/P(T=t)
    
    PXxTt = zeros(size(X, 2), 3);
    for i=1:size(X,2)
        PXxTt(i,1) = PTtXx(i,1)*PXx(i) / PTt(1);
        PXxTt(i,2) = PTtXx(i,2)*PXx(i) / PTt(2);
        PXxTt(i,3) = PTtXx(i,3)*PXx(i) / PTt(3);
    end
    
    %Should be 1:
    %sum(PTt, 2)
    %sum(PXx, 2)
    %sum(PTtXx,2)
    %sum(PXxTt,1)
    
    %remove NaN-values, (caused by division by PTt(i)=0)
    PXxTt(isnan(PXxTt)) = 0;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    % So far we have calculated:
    % - Tt(t)      = P(T=t)
    % - PXx(x)     = P(X=x)
    % - PTtXx(x,t) = P(T=t|X=x)
    % - PXxTt(x,t) = P(X=x|T=t)
    
    % We want to know the probability of mis-classificiation of x
    % That is:
    % P(T=j|T=i), where i = 1,2,3 and j=1,2,3
    % T=i can be expanded to x in xi:
    % P(T=j|T=i) = SUM_x=1:end [ P(T=j|X=x)*P(X=x|T=i) ]
    
    % x=xt(1):xt(end), P(T=j|X=x), where t = 1,2,3 and j=1,2,3
    
    %P(T=t|T=1)
    
    Pt1t1 = sum(PTtXx(:,1).*PXxTt(:,1));
    Pt2t1 = sum(PTtXx(:,2).*PXxTt(:,1));
    Pt3t1 = sum(PTtXx(:,3).*PXxTt(:,1));

    Pt1t2 = sum(PTtXx(:,1).*PXxTt(:,2));
    Pt2t2 = sum(PTtXx(:,2).*PXxTt(:,2));
    Pt3t2 = sum(PTtXx(:,3).*PXxTt(:,2));
    
    Pt1t3 = sum(PTtXx(:,1).*PXxTt(:,3));
    Pt2t3 = sum(PTtXx(:,2).*PXxTt(:,3));
    Pt3t3 = sum(PTtXx(:,3).*PXxTt(:,3));

    %should be 1:
    %Pt1t1 + Pt2t1 + Pt3t1
    %Pt1t2 + Pt2t2 + Pt3t2
    %Pt1t3 + Pt2t3 + Pt3t3
    
    % build matrix
    a = Pt1t1;
    b = Pt2t1;
    c = Pt3t1;
    d = Pt1t2;
    e = Pt2t2;
    f = Pt3t2;
    g = Pt1t3;
    h = Pt2t3;
    j = Pt3t3;
 
    result = [a b c; d e f; g h j];
end