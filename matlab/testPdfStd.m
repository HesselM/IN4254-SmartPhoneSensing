%test different sizes

function testPdfStd(run, motiontype, magnitude)
    binacc = 10;
    testPdfStdw(10, run, motiontype, magnitude, binacc)
    testPdfStdw(20, run, motiontype, magnitude, binacc)
    testPdfStdw(30, run, motiontype, magnitude, binacc)
end

function r = testPdfStdw(wsize, run, motiontype, magnitude, binacc)
    [hi, xi, hs, xs, hw, xw] = calcPdfStd(wsize, run, motiontype, magnitude, binacc);
    m = compHist(hi, xi, hs, xs, hw, xw);
    r = [wsize m(:,1)' m(:,2)' m(:,3)'];
end