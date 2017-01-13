function fig04_visualrangeWsensitivity(CONTRASTTHRESH)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 8 panel figure depicting visual range, dr/dD, visual volume, dV/dD for aquatic and aerial conditions
%%
%% Title                : A massive increase in visual range preceded the origin of terrestrial vertebrates
%% Authors              : Ugurcan Mugan, Malcolm A. MacIver
%% Authors' Affiliation : Northwestern University
%% DOI for code: 10.5281/zenodo.239228
%% This work is licensed under the Creative Commons Attribution 4.0 International License. 
%% To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/.
%% January 2017
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialize variables 
global BIGEYEROOT
%% Initialize and load pupil data

    close all;
    load('percChange.mat');
    load OM_TF_ST.mat
    load FinnedDigitedOrbitLength.mat
    
    pupil_TF = [mean(noElpistoOrb)-std(noElpistoOrb) mean(noElpistoOrb)+std(noElpistoOrb)].*0.449;
    pupil_ST = [mean(noSecAqOrb)-std(noSecAqOrb) mean(noSecAqOrb)+std(noSecAqOrb)].*0.449;
    finnedpupil=mean(noElpistoOrb)*.449;
    digitedpupil=mean(noSecAqOrb)*.449;

%% Check for required files and ask to re-run
    
    if nargin<1
        CONTRASTTHRESH=1;
    end

    [e,em]=fileExists;  
    while(~all(e))
        notFound=find(e==0);
        warning('Not all *.mat files required are found some are going to be re-run');
        for i=1:length(notFound)
            fprintf('running %s\n',em{notFound(i)});
            run(em{notFound(i)});
        end
        [e,em]=fileExists;
    end
        
    h=warndlg({'All of the code takes about 4-5hrs to run'},'Warning!');
    waitfor(h);
    choice=questdlg({'All the required *.mat files found!',...
        'Re-run the code?'},'code re-run','yes','no','no');
    if strcmp(choice,'yes')
        for i=1:length(em)
            fprintf('running %s\n',em{i});
            run(em{i})
        end
    end

