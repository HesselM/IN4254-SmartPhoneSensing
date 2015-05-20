function plotProb(p, fnum, ftitle, expfig, fname)
    %plot probability matrix p
    % FORMAT:
    % wsize P(i|i) P(s|i) P(w|i) P(i|s) P(s|s) P(w|s) P(i|w) P(s|w) P(w|w)
    % wsize P(i|i) P(s|i) P(w|i) P(i|s) P(s|s) P(w|s) P(i|w) P(s|w) P(w|w)
    % ....

    fig = figure(fnum);clf;
    plot(p(:,1), [p(:,2), p(:,6), p(:,10), p(:,3), p(:,4), p(:,7)]);
    
    %axis limit 
    ylim([0 1]);

    %set legend
    legend('ii', 'ss', 'ww', 'is,si', 'iw,wi', 'sw,ws','Location','northwest');
    
    %set title/labels
    title(ftitle, 'FontWeight','bold')
    xlabel('wsize')

    % Export figure
    if (expfig)
        addpath('lib_ext/export_fig')
        set(gcf, 'Color', 'white'); % white bckgr
        export_fig( fig, ...        % figure handle
                   fname,...       % name of output file without extension
                   '-painters', ... % renderer
                   '-png', ...      % file format
                   '-r144' );        % resolution in dpi
        rmpath('lib_ext/export_fig')
    end
end