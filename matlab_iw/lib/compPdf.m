% TODO: gaussian smoothing!
function result = compPdf(hi, xi, hw, xw)
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
    x1 = xi;
    x2 = xw;

    %normalise pdf in case it is not yet normalised
    % by normalizing, we are able to compare each PDF with each other
    pdf_h1 = pdf_h1 / sum(pdf_h1);
    pdf_h2 = pdf_h2 / sum(pdf_h2);
    totalh = sum(pdf_h1) + sum(pdf_h2);
    
    %%%% P(T=t) %%%%
    % What is the probability of picking a sample with type = t from T
    % T = set of all samples (1 and 2)
    % Tt(t) = P(T=t);
    % Note: since each pdf is normalised, P(T=t) should be 1/2 for all t.
    PTt = [sum(pdf_h1)/totalh, sum(pdf_h2)/totalh];
    
    %%%% P(X=x) %%%%
    % What is the probability of picking x of X (complete set of x's) ?
    % PXx(x) = P(X=x)
    
    %get all X-values
    X = union(x1, x2);
    
    % get complete Sample space (type independent)
    % S(i) = probability of picking X(i) from X; 
    % ==> P(X = x);
    S = zeros(size(X));
    for i=1:size(X,2)
        tmp1 = pdf_h1(x1==X(i));
        tmp2 = pdf_h2(x2==X(i));
        if isempty(tmp1);tmp1=0;end
        if isempty(tmp2);tmp2=0;end
        S(i) = tmp1 + tmp2 ;
    end
    %normalize, so P(X = (x=1:end)) = 1.
    PXx = S / (totalh); 
    
    %%%% P(T=t|X=x) %%%%
    % What is the probability of picking an sample with Type t, given that
    % x is chosen.
    % PTtXx(x,t) = P(T=t|X=x) 
    
    PTtXx = zeros(size(X, 2), 2);
    for i=1:size(X,2)
        tmp1 = pdf_h1(x1==X(i));
        tmp2 = pdf_h2(x2==X(i));
        if isempty(tmp1);tmp1=0;end
        if isempty(tmp2);tmp2=0;end
        PTtXx(i,1) = (tmp1 / PXx(i)) / totalh;
        PTtXx(i,2) = (tmp2 / PXx(i)) / totalh;
    end
    
    %remove NaN-values, (caused by division by PXx(i)=0)
    PTtXx(isnan(PTtXx)) = 0;
    
    %%%% P(X=x|T=t) %%%%
    % Given that type = t, what is the probability of getting 'x'?
    % Note, this should equal the pdf..
    % PXxTt(x,t) = P(X=x|T=t) = P(T=t|X=x)*P(x=x)/P(T=t)
    
    PXxTt = zeros(size(X, 2), 2);
    for i=1:size(X,2)
        PXxTt(i,1) = PTtXx(i,1)*PXx(i) / PTt(1);
        PXxTt(i,2) = PTtXx(i,2)*PXx(i) / PTt(2);
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
    % P(T=j|T=i), where i = 1,2 and j=1,2
    % T=i can be expanded to x in xi:
    % P(T=j|T=i) = SUM_x=1:end [ P(T=j|X=x)*P(X=x|T=i) ]
    
    % x=xt(1):xt(end), P(T=j|X=x), where t = 1,2 and j=1,2
    
    %P(T=t|T=1)
    
    Pt1t1 = sum(PTtXx(:,1).*PXxTt(:,1));
    Pt2t1 = sum(PTtXx(:,2).*PXxTt(:,1));

    Pt1t2 = sum(PTtXx(:,1).*PXxTt(:,2));
    Pt2t2 = sum(PTtXx(:,2).*PXxTt(:,2));
    
    %should be 1:
    %Pt1t1 + Pt2t1
    %Pt1t2 + Pt2t2
    
    % build matrix
    a = Pt1t1;
    b = Pt2t1;
    c = Pt1t2;
    d = Pt2t2;
 
    result = [a b; c d];
end