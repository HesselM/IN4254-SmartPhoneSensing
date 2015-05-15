function result = testPdfFit(wsize, r, m, signal)
    result = cell(size(wsize*3,2), 4);
    for w=1:size(wsize,2)
        [stdi, stds, stdw] = calcStd(w, r, m, signal);
        
        %do data fit
        [di dpi] = allfitdist(stdi);
        [ds dps] = allfitdist(stds);
        [dw dpw] = allfitdist(stdw);
        
        result(((w-1)*3)+1,:) = {w, di(1).DistName, di(2).DistName, di(3).DistName};
        result(((w-1)*3)+2,:) = {w, ds(1).DistName, ds(2).DistName, ds(3).DistName};
        result(((w-1)*3)+3,:) = {w, dw(1).DistName, dw(2).DistName, dw(3).DistName};
    end
    
    
    % count occurences
    u1=unique(result(:,2),'stable')
    m1=cellfun(@(x) sum(ismember(result(:,2),x)),u1,'un',0)
    
    u2=unique(result(:,3),'stable')
    m2=cellfun(@(x) sum(ismember(result(:,3),x)),u2,'un',0)
    
    u3=unique(result(:,4),'stable')
    m3=cellfun(@(x) sum(ismember(result(:,4),x)),u3,'un',0)
end
