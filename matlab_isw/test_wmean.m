function result = test_wmean(log_run, log_mt, log_accel, wstd, wsize, tmin, tmax)
result = zeros(11,11);
for w=1:size(wsize,2)
    offset = round((wstd+wsize(w))/4);
    [f_log, ft_log] = featureTrain2(log_run, log_mt, log_accel, wstd, wsize(w), tmin, tmax);
    prob = pdftest2(f_log, 40);
    result(1,(w*3)-1) = offset;
    result(2,(w*3)-1) = wstd;
    result(3:11,(w*3)-1) = prob(1,:);
    result(1,(w*3)-0) = offset;
    result(2,(w*3)-0) = wsize(w);
    result(3:11,(w*3)-0) = prob(2,:);
    result(1,(w*3)+0) = offset;
    result(2,(w*3)+0) = wsize(w);
    result(3:11,(w*3)+0) = prob(3,:);
end