%% Data rearrangement and calculations

    conditions={'Aquatic','AqUp','AqHor','Aerial','ArHor'};

    for c=1:3:length(conditions)
        visualRangeCell.(conditions{c})=struct2cell(visualRange.(conditions{c}));
        drdDCell.(conditions{c})=struct2cell(drdD.(conditions{c}));
        visualVolumeCell.(conditions{c})=struct2cell(visualVolume.(conditions{c}));
        dVdDCell.(conditions{c})=struct2cell(dVdD.(conditions{c}));
        direction=1;
        if strcmp(conditions{c},'Aquatic')
            direction=2;
        end
        for i=1:direction
            visualRangeMat.(conditions{c+i})=[];
            drdDMat.(conditions{c+i})=[];
            visualVolumeMat.(conditions{c+i})=[];
            dVddMat.(conditions{c+i})=[];
            for j=2:length(visualRangeCell.Aquatic);
                visualRangeMat.(conditions{c+i})=[visualRangeCell.(conditions{c}){j}(:,i) visualRangeMat.(conditions{c+i})];
                drdDMat.(conditions{c+i})=[drdDCell.(conditions{c}){j}(:,i) drdDMat.(conditions{c+i})];
                visualVolumeMat.(conditions{c+i})=[visualVolumeCell.(conditions{c}){j}(:,i) visualVolumeMat.(conditions{c+i})];
                dVddMat.(conditions{c+i})=[dVdDCell.(conditions{c}){j}(:,i) dVddMat.(conditions{c+i})];
            end
            maxVisualRange.(conditions{c+i})=max(visualRangeMat.(conditions{c+i}),[],2);
            minVisualRange.(conditions{c+i})=min(visualRangeMat.(conditions{c+i}),[],2);
            maxdrdD.(conditions{c+i})=max(drdDMat.(conditions{c+i}),[],2);
            mindrdD.(conditions{c+i})=min(drdDMat.(conditions{c+i}),[],2);
            maxVisualVolume.(conditions{c+i})=max(visualVolumeMat.(conditions{c+i}),[],2);
            minVisualVolume.(conditions{c+i})=min(visualVolumeMat.(conditions{c+i}),[],2);
            maxdVdD.(conditions{c+i})=max(dVddMat.(conditions{c+i}),[],2);
            mindVdD.(conditions{c+i})=min(dVddMat.(conditions{c+i}),[],2);
        end
    end
    
    [rawvisualRangeAquatic, rawvisualVolumeAquatic, rawdrdDAquatic,rawdVdDAquatic,DrangeAquatic] = Aquatic_calcVolumegetDer(CONTRASTTHRESH);
    [rawvisualRangeAerial,rawvisualVolumeAerial,rawdrdDAerial,rawdVdDAerial,DrangeAerial]=Aerial_calcVolumegetDer(CONTRASTTHRESH);
        
    visualRangeAerial=[rawvisualRangeAerial(:,1), rawvisualRangeAerial(:,2), smooth(rawvisualRangeAerial(:,3))];
    drdDAerial=[smooth(rawdrdDAerial(:,1)),smooth(rawdrdDAerial(:,2)),smooth(rawdrdDAerial(:,3),7)];
    visualVolumeAerial=[rawvisualVolumeAerial(:,1),rawvisualVolumeAerial(:,2),rawvisualVolumeAerial(:,3)];
    dVdDAerial=[smooth(rawdVdDAerial(:,1),7),smooth(rawdVdDAerial(:,2),7),smooth(rawdVdDAerial(:,3),7)];
    visualRangeAquatic=[rawvisualRangeAquatic(:,1,1), rawvisualRangeAquatic(:,1,2),...
        rawvisualRangeAquatic(:,2,1),...
        rawvisualRangeAquatic(:,3,1)];
    drdDAquatic=[smooth(rawdrdDAquatic(:,1,1)), smooth(rawdrdDAquatic(:,1,2)),...
        smooth(rawdrdDAquatic(:,2,1)),...
        smooth(rawdrdDAquatic(:,3,1))];
    visualVolumeAquatic=[rawvisualVolumeAquatic(:,1,1) rawvisualVolumeAquatic(:,1,2),...
        rawvisualVolumeAquatic(:,2,1),...
        rawvisualRangeAquatic(:,3,1)];
    dVdDAquatic=[smooth(rawdVdDAquatic(:,1,1),7), smooth(rawdVdDAquatic(:,1,2),7),...
        smooth(rawdVdDAquatic(:,2,1),7),...
        smooth(rawdVdDAquatic(:,3,1),7)];
    
    visual.rangeAquatic=visualRangeAquatic; visual.rangeAerial=visualRangeAerial;
    visual.drdDAquatic=drdDAquatic; visual.drdDAerial=drdDAerial;
    visual.volumeAquatic=visualVolumeAquatic; visual.volumeAerial=visualVolumeAerial;
    visual.dVdDAquatic=dVdDAquatic; visual.dVdDAerial=dVdDAerial;   
    
%% Figure 4 panel plot

    fig_props.noYsubplots = 2;
    fig_props.noXsubplots = 4;

    fig_props.figW = 18*2+5;   % cm
    fig_props.figH = 18;  % cm

    fig_props.ml = 2.5;
    fig_props.mt = 1;
    
    fig_props.left_margin = 2.2; 

    create_BE_figure
    fig_props.sub_pW = fig_props.sub_pW-.5;
    time_subsamp = 1;
    time_limit = 0.4;
    text_pos = [-5,2*time_limit/10,50];
    text_color = [0 0 0];
    text_size = 12;
    pn = {'Color','FontSize','FontWeight',};
    pv = {text_color,text_size,'bold'};
    
    fillboxalpha=0.18; % transparency of fillbox to show +/- std of pupil size;
    linewidthDef=2;
