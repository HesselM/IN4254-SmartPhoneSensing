function featurePlot(f, fnum)


fi = f(f(:,1) == 1, :);
fw = f(f(:,1) == 3, :);
fs = f(f(:,1) == 4, :);

figure(fnum);clf;hold on;

scatter3(fw(:,2),fw(:,3),fw(:,4), 'SizeData', 1, 'MarkerEdgeColor', [0 0 1]);
scatter3(fs(:,2),fs(:,3),fs(:,4), 'SizeData', 1, 'MarkerEdgeColor', [0 1 0]);
scatter3(fi(:,2),fi(:,3),fi(:,4), 'SizeData', 1, 'MarkerEdgeColor', [1 0 0]);

xlabel('std');
ylabel('mean');
zlabel('nasc');

legend('idle', 'step', 'walk');