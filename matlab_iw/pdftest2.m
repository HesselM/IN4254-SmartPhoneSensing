function r = pdftest2(f, fign)

addpath('lib');


K = 2;
k = 0.01;
Y = 10;

%mag std
%offset = round((wstd+wmean)/4);

%decompose feature matrix
type  = f(:,1);
mstd  = f(:,2);
hmean = f(:,3);

% get samples per type
stdi = mstd(type==1);
stds = mstd(type==4);
stdw = mstd(type==3);
meani = hmean(type==1);
means = hmean(type==4);
meanw = hmean(type==3);

%std pdf
[dgev, hi, xi, hs, xs, hw, xw] = calcPdfHist(stdi, stds, stdw, K, k);
plotPDF(Y, K, dgev, hi, xi, hs, xs, hw, xw, fign+0, 'pdf std', false, '');


hi_gev_s = dgev(1,:);
xi_gev_s = dgev(2,:);
hs_gev_s = dgev(3,:);
xs_gev_s = dgev(4,:);
hw_gev_s = dgev(5,:);
xw_gev_s = dgev(6,:);

prob = compPdf(hi_gev_s, xi_gev_s, hs_gev_s, xs_gev_s, hw_gev_s, xw_gev_s);
r=zeros(3,9);
r(1,:) = [prob(:,1)' prob(:,2)' prob(:,3)'];

%mean pdf
[dgev, hi, xi, hs, xs, hw, xw] = calcPdfHist(meani, means, meanw, K, k);
plotPDF(Y, K, dgev, hi, xi, hs, xs, hw, xw, fign+1, 'pdf mean', false, '');

hi_gev_m = dgev(1,:);
xi_gev_m = dgev(2,:);
hs_gev_m = dgev(3,:);
xs_gev_m = dgev(4,:);
hw_gev_m = dgev(5,:);
xw_gev_m = dgev(6,:);

prob = compPdf(hi_gev_m, xi_gev_m, hs_gev_m, xs_gev_m, hw_gev_m, xw_gev_m);
r(2,:) = [prob(:,1)' prob(:,2)' prob(:,3)'];

   
pdf_i1 = hi_gev_m(ones(size(hi_gev_m,2),1),:);
pdf_i2 = hi_gev_s(ones(size(hi_gev_s,2),1),:);
pdfi  = pdf_i1 .* pdf_i2';

pdf_s1 = hs_gev_m(ones(size(hs_gev_m,2),1),:);
pdf_s2 = hs_gev_s(ones(size(hs_gev_s,2),1),:);
pdfs  = pdf_s1 .* pdf_s2';

pdf_w1 = hw_gev_m(ones(size(hw_gev_m,2),1),:);
pdf_w2 = hw_gev_s(ones(size(hw_gev_s,2),1),:);
pdfw  = pdf_w1 .* pdf_w2';

%plot
cmapi = pdfi / max(max(pdfi));
cmaps = pdfs / max(max(pdfs));
cmapw = pdfw / max(max(pdfw));
figure(fign+2);clf;hold on;
surf(xi_gev_m, xi_gev_s, pdfi, cmapi, 'EdgeColor','none')
surf(xs_gev_m, xs_gev_s, pdfs, cmaps, 'EdgeColor','none')
surf(xw_gev_m, xw_gev_s, pdfw, cmapw, 'EdgeColor','none')
xlabel('mean (wsize=200)');
ylabel('std (wsize=125)');

%area plot
pib = (((pdfi > pdfs) + (pdfi > pdfw))==2);
psb = (((pdfs > pdfi) + (pdfs > pdfw))==2);
pwb = (((pdfw > pdfs) + (pdfw > pdfi))==2);
figure(fign+3);clf;hold on;
surf(0:k:K, 0:k:K, pib*1, 'FaceColor',[1 0 0], 'EdgeColor','none')
surf(0:k:K, 0:k:K, psb*1, 'FaceColor',[0 1 0], 'EdgeColor','none')
surf(0:k:K, 0:k:K, pwb*1, 'FaceColor',[0 0 1], 'EdgeColor','none')

sum(sum(pdfi(pib)))/sum(sum(pdfi))
sum(sum(pdfs(psb)))/sum(sum(pdfs))
sum(sum(pdfw(pwb)))/sum(sum(pdfw))
          
          
          
prob = compPdf2(pdfi, pdfs, pdfw);
r(3,:) = [prob(:,1)' prob(:,2)' prob(:,3)'];

rmpath('lib');

end