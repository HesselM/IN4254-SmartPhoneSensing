function m = knn(dbfeatures, sfeatures, k)

    m = zeros(size(sfeatures,1),1);

    for i=1:size(sfeatures,1)
        
        %select feature
        f = sfeatures(i,:);
        
        %matlab magic: ensure feature vector equals dbfeature vector so we
        %can do subtraction.
        f = f(ones(size(dbfeatures,1),1),:);
        
        %get difference in vectors
        df = dbfeatures(:,2:end) - f;
        df = sum(df.^2,2);  %omit sqrt: time consuming and not needed
        
        %sort on smallest distance first
        [sortedValues,sortIndex] = sort(df,'ascend');
        
        %select best item
        m(i) = mode(dbfeatures(sortIndex(1:k), 1));
    end

end