%% Aquatic Plots    
% Aquatic visual range
    plotnoX = 1;
    plotnoY = 1;
    ha11 = create_BE_axes(plotnoX,plotnoY,fig_props);

    hl11_1=line('XData',DrangeAquatic*1e3,'YData',visualRangeAquatic(:,1),...
        'linewidth',linewidthDef,'color',[0.4660    0.6740    0.1880]);
    hold on
    hl11_2=line('XData',DrangeAquatic*1e3,'YData',visualRangeAquatic(:,2),...
        'linewidth',linewidthDef,'color',[0.4660    0.6740    0.1880],'linestyle',':');
    hl11_3=line('XData',DrangeAquatic*1e3,'YData',visualRangeAquatic(:,3),...
        'linewidth',linewidthDef,'color',[0.4940    0.1840    0.5560]);
    hl11_4=line('XData',DrangeAquatic*1e3,'YData',visualRangeAquatic(:,4),...
        'linewidth',linewidthDef,'color',[0.9290 0.6940 0.1250]);
    xlim([1,25]); ylim1=get(gca,'ylim'); ylim([ylim1(1) 10]); ylim1=get(gca,'ylim');
    lineTf = line([pupil_TF(1) pupil_TF(2)],...
        [10 10],'color',[0.8500    0.3250    0.0980],'linewidth',linewidthDef);
    lineST = line([pupil_ST(1) pupil_ST(2) ],...
        [10 10],'color',[0    0.4470    0.7410],'linewidth',linewidthDef);
    line([finnedpupil,finnedpupil],[ylim1(1),ylim1(2)],...
        'linewidth',linewidthDef,'color',[0.8500    0.3250    0.0980],'linestyle',':');
    line([digitedpupil,digitedpupil],[ylim1(1),ylim1(2)],...
            'linewidth',linewidthDef,'color',[0    0.4470    0.7410],'linestyle',':');
    fillboxErr=fill([DrangeAquatic'*1e3;flipud(DrangeAquatic')*1e3],...
        [minVisualRange.AqUp;flipud(maxVisualRange.AqUp)],...
        [0.4660    0.6740    0.1880],'linestyle','none');
    alpha(fillboxErr,fillboxalpha)
    x=15;
    text(x,interp1q(DrangeAquatic,visualRangeAquatic(:,1),x*1e-3)+0.8,'daylight,up',...
        'fontsize',11,'interpreter','tex','fontname','helvetica')
    text(x,interp1q(DrangeAquatic,visualRangeAquatic(:,2),x*1e-3)+0.8,'daylight,horizontal',...
        'fontsize',11,'interpreter','tex','fontname','helvetica')
    text(x,interp1q(DrangeAquatic,visualRangeAquatic(:,3),x*1e-3)+0.8,'moonlight,up',...
        'fontsize',11,'interpreter','tex','fontname','helvetica')
    text(x,interp1q(DrangeAquatic,visualRangeAquatic(:,4),x*1e-3)+0.8,'starlight,up',...
        'fontsize',11,'interpreter','tex','fontname','helvetica')
    y11=ylabel('\bf visual range ( \itr\rm\bf ) (m)',...
        'fontsize',12,'fontname','helvetica','interpreter','tex');
    annotation('textbox',...
    [0.01 0.94 0.021 0.051],...
    'String',{'A1'},...
    'FontSize',13,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);
    set(gca,'YTick',[0 2 4 6 8 10])
    axis square
    
