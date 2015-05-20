function result = calcAngle(wsize, Y, K, k, r, m, accel)
    %resultmatrix
    result = zeros(size(wsize,2), 10);
    
    %test each windowsize
    for w=1:size(wsize,2)
        %calculate mean of different sizes

        %signal = accelerometer
        % calculate magnitude
        %mag = sqrt(accel(:,1).^2 + accel(:,2).^2 + accel(:,3).^2);
        % calculate angles of motion
        %a1 = atan2(accel(:,1), mag);
        %a2 = atan2(accel(:,2), mag);
        %a3 = atan2(accel(:,3), mag);
        %angle = [a1 a2 a3]

        mean_angle = zeros(size(angle,1)-w, 3);
        for i=1:size(mean_angle,1)
            mean_angle(i,:) = mean(angle(i:i+w,:));
        end

        %calculate magnitude of angle
        mag_angle = sqrt(mean_angle(:,1).^2 + mean_angle(:,2).^2 + mean_angle(:,3).^2)
    
        % remove unused values due too wsize
        m_w = m(1:size(mean_angle,1));
        r_w = r(1:size(mean_angle,1));

        %calcStdMisProb(wsize, Y, K, k, r_w, m_w, mag_angle)

        %
        meani = mag_angle(m_w==1,:)
        means = mag_angle(m_w==4,:)
        meanw = mag_angle(m_w==3,:)

        %get histograms of: discretised, normalised, generalised extreme
        %                      value distribution fit of the data
        [hi_gev,xi_gev] = discNormGev(meani, K, k);
        [hs_gev,xs_gev] = discNormGev(means, K, k);
        [hw_gev,xw_gev] = discNormGev(meanw, K, k);
        
        % get histogram without fit
        [hi,xi] = getNormHist(round(meani*(1/k)));
        [hs,xs] = getNormHist(round(means*(1/k)));
        [hw,xw] = getNormHist(round(meanw*(1/k)));
        hi = hi / sum(hi*k);
        hs = hs / sum(hs*k);
        hw = hw / sum(hw*k);
        xi = xi / (1/k);
        xs = xs / (1/k);
        xw = xw / (1/k);

        %plot data
        dgev = [hi_gev; xi_gev; hs_gev; xs_gev; hw_gev; xw_gev];
        plotData(wsize(w), Y, K, dgev, hi, xi, hs, xs, hw, xw)

        %determine probabilites of (mis)classification
        prob = compPdf(hi_gev, xi_gev, hs_gev, xs_gev, hw_gev, xw_gev);
        
        %set result values
        result(w,:) = [wsize(w), prob(:,1)' prob(:,2)' prob(:,3)'];
    end
end
  
function [y,x] = discNormGev(data, K, k)
    parmhat = gevfit(data);
    pk = parmhat(1); %shape, k
    ps = parmhat(2); %scale, sigma
    pm = parmhat(3); %location, mu

    %set x axis
    x = [0:k:K];

    %get y values
    y = gevpdf(x,pk,ps,pm);
                       
    %normalise
    y = y / sum(y*k);
end

function plotData(w, Y, K, dgev, hi, xi, hs, xs, hw, xw)
    hi_gev = dgev(1,:);
    xi_gev = dgev(2,:);
    hs_gev = dgev(3,:);
    xs_gev = dgev(4,:);
    hw_gev = dgev(5,:);
    xw_gev = dgev(6,:);

    %clear figure
    fig = figure(w);clf;hold on;
    
    %setup histograms
    bi = bar(xi, hi, 'r', 'stacked');
    bs = bar(xs, hs, 'g', 'stacked');
    br = bar(xw, hw, 'b', 'stacked');
    alpha(get(bi,'children'),.25)
    alpha(get(bs,'children'),.25)
    alpha(get(br,'children'),.25)

    %show dicretised generelized extreme value fit
    plot(xi_gev, hi_gev, 'Color',[1,0,0],'LineWidth',2);
    plot(xs_gev, hs_gev, 'Color',[0,1,0],'LineWidth',2);
    plot(xw_gev, hw_gev, 'Color',[0,0,1],'LineWidth',2);

    %set x-axis limit
    xlim([0 K]);
    ylim([0 Y]);
    
    %set legend
    legend('idle','step', 'walk','idle (gev)','step (gev)', 'walk (gev)');
    
    %set title
    ftitle = 'normalised pdf of mean(signal)';
    ftitle = strcat(ftitle, ' dx=');
    ftitle = strcat(ftitle, num2str(mean(diff(xi)),1));
    ftitle = strcat(ftitle, ' wsize=');
    ftitle = strcat(ftitle, num2str(w));

    title(ftitle, 'FontWeight','bold')
    
    % Export figure
    addpath export_fig
    figname = strcat('results/mean_w', num2str(w));
    set(gcf, 'Color', 'white'); % white bckgr
    export_fig( fig, ...        % figure handle
                figname,...  % name of output file without extension
                '-painters', ... % renderer
                '-png', ...      % file format
                '-r144' );        % resolution in dpi
     rmpath export_fig
end