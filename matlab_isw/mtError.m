function result = mtError(log, knn)


err_total = sum(log ~= knn);

error_idle = zeros(1,3);
error_idle(1) = sum((log == 1) & (knn == 1));
error_idle(2) = sum((log == 1) & (knn == 4));
error_idle(3) = sum((log == 1) & (knn == 3));

error_step = zeros(1,3);
error_step(1) = sum((log == 4) & (knn == 1));
error_step(2) = sum((log == 4) & (knn == 4));
error_step(3) = sum((log == 4) & (knn == 3));

error_walk = zeros(1,3);
error_walk(1) = sum((log == 3) & (knn == 1));
error_walk(2) = sum((log == 3) & (knn == 4));
error_walk(3) = sum((log == 3) & (knn == 3));


result = zeros(2, 13);
result(1,1)     = err_total;
result(1,2)     = error_idle(2)+error_idle(3);
result(1,3)     = error_step(1)+error_step(3);
result(1,4)     = error_walk(1)+error_walk(2);
result(1,5:7)   = error_idle;
result(1,8:10)  = error_step;
result(1,11:13) = error_walk;

result(2,1)     = err_total/size(log,1);
result(2,2)     = result(1,2)/err_total;
result(2,3)     = result(1,3)/err_total;
result(2,4)     = result(1,4)/err_total;
result(2,5:7)   = error_idle/sum(error_idle);
result(2,8:10)  = error_step/sum(error_step);
result(2,11:13) = error_walk/sum(error_walk);

