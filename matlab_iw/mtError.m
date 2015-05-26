function result = mtError(log, knn)


err_total = sum(log ~= knn);

error_idle = zeros(1,2);
error_idle(1) = sum((log == 1) & (knn == 1));
error_idle(2) = sum((log == 1) & (knn == 2));

error_walk = zeros(1,2);
error_walk(1) = sum((log == 2) & (knn == 1));
error_walk(2) = sum((log == 2) & (knn == 2));


result = zeros(2, 7);
result(1,1)     = err_total;
result(1,2)     = error_idle(2);
result(1,3)     = error_walk(1);
result(1,4)     = error_idle(1);
result(1,5)     = error_idle(2);
result(1,6)     = error_walk(1);
result(1,7)     = error_walk(2);

result(2,1)     = err_total/size(log,1);            % percent error on dataset
result(2,2)     = result(1,2)/err_total;            % percent 'idle' as 'walk' error on dataset
result(2,3)     = result(1,3)/err_total;            % percent 'walk' as 'idle' error on dataset
result(2,4)     = error_idle(1)/sum(error_idle);    % percent 'idle' correct
result(2,5)     = error_idle(2)/sum(error_idle);    % percent 'idle' wrong
result(2,6)     = error_walk(1)/sum(error_walk);    % percent 'walk' wrong
result(2,7)     = error_walk(2)/sum(error_walk);    % percent 'walk' correct