% Aquatic Derivative Range wrt Pupil Diameter
    plotnoX=2;
    plotnoY=1;
    ha12=create_BE_axes(plotnoX,plotnoY,fig_props);

    hl12_1=line('XData',DrangeAquatic*1e3,'YData',drdDAquatic(:,1),...
        'linewidth',linewidthDef,'color',[0.4660    0.6740    0.1880]);
    hold on
    hl12_2=line('XData',DrangeAquatic*1e3,'YData',drdDAquatic(:,2),...
        'linewidth',linewidthDef,'color',[0.4660    0.6740    0.1880],'linestyle',':');
    hl12_3=line('XData',DrangeAquatic*1e3,'YData',drdDAquatic(:,3),...
        'linewidth',linewidthDef,'color',[0.4940    0.1840    0.5560]);
    hl12_4=line('XData',DrangeAquatic*1e3,'YData',drdDAquatic(:,4),...
        'linewidth',linewidthDef,'color',[0.9290 0.6940 0.1250]);
    xlim([1,25]); ylim1=get(gca,'ylim'); ylim([ylim1(1) 0.6]); ylim1=get(gca,'ylim');
    lineTf = line([pupil_TF(1) pupil_TF(2)],...
        [0.6 0.6],'color',[0.8500    0.3250    0.0980],'linewidth',linewidthDef);
    lineST = line([pupil_ST(1) pupil_ST(2) ],...
        [0.6 0.6],'color',[0    0.4470    0.7410],'linewidth',linewidthDef);
    line([finnedpupil,finnedpupil],[ylim1(1),ylim1(2)],...
        'linewidth',linewidthDef,'color',[0.8500    0.3250    0.0980],'linestyle',':');
    line([digitedpupil,digitedpupil],[ylim1(1),ylim1(2)],...
            'linewidth',linewidthDef,'color',[0    0.4470    0.7410],'linestyle',':');
    fillboxErr=fill([DrangeAquatic'*1e3;flipud(DrangeAquatic')*1e3],...
        [mindrdD.AqUp;flipud(drdDAquatic(:,1))],...
        [0.4660    0.6740    0.1880],'linestyle','none');
    alpha(fillboxErr,fillboxalpha)
    ylabel('\bfd\itr\rm\bf/d\itD \rm\bf(m/mm)','interpreter','tex',...
        'fontsize',12,'fontname','helvetica');
    annotation('textbox',...
    [0.25 0.94 0.021 0.051],...
    'String','B1',...
    'FontSize',13,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);
    set(gca,'YTick',[0 0.2 0.4 0.6])
    axis square 
   
% Aquatic Volume
    plotnoX=1;
    plotnoY=2;
    ha21=create_BE_axes(plotnoX,plotnoY,fig_props);

    hl21_1=line('XData',DrangeAquatic*1e3,'YData',visualVolumeAquatic(:,1),...
        'linewidth',linewidthDef,'color',[0.4660    0.6740    0.1880]);
    hold on
    hl21_2=line('XData',DrangeAquatic*1e3,'YData',visualVolumeAquatic(:,2),...
        'linewidth',linewidthDef,'color',[0.4660    0.6740    0.1880],'linestyle',':');
    hl21_3=line('XData',DrangeAquatic*1e3,'YData',visualVolumeAquatic(:,3),...
        'linewidth',linewidthDef,'color',[0.4940    0.1840    0.5560]);
    hl21_4=line('XData',DrangeAquatic*1e3,'YData',visualVolumeAquatic(:,4),...
        'linewidth',linewidthDef,'color',[0.9290 0.6940 0.1250]);
    xlim([1,25]); ylim1=get(gca,'ylim');  ylim([ylim1(1) 800]); ylim1=get(gca,'ylim');
    lineTf = line([pupil_TF(1) pupil_TF(2)],...
        [800 800],'color',[0.8500    0.3250    0.0980],'linewidth',linewidthDef);
    lineST = line([pupil_ST(1) pupil_ST(2) ],...
        [800 800],'color',[0    0.4470    0.7410],'linewidth',linewidthDef);
    line([finnedpupil,finnedpupil],[ylim1(1),ylim1(2)],...
        'linewidth',linewidthDef,'color',[0.8500    0.3250    0.0980],'linestyle',':');
    line([digitedpupil,digitedpupil],[ylim1(1),ylim1(2)],...
            'linewidth',linewidthDef,'color',[0    0.4470    0.7410],'linestyle',':');
    fillboxErr=fill([DrangeAquatic'*1e3;flipud(DrangeAquatic')*1e3],...
        [minVisualVolume.AqUp;flipud(maxVisualVolume.AqUp)],...
        [0.4660    0.6740    0.1880],'linestyle','none');
    alpha(fillboxErr,fillboxalpha)
    ylabel('\bfvisual volume ( \itV\rm\bf ) (m^3)','interpreter','tex',...
        'fontsize',12,'fontname','helvetica');
    xlabel('\bfpupil diameter ( \itD\rm\bf ) (mm)', 'interpreter','tex',...
        'fontsize',12,'fontname','helvetica');
    annotation('textbox',...
    [0.01 0.46 0.021 0.051],...
    'String','C1',...
    'FontSize',13,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);
    NumTicks = 5;
    L = get(gca,'YLim');
    set(gca,'YTick',[0 200 400 600 800])
    axis square

