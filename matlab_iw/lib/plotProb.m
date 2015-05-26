function plotProb(p, fnum, ftitle, expfig, fname)
    %plot probability matrix p
    % FORMAT:
    % wsize P(i|i) P(w|i) P(i|w) P(w|w)
    % wsize P(i|i) P(w|i) P(i|w) P(w|w)
    % ....

    fig = figure(fnum);clf;
    plot(p(:,1), [p(:,4), p(:,2), p(:,3))]);
    
    %axis limit 
    ylim([0 1]);

    %set legend
    legend('ii', 'ww', 'iw', 'wi','Location','northwest');
    
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