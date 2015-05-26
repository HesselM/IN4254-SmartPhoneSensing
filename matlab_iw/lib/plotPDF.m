function plotPDF(Y, K, dgev, hi, xi, hw, xw, fnum, ftitle, expfig, fname)
    % Y = max Y-value
    % K = max X-value
    % dgev = 4x(K/k), matrix, contains generalised extreme value estimation
    % hi/xi = histogram of idle
    % hw/xw = histogram of walk
    % fnum   = figure number
    % ftitle = figure title
    % expfig = true/false, export figure
    % fname  = when export is true, export image with given name

    hi_gev = dgev(1,:);
    xi_gev = dgev(2,:);
    hw_gev = dgev(3,:);
    xw_gev = dgev(4,:);

    %clear figure
    fig = figure(fnum);clf;hold on;
    
    %setup histograms
    bi = bar(xi, hi, 'r');
    bw = bar(xw, hw, 'b');
    alpha(get(bi,'children'),.25)
    alpha(get(bw,'children'),.25)

    %show dicretised generelized extreme value fit
    plot(xi_gev, hi_gev, 'Color',[1,0,0],'LineWidth',2);
    plot(xw_gev, hw_gev, 'Color',[0,0,1],'LineWidth',2);

    %set x-axis limit
    xlim([0 K]);
    ylim([0 Y]);
    
    %set legend
    legend('idle', 'walk','idle (gev)', 'walk (gev)');
    
    %set title
    title(ftitle, 'FontWeight','bold')
    
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