% Aquatic Derivative Volume wrt Pupil Diameter
    plotnoX=2;
    plotnoY=2;
    ha22=create_BE_axes(plotnoX,plotnoY,fig_props);

    hl22_1=line('XData',DrangeAquatic*1e3,'YData',dVdDAquatic(:,1),...
        'linewidth',linewidthDef,'color',[0.4660    0.6740    0.1880]);
    hold on
    hl22_2=line('XData',DrangeAquatic*1e3,'YData',dVdDAquatic(:,2),...
        'linewidth',linewidthDef,'color',[0.4660    0.6740    0.1880],'linestyle',':');
    hl22_3=line('XData',DrangeAquatic*1e3,'YData',dVdDAquatic(:,3),...
        'linewidth',linewidthDef,'color',[0.4940    0.1840    0.5560]);
    hl22_4=line('XData',DrangeAquatic*1e3,'YData',dVdDAquatic(:,4),...
        'linewidth',linewidthDef,'color',[0.9290 0.6940 0.1250]);
    xlim([1,25]); ylim1=get(gca,'ylim'); ylim([ylim1(1) 80]); ylim1=get(gca,'ylim');
    lineTf = line([pupil_TF(1) pupil_TF(2)],...
        [80 80],'color',[0.8500    0.3250    0.0980],'linewidth',linewidthDef);
    lineST = line([pupil_ST(1) pupil_ST(2) ],...
        [80 80],'color',[0    0.4470    0.7410],'linewidth',linewidthDef);
    line([finnedpupil,finnedpupil],[ylim1(1),ylim1(2)],...
        'linewidth',linewidthDef,'color',[0.8500    0.3250    0.0980],'linestyle',':');
    line([digitedpupil,digitedpupil],[ylim1(1),ylim1(2)],...
            'linewidth',linewidthDef,'color',[0    0.4470    0.7410],'linestyle',':');
    fillboxErr=fill([DrangeAquatic'*1e3;flipud(DrangeAquatic')*1e3],...
        [mindVdD.AqUp;flipud(dVdDAquatic(:,1))],...
        [0.4660    0.6740    0.1880],'linestyle','none');
    alpha(fillboxErr,fillboxalpha)
    ylabel('\bfd\itV\rm\bf/d\itD \rm\bf(m^3/mm)','interpreter','tex',...
        'fontsize',12,'fontname','helvetica');
    x22=xlabel('\bfpupil diameter ( \itD\rm\bf ) (mm)','interpreter','tex',...
    'fontsize',12,'fontname','helvetica');
    annotation('textbox',...
    [0.25 0.46 0.021 0.051],...
    'String','D1',...
    'FontSize',13,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);
    set(gca,'YTick',[0 20 40 60 80])
    axis square

