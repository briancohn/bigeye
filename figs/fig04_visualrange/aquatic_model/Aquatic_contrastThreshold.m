function Aquatic_contrastThreshold
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Inclusion of contrast threshold for aquatic vision
%%
%% Title                : A massive increase in visual range preceded the origin of terrestrial vertebrates
%% Authors              : Ugurcan Mugan, Malcolm A. MacIver
%% Authors' Affiliation : Northwestern University
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global BIGEYEROOT
%% Variable initialization
    run Parameters.m    
    load('Parameters.mat')
    if ~exist('meteoAquatic.mat','file')==2
        Aquatic_firingThresh;
    end
    load('meteoAquatic.mat');
%% Given condition and viewing calculate contrast threshold for a luminance and pupil diameter    
    conditions={'Daylight','Moonlight','Starlight'};
    viewing={'Upward','Horizontal'};
    depth=8; epsilon=5e-2;
    contrastRangeAquatic=zeros(size(visualRangeAquatic,1),size(visualRangeAquatic,2),size(visualRangeAquatic,3));

    for c=1:length(conditions);
        a=aAquatic.(conditions{c}); 
        b=bAquatic.(conditions{c});
        C0=C0Aquatic.(conditions{c});
        for j=1:length(viewing);
            K=KAquatic.(conditions{c}).(viewing{j})(:,depth); 
            L=LAquatic.(conditions{c}).(viewing{j})(:,depth);
            [~,index]=max(L);
            lambdaMax=lambda(index);
            B=BAquatic.(conditions{c}).(viewing{j})(depth);
   
            afunc=@(l) interp1(lambda,a,l,'pchip'); 
            bfunc=@(l) interp1(lambda,b,l,'pchip');
            Kfunc=@(l) interp1(lambda,K,l,'pchip');
            for i=1:length(DrangeAquatic)
                D=DrangeAquatic(i);
                tempRange=visualRangeAquatic(i,c,j);
                
                %Apparent contrast, Supplementary Appendix, pg. 5
                Cr(i)=C0*exp((Kfunc(lambdaMax)-afunc(lambdaMax)-bfunc(lambdaMax)).*tempRange);
          
                %angular size of object in mrad
                angularSize(i)=atan(T/(2*tempRange))*2*10^3;
                Kt(i)=liminalContrast(A,B,angularSize(i));

                %Calculate contrast threshold compare to apparent contrast,
                %Supplementary Appendix, pg. 5
                if (10^(Kt(i))<abs(Cr(i)))
                    contrastRangeAquatic(i,c,j)=tempRange;
                else    
                    tempVisualRange=linspace(tempRange,tempRange/10,tempRange*1000);
                    ind=1;
                    while(10^(Kt(i))-abs(Cr(i)))>epsilon
                        tempRange=tempVisualRange(ind); %decrease range
                        angularSize(i)=atan(T/(2*tempRange))*2*10^3;
                        Cr(i)=C0*exp((Kfunc(lambdaMax)-afunc(lambdaMax)-bfunc(lambdaMax)).*tempRange);
                        Kt(i)=liminalContrast(A,B,angularSize(i));
                        ind=ind+1;
                        clc;
                        fprintf('pupil diameter: %f\nrange: %f\nerror: %f\n',...
                            D,tempRange,10^(Kt(i)) -abs(Cr(i)));
                    end
                    contrastRangeAquatic(i,c,j)=tempRange;
                end
            end
        end
    end
    visualRangeAquatic=contrastRangeAquatic ;  
save([BIGEYEROOT 'fig04_visualrange/aquatic_model/visibilityAquatic.mat'],'visualRangeAquatic','DrangeAquatic')

function Kt = liminalContrast(A,L,angularSize)
%Define functions
    logLa=@(L) log10(L);
    iif = @(varargin) varargin{2 * find([varargin{1:2:end}], 1, 'first')}();
    deltat=@(L) iif( -2<logLa(L) && logLa(L)<=4, @() (1.22*((555e-9)/A)*10^3),...
        logLa(L)<=-2, @() (1.22*((507e-9)/A))*10^3); %Supplementary Appendix, pg. 5

    Psi=@(L) (logLa(L)+3.5)/2.75; %Supplementary Appendix, Eq. 10 part 1 pg. 5
    logdeltarStar= @(L) iif(logLa(L)>1.535, @() 0.928,...
        -0.75<=logLa(L) && logLa(L)<=1.535, @() 1-(0.5*(Psi(L)^(-3.2))),...
        -2.089<=logLa(L) && logLa(L)<-0.75, @()-0.28+0.1*Psi(L)^(3.2),...
        logLa(L)<-2.089, @() 0.14*logLa(L)+0.442); %Supplementary Appendix, Eq. 10 part 2 pg. 5
    %Equations from Aksyutov
    X=@(deltar,L) -(-log10(deltar)+logdeltarStar(L));
    Xm=@(L) iif(logLa(L)>1.5, @() 1.48-0.48*logLa(10^1.5),...
        logLa(L)>0.11 && logLa(L)<=1.5, @() 1.48-0.48*logLa(L),...
        logLa(L)>=-1.46 && logLa(L)<=0.11, @() 1.40-0.78*logLa(L),...
        logLa(L)<-1.46, @() 1.40-0.78*logLa(10^-1.46)); 
    Ym=@(L) 0.75*Xm(L)-0.32;
    Xr=@(deltar,L) X(deltar,L)./Xm(L);
    Yr=@(deltar,L) iif(Xr(deltar,L)<=0.56, @() ((1.6+0.23*logLa(L)).*(Xr(deltar,L)-0.05)).^(0.5),...
        Xr(deltar,L)>0.56, @() (1-((0.42-0.26*logLa(L)).*(1-Xr(deltar,L))))^(0.5)); 
    Y=@(deltar,L) Yr(deltar,L).*Ym(L);

% Calculate contrast threshold
    angularResolution=deltat(L);
    deltarparam=angularSize/angularResolution;
    logStardeltar=logdeltarStar(L);
    if log10(deltarparam)<=logStardeltar
        Kt=-2*log10(deltarparam); %Supplementary Appendix, pg. 5
    else %Conditions from Aksyutov
        Xparam=X(deltarparam,L);
        Xmparam=Xm(L);
        if Xparam>0 && Xparam<=0.20 
            Yval=1.45*Xparam;
            Kt =-2*logStardeltar-Yval;
        elseif Xparam>0.20
            Yval=Y(deltarparam,L);
            Kt=-2*logStardeltar-Yval;
        end
    end        
