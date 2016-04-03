clear all; close all;

%% PARAMETERS (*ALL FROM NILS14A*)
q=0.36; %units: n/a, detection efficiency, used typical value
Dt=1.16; %units: s, integration time, used typical value
Dt_daylight=0.16; %Donner etal 1994

X=0.011; %units: photons/s, dark-noise rate/photoreceptor @16.5degrees Celsius
X_daylight=0; 
X_night=0.08; %units:photons/s, dark-noise rate/photoreceptor @23.5 degrees Celsius

R=1.96; %units: n/a, reliability coefficient for 95% confidence, used typical value
d=3e-6; %units: m, photoreceptor diameter, used typical value
M=2.55; %units: n/a, ratio of focal length and pupil radius (2f/A), set to Matthiessen's ratio

a=.3; %units: 1/m, beam attenuation coefficient, pg8 supplementary
K_up=0.14; %units: 1/m, attenuation coefficient of background radiance for looking up, pg8 supplementary
K_hor=0;  %units: 1/m, attenuation coefficint of background radiance for horizontal view, pg8 supplementary
K_down=-0.14; %units: 1/m, attenuation coefficint of background radiance for looking down, pg8 supplementary

a_air=a*10E-3;% units: 1/m, beam attenuation coefficient of background radiance for on land

Ispace_up=0.97*7.94e13; %units: photons/m^2ssr, radiance of space-light 
%background in the direction of view at the depth of the eye for downw-welling radiance at 200m, pg7
%supplementary
Ispace_hor=0.97*6.46e11; %units: photons/m^2ssr, radiance of space-light 
%background in the direction of view at the depth of the eye for horizontal radiance at 200m, pg7
%supplementary
Ispace_down=0.97*3.67e11; %units: photons/m^2ssr, radiance of space-light 
%background in the direction of view at the depth of the eye for up-welling radiance at 200m, pg7
%supplementary

Ispace_daylight=0.97*2.74e21;%units: photons/m^2ssr, radiance of space-light background 
Ispace_starlight=1.35e16;%units: photons/m^2ssr, radiance of space-light background 
Ispace_moonlight=6.42e16;%units: photons/m^2ssr, radiance of space-light background

Iref_daylight=0.97*4.11e20;%units: photons/m^2ssr, radiance of reflection
Iref_starlight=2.14e15;%units: photons/m^2ssr, radiance of reflection
Iref_moonlight=9.65e15;%units: photons/m^2ssr, radiance of reflection

att_up=2.29; %units: dB/100m, attenuation with depth for down-welling radiance,
%pg 8 of supplementary
att_hor=2.34; %units: dB/100m, attenuation with depth for horizontal radiance,
%pg 8 of supplementary
att_down=2.33; %units: dB/100m, attenuation with depth for up-welling radiance,
%pg 8 of supplementary

elevationCoastal=pi/6; %water elevation, for in air, half
azimuthCoastal=(2*120-35)*(pi/180); %viewing azimuth
azimuthAir=135*(pi/180);

elevationMin=pi/2-elevationCoastal;
elevationMax=pi/2+elevationCoastal;
elevationMaxAir=pi/2;

azimuthMin=0;
azimuthMax=azimuthCoastal;
azimuthMaxAir=azimuthAir;

T=.01; % units: m, prey width

f = @(rho,phi,theta) rho.^2.*sin(phi); %volume equation in spherical coordinates

save('Parameters')