%% Aerial plots
% Aerial Range
    plotnoX = 3;
    plotnoY = 1;
    ha31 = create_BE_axes(plotnoX,plotnoY,fig_props);

    hl31_1=line('XData',DrangeAerial*1e3,'YData',visualRangeAerial(:,1),...
        'linewidth',linewidthDef,'color',[0.4660    0.6740    0.1880]);
    hold on
    hl31_2=line('XData',DrangeAerial*1e3,'YData',visualRangeAerial(:,2),...
        'linewidth',linewidthDef,'color',[0.4940    0.1840    0.5560]);
    hl31_3=line('XData',DrangeAerial*1e3,'YData',visualRangeAerial(:,3),...
        'linewidth',linewidthDef,'color',[0.9290 0.6940 0.1250]);
    hl31_4=line('XData',DrangeAquatic*1e3,'YData',visualRangeAquatic(:,1),...
        'linewidth',linewidthDef,'color','k');
    xlim([1,25]); ylim1=get(gca,'ylim'); ylim([ylim1(1) 1000]); ylim1=get(gca,'ylim');
    lineTf = line([pupil_TF(1) pupil_TF(2)],...
        [1000 1000],'color',[0.8500    0.3250    0.0980],'linewidth',linewidthDef);
    lineST = line([pupil_ST(1) pupil_ST(2) ],...
        [1000 1000],'color',[0    0.4470    0.7410],'linewidth',linewidthDef);
    line([finnedpupil,finnedpupil],[ylim1(1),ylim1(2)],...
        'linewidth',linewidthDef,'color',[0.8500    0.3250    0.0980],'linestyle',':');
    line([digitedpupil,digitedpupil],[ylim1(1),ylim1(2)],...
            'linewidth',linewidthDef,'color',[0    0.4470    0.7410],'linestyle',':');
    fillboxErr=fill([DrangeAerial'*1e3;flipud(DrangeAerial')*1e3],...
        [minVisualRange.ArHor;flipud(maxVisualRange.ArHor)],...
        [0.4660    0.6740    0.1880],'linestyle','none');
    alpha(fillboxErr,fillboxalpha)
    x=16;
    
    text(x,(interp1q(DrangeAerial,visualRangeAerial(:,1),x*1e-3)+188),'daylight',...
        'fontsize',12,'interpreter','tex','fontname','helvetica')
    text(x,(interp1q(DrangeAerial,visualRangeAerial(:,2),x*1e-3)+140),'moonlight',...
        'fontsize',12,'interpreter','tex','fontname','helvetica')
    text(x,(interp1q(DrangeAerial,visualRangeAerial(:,3),x*1e-3)+97),'starlight',...
        'fontsize',12,'interpreter','tex','fontname','helvetica')
    text(x,50,'aquatic','fontsize',12,'interpreter','tex','fontname','helvetica');

    ylabel('\bfvisual range ( \itr\rm\bf ) (m)','interpreter','tex',...
        'fontsize',12,'fontname','helvetica');
    annotation('textbox',...
    [0.49 0.94 0.021 0.051],...
    'String',{'A2'},...
    'FontSize',13,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);
    set(gca,'YTick',[0 200 400 600 800 1000])
    axis square

