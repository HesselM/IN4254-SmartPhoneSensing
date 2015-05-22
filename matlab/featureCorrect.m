function fnew = featureCorrect(f, factor)
% remove faulty classifications of features

m    = f(:,1);
mnew = m;

maxidx = size(f,1);
type = m(1);

head  = 0;
thead = type;
for i=1:maxidx

    % if head is larger then 'factor', user activity changed
    if head > factor
        type = thead;
        head = 0;
    end

    % check if classified activity equals current activity
    if m(i) ~= type
        if ((head == 0) || (m(i) == thead))
            head  = head+1;
            thead = m(i);
        else
            %different type
            mnew(i-head:i-1) = ones(head,1)*type;
            head = 0;
            thead = m(i);
        end
    else
        % if it is, check if we have observed faulty classifications
       if (head > 0)
           mnew(i-head:i-1) = ones(head,1)*type;
           head = 0;
       end 
       mnew(i) = m(i);
    end
end


%update feature-vector
fnew(:,  1) = mnew;
fnew(:,2:4) = f(2:4);
