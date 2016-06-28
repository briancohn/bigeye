function plotTerrestrialSmallestTarget
    close all
    
    run ../figXX_compviz/Parameters.m
    load terrestrialSmallestTarget.mat

    fillboxalpha=0.07; % transparency of fillbox to show +/- std of pupil size;
    load ../fig02_orbitsize/OM_TF_ST.mat
    pupil_TF = [mean(OM_TF)-std(OM_TF) mean(OM_TF)+std(OM_TF)].*0.53;
    pupil_ST = [mean(OM_ST)-std(OM_ST) mean(OM_ST)+std(OM_ST)].*0.53;

    fishpupil=mean(OM_TF)*.53;
    tetrapodpupil=mean(OM_ST)*.53;

    linewidthDef=2;

    figure(); clf()
    
    starlightSubtendedAngle=bsxfun(@rdivide,targetSizeSolns(:,:,3)',rangeValuesAll(3,:));
    starlightSubtendedAngle(isnan(starlightSubtendedAngle))=0;
    
    moonlightSubtendedAngle=bsxfun(@rdivide,targetSizeSolns(:,:,2)',rangeValuesAll(2,:));
    moonlightSubtendedAngle(isnan(moonlightSubtendedAngle))=0;
    
    daylightSubtendedAngle=bsxfun(@rdivide,targetSizeSolns(:,:,1)',rangeValuesAll(1,:));
    daylightSubtendedAngle(isnan(moonlightSubtendedAngle))=0;
    
    ax3=subplot(3,1,1);

    plot(pupilValues*10^3,starlightSubtendedAngle*180/pi,'linewidth',linewidthDef);
    xlabel('pupil diameter (mm)'); ylabel('starlight angular size (deg)','fontsize',8);
    hold on;
    xlim([0.0025*10^3 maxpupil*10^3]); ylim1=get(gca,'ylim'); ylim1(1)=0; 
    %ylim([ylim1(1) max(starlightTargetSize(:,2))]); ylim1=get(gca,'ylim');
    fillboxTF = patch([pupil_TF(1) pupil_TF(1) pupil_TF(2) pupil_TF(2)], ...
    [ylim1(1) ylim1(2) ylim1(2) ylim1(1)],[1 0 0]);
    set(fillboxTF,'facealpha',fillboxalpha,'edgecolor','none');
    fillboxST = patch([pupil_ST(1) pupil_ST(1) pupil_ST(2) pupil_ST(2)], ...
        [ylim1(1) ylim1(2) ylim1(2) ylim1(1)],[0 0 1]);
    set(fillboxST,'facealpha',fillboxalpha,'edgecolor','none');
    line([fishpupil,fishpupil],[ylim1(1),ylim1(2)],'linewidth',linewidthDef,'color',[216/256,191/256,216/256],'linestyle',':')
    line([tetrapodpupil,tetrapodpupil],[ylim1(1),ylim1(2)],'linewidth',linewidthDef,'color',[0/256,128/256,128/256],'linestyle',':')
    key={'2m','10m','20m'};
    columnlegend(3,key,'location','northeast','fontsize',8,'Box','off');
    
    ax2=subplot(3,1,2);
    plot(pupilValues*10^3,moonlightSubtendedAngle*180/pi,'linewidth',linewidthDef);
    xlabel('pupil diameter (mm)'); ylabel('moonlight angular size (deg)','fontsize',8);
    hold on;
    xlim([0.0025*10^3 maxpupil*10^3]); 
    ylim1=get(gca,'ylim'); ylim1(1)=0;
    %ylim([ylim1(1) max(moonlightTargetSize(:,2))]); ylim1=get(gca,'ylim');
    fillboxTF = patch([pupil_TF(1) pupil_TF(1) pupil_TF(2) pupil_TF(2)], ...
    [ylim1(1) ylim1(2) ylim1(2) ylim1(1)],[1 0 0]);
    set(fillboxTF,'facealpha',fillboxalpha,'edgecolor','none');
    fillboxST = patch([pupil_ST(1) pupil_ST(1) pupil_ST(2) pupil_ST(2)], ...
        [ylim1(1) ylim1(2) ylim1(2) ylim1(1)],[0 0 1]);
    set(fillboxST,'facealpha',fillboxalpha,'edgecolor','none');
    line([fishpupil,fishpupil],[ylim1(1),ylim1(2)],'linewidth',linewidthDef,'color',[216/256,191/256,216/256],'linestyle',':')
    line([tetrapodpupil,tetrapodpupil],[ylim1(1),ylim1(2)],'linewidth',linewidthDef,'color',[0/256,128/256,128/256],'linestyle',':')
    key={'5m','20m','80m'};
    columnlegend(3,key,'location','northeast','fontsize',8,'Box','off');
    
    ax1=subplot(3,1,3);
    %linkaxes([ax1,ax2,ax3],'xy');
    plot(pupilValues*10^3, daylightSubtendedAngle*180/pi*60,'linewidth',linewidthDef);
    xlabel('pupil diameter (mm)'); ylabel('daylight angular size (arcmin)','fontsize',8);
    hold on; 
    xlim([0.0025*10^3 maxpupil*10^3]);  ylim1=get(gca,'ylim'); 
    %ylim([ylim1(1) max(daylightTargetSize(:,2))]); ylim1=get(gca,'ylim');
    fillboxTF = patch([pupil_TF(1) pupil_TF(1) pupil_TF(2) pupil_TF(2)], ...
    [ylim1(1) ylim1(2) ylim1(2) ylim1(1)],[1 0 0]);
    set(fillboxTF,'facealpha',fillboxalpha,'edgecolor','none');
    fillboxST = patch([pupil_ST(1) pupil_ST(1) pupil_ST(2) pupil_ST(2)], ...
        [ylim1(1) ylim1(2) ylim1(2) ylim1(1)],[0 0 1]);
    set(fillboxST,'facealpha',fillboxalpha,'edgecolor','none');
    line([fishpupil,fishpupil],[ylim1(1),ylim1(2)],'linewidth',linewidthDef,'color',[216/256,191/256,216/256],'linestyle',':')
    line([tetrapodpupil,tetrapodpupil],[ylim1(1),ylim1(2)],'linewidth',linewidthDef,'color',[0/256,128/256,128/256],'linestyle',':')
    key={'50m','250m','750m'};
    columnlegend(3,key,'location','northeast','fontsize',8,'Box','off');
    
    

    
    
    
