%test different sizes

function r = testPdfStd(run, motiontype, magnitude)
    binacc = 10;
    r = zeros(16, 10);
    r( 1,:) = testPdfStdw( 10, run, motiontype, magnitude, binacc);
    r( 2,:) = testPdfStdw( 20, run, motiontype, magnitude, binacc);
    r( 3,:) = testPdfStdw( 30, run, motiontype, magnitude, binacc);
    r( 4,:) = testPdfStdw( 40, run, motiontype, magnitude, binacc);
    r( 5,:) = testPdfStdw( 50, run, motiontype, magnitude, binacc);
    r( 6,:) = testPdfStdw( 60, run, motiontype, magnitude, binacc);
    r( 7,:) = testPdfStdw( 70, run, motiontype, magnitude, binacc);
    r( 8,:) = testPdfStdw( 80, run, motiontype, magnitude, binacc);
    r( 9,:) = testPdfStdw( 90, run, motiontype, magnitude, binacc);
    r(10,:) = testPdfStdw(100, run, motiontype, magnitude, binacc);
    r(11,:) = testPdfStdw(125, run, motiontype, magnitude, binacc);
    r(12,:) = testPdfStdw(150, run, motiontype, magnitude, binacc);
    r(13,:) = testPdfStdw(175, run, motiontype, magnitude, binacc);
    r(14,:) = testPdfStdw(200, run, motiontype, magnitude, binacc);
    r(15,:) = testPdfStdw(225, run, motiontype, magnitude, binacc);
    r(16,:) = testPdfStdw(250, run, motiontype, magnitude, binacc);
end

function r = testPdfStdw(wsize, run, motiontype, magnitude, binacc)
    [hi, xi, hs, xs, hw, xw] = calcPdfStd(wsize, run, motiontype, magnitude, binacc);
    m = compHist(hi, xi, hs, xs, hw, xw);
    r = [wsize m(:,1)' m(:,2)' m(:,3)'];
end