% Aerial Derivative Range wrt Pupil Diameter
    plotnoX = 4;
    plotnoY = 1;
    ha41 = create_BE_axes(plotnoX,plotnoY,fig_props);

    hl41_1=line('XData',DrangeAerial*1e3,'YData',drdDAerial(:,1)/1e2,...
        'linewidth',linewidthDef,'color',[0.4660    0.6740    0.1880]);
    hold on
    hl41_2=line('XData',DrangeAerial*1e3,'YData',drdDAerial(:,2)/1e2,...
        'linewidth',linewidthDef,'color',[0.4940    0.1840    0.5560]);
    hl41_3=line('XData',DrangeAerial*1e3,'YData',drdDAerial(:,3)/1e2,...
        'linewidth',linewidthDef,'color',[0.9290 0.6940 0.1250]);
    hl41_4=line('XData',DrangeAquatic*1e3,'YData',drdDAquatic(:,1)/1e2,...
        'linewidth',linewidthDef,'color','k');
    xlim([1,25]); ylim1=get(gca,'ylim'); ylim([ylim1(1) ylim1(2)]);
    lineTf = line([pupil_TF(1) pupil_TF(2)],...
        [0.6 0.6],'color',[0.8500    0.3250    0.0980],'linewidth',linewidthDef);
    lineST = line([pupil_ST(1) pupil_ST(2) ],...
        [0.6 0.6],'color',[0    0.4470    0.7410],'linewidth',linewidthDef);
    line([finnedpupil,finnedpupil],[ylim1(1),ylim1(2)],...
        'linewidth',linewidthDef,'color',[0.8500    0.3250    0.0980],'linestyle',':');
    line([digitedpupil,digitedpupil],[ylim1(1),ylim1(2)],...
            'linewidth',linewidthDef,'color',[0    0.4470    0.7410],'linestyle',':');
    fillboxErr=fill([DrangeAerial'*1e3;flipud(DrangeAerial')*1e3],...
        [smooth(mindrdD.ArHor/1e2);flipud(smooth(maxdrdD.ArHor))/1e2],...
        [0.4660    0.6740    0.1880],'linestyle','none');
    alpha(fillboxErr,fillboxalpha)
    ylabel('\bfd\itr\rm\bf/d\itD \rm\bf(10^2 m/mm)','interpreter','tex',...
        'fontsize',12,'fontname','helvetica');
    annotation('textbox',...
    [0.72 0.94 0.021 0.051],...
    'String','B2',...
    'FontSize',13,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);
    set(gca,'YTick',[0 .20 .40 .60])
    axis square
 
