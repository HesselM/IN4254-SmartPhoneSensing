%test different sizes

function result = testPdfStd(wsize, r, m, signal)
    binacc = 10;
    result = zeros(size(wsize,2), 10);
    for w=1:size(wsize,2)
        result(w,:) = testPdfStdw( wsize(w), r, m, signal, binacc);
    end
end

function r = testPdfStdw(wsize, run, m, signal, binacc)
    %generate std-data
    [stdi, stds, stdw] = calcStd(wsize, run, m, signal);
    
    %create pdf of data
    [hi, xi] = getNormHist(round(stdi*binacc));
    [hw, xw] = getNormHist(round(stdw*binacc));
    [hs, xs] = getNormHist(round(stds*binacc));
    xi = xi / binacc;
    xw = xw / binacc;
    xs = xs / binacc;
    
    %compare pdf
    m = compPdf(hi, xi, hs, xs, hw, xw);
    r = [wsize m(:,1)' m(:,2)' m(:,3)'];
end