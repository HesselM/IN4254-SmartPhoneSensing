%test different sizes

function r = testPdfStd(wsize, r, m, signal)
    binacc = 10;
    r = zeros(size(wsize,2), 10);
    for w=1:size(wsize,2)
        r(w,:) = testPdfStdw( wsize(w), r, m, signal, binacc);
    end
end

function r = testPdfStdw(wsize, r, m, signal, binacc)
    [hi, xi, hs, xs, hw, xw] = calcPdfStd(wsize, r, m, signal, binacc);
    m = compPdf(hi, xi, hs, xs, hw, xw);
    r = [wsize m(:,1)' m(:,2)' m(:,3)'];
end