% Aerial Volume
    plotnoX = 3;
    plotnoY = 2;
    ha32 = create_BE_axes(plotnoX,plotnoY,fig_props);

    hl32_1=line('XData',DrangeAerial*1e3,'YData',visualVolumeAerial(:,1)/1e6,...
        'linewidth',linewidthDef,'color',[0.4660    0.6740    0.1880]);
    hold on
    hl32_2=line('XData',DrangeAerial*1e3,'YData',visualVolumeAerial(:,2)/1e6,...
        'linewidth',linewidthDef,'color',[0.4940    0.1840    0.5560]);
    hl32_3=line('XData',DrangeAerial*1e3,'YData',visualVolumeAerial(:,3)/1e6,...
        'linewidth',linewidthDef,'color',[0.9290 0.6940 0.1250]);
    hl42_4=line('XData',DrangeAquatic*1e3,'YData',visualVolumeAquatic(:,1)/1e6,...
        'linewidth',linewidthDef,'color','k');
    xlim([1,25]); ylim1=get(gca,'ylim'); ylim([ylim1(1) 800]); ylim1=get(gca,'ylim');
    lineTf = line([pupil_TF(1) pupil_TF(2)],...
        [800 800],'color',[0.8500    0.3250    0.0980],'linewidth',linewidthDef);
    lineST = line([pupil_ST(1) pupil_ST(2) ],...
        [800 800],'color',[0    0.4470    0.7410],'linewidth',linewidthDef);
    line([finnedpupil,finnedpupil],[ylim1(1),ylim1(2)],...
        'linewidth',linewidthDef,'color',[0.8500    0.3250    0.0980],'linestyle',':');
    line([digitedpupil,digitedpupil],[ylim1(1),ylim1(2)],...
            'linewidth',linewidthDef,'color',[0    0.4470    0.7410],'linestyle',':');
   
    fillboxErr=fill([DrangeAerial'*1e3;flipud(DrangeAerial')*1e3],...
        [minVisualVolume.ArHor/1e6;flipud(maxVisualVolume.ArHor)/1e6],...
        [0.4660    0.6740    0.1880],'linestyle','none');
    alpha(fillboxErr,fillboxalpha)
    ylabel('\bfvisual volume ( \itV\rm\bf ) (10^6 m^3)','interpreter','tex',...
        'fontsize',12,'fontname','helvetica');
    xlabel('\bfpupil diameter ( \itD\rm\bf ) (mm)','interpreter','tex',...
        'fontsize',12,'fontname','helvetica');
    annotation('textbox',...
    [0.49 0.46 0.021 0.051],...
    'String','C2',...
    'FontSize',13,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

    set(gca,'YTick',[0 200 400 600 800])
    axis square

% Aerial Derivative Volume wrt Pupil Diameter
    plotnoX = 4;
    plotnoY = 2;
    ha42 = create_BE_axes(plotnoX,plotnoY,fig_props);

    hl42_1=line('XData',DrangeAerial*1e3,'YData',dVdDAerial(:,1)/1e6,...
        'linewidth',linewidthDef,'color',[0.4660    0.6740    0.1880]);
    hold on
    hl42_2=line('XData',DrangeAerial*1e3,'YData',dVdDAerial(:,2)/1e6,...
        'linewidth',linewidthDef,'color',[0.4940 0.1840 0.5560]);
    hl42_3=line('XData',DrangeAerial*1e3,'YData',dVdDAerial(:,3)/1e6,...
        'linewidth',linewidthDef,'color',[0.9290 0.6940 0.1250]);
    hl42_4=line('XData',DrangeAquatic*1e3,'YData',dVdDAquatic(:,1)/1e6,...
        'linewidth',linewidthDef,'color','k');
    xlim([1,25]); ylim1=get(gca,'ylim'); ylim([ylim1(1) 80]); ylim1=get(gca,'ylim');
        lineTf = line([pupil_TF(1) pupil_TF(2)],...
        [80 80],'color',[0.8500    0.3250    0.0980],'linewidth',linewidthDef);
    lineST = line([pupil_ST(1) pupil_ST(2) ],...
        [80 80],'color',[0    0.4470    0.7410],'linewidth',linewidthDef);
    line([finnedpupil,finnedpupil],[ylim1(1),ylim1(2)],...
        'linewidth',linewidthDef,'color',[0.8500    0.3250    0.0980],'linestyle',':');
    line([digitedpupil,digitedpupil],[ylim1(1),ylim1(2)],...
            'linewidth',linewidthDef,'color',[0    0.4470    0.7410],'linestyle',':');
    
    fillboxErr=fill([DrangeAerial'*1e3;flipud(DrangeAerial')*1e3],...
        [mindVdD.ArHor/1e6;flipud(maxdVdD.ArHor)/1e6],...
        [0.4660    0.6740    0.1880],'linestyle','none');
    alpha(fillboxErr,fillboxalpha)
    
    ylabel('\bfd\itV\rm\bf/d\itD \rm\bf(10^6 m^3/mm)','interpreter','tex',...
        'fontsize',12,'fontname','helvetica');
    xlabel('\bfpupil diameter ( \itD\rm\bf ) (mm)','interpreter','tex',...
        'fontsize',12,...
        'fontname','helvetica');
    annotation('textbox',...
    [0.72 0.46 0.021 0.052],...
    'String','D2',...
    'FontSize',13,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

    set(gca,'YTick',[0 20 40 60 80])
    axis square
    
filename=[BIGEYEROOT 'fig04_visualrange/figure_sensitivity/fig04_visualrangeWsensitivity.pdf'];
print(filename,'-painters','-dpdf','-r600');

    function [e,em]=fileExists
    e1={exist('visibilityAquatic.mat','file')==2, 'Aquatic_contrastThresh.m'};
    e2={exist('meteoAquatic.mat','file')==2, 'Aquatic_firingThresh.m'};
    e3={exist('visibilityAerial.mat','file')==2, 'Aerial_contrastThresh.m'};
    e4={exist('meteoAerial.mat','file')==2, 'Aerial_firingThresh.m'};
    e5={exist('percChange.mat','file')==2, 'percChange.mat'};
    e=[e1{1},e2{1},e3{1},e4{1},e5{1}];
    em={e1{2},e2{2},e3{2},e4{2},e5{2}};      