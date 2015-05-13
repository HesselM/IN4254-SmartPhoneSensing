%test different sizes

function r = testPdfStd(wsize, run, motiontype, magnitude)
    binacc = 10;
    r = zeros(size(wsize,2), 10);
    for w=1:size(wsize,2)
        r(w,:) = testPdfStdw( wsize(w), run, motiontype, magnitude, binacc);
    end
end

function r = testPdfStdw(wsize, run, motiontype, magnitude, binacc)
    [hi, xi, hs, xs, hw, xw] = calcPdfStd(wsize, run, motiontype, magnitude, binacc);
    m = compPdf(hi, xi, hs, xs, hw, xw);
    r = [wsize m(:,1)' m(:,2)' m(:,3)'];
end