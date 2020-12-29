%% EM Waves - SWR vs Frequency of a Microstrip Quarter Wave Transformer
%Justin Francisco
%last modified: 12/12/2020

%% Housekeeping Commands
clc
clear
close all
%% Variable Setup
freq = 1:1:1000; %we will have a spectrum of frequencies to test (1.5 to 3.5 Ghz)
SWR = 1:1:1001; %will have many SWR's to calculate (same as the frequency)
lambda_naught = 0; %this value depends on the frequency and speed of light
lambda_gm = 0; %depends on lambda_naught
lambda_gt = 0; %depends on lambda_naught
epsilon_r_eff_t = 2.05111; %epsilon r effecttive of the transmission line is constant
epsilon_r_eff_m = 1.98431; %epsilon r effecttive of the mainline line is constant
d1 = 0.0425643; %length to transformer from load [m]
lt = 0.0209328; %length of transformer [m]
z0t = 35.3553; %characteristic impedance of the transformer [ohms]
z0m = 50; %characteristic impedance of the mainline [ohms]
%% Array of Frequencies Setup
index = 1;
for(c=1.5:0.002:3.5) %this loop loads in all the frequency samples we want (1000 samples from 1.5 to 3.5 Ghz)
    freq([index]) = c;
    index = index + 1;
end
%% SWR Calculation per Frequency
for(index=1:1:1001) %index is set to 1. make sure the index is the same for freq and SWR array
    lambda_naught = 0.3/freq([index]) %0.3 [Gm/s] / freq GHz = [m]
    lambda_gm = lambda_naught/sqrt(epsilon_r_eff_m); %[m]
    lambda_gt = lambda_naught/sqrt(epsilon_r_eff_t); %[m]
    
    beta1 = (2*pi)/(lambda_gm); 
    beta1_d = beta1*d1; %value of Beta*d1
    
    zin1 = z0m*((25 + z0m*tan(beta1_d)*sqrt(-1))/(z0m + 25*tan(beta1_d)*sqrt(-1))); %the input impedance seen at the right side of the transformer
    
    beta2 = (2*pi)/(lambda_gt);
    beta2_lt = beta2*lt;
    
    zin2 = z0t*((zin1+sqrt(-1)*z0t*tan(beta2_lt))/(z0t+sqrt(-1)*zin1*tan(beta2_lt))); %zin1 is now the load as seen by the left end of the transformer
   
    ref_coef = (zin2-z0m)/(zin2+z0m); % reflection coefficient. zin2 now becomes the load as seen by the far left end of the mainline
    ref_coef_mag = abs(ref_coef); %taking the magnitude of the reflection coefficient
    
    SWR([index]) = (1+ref_coef_mag)/(1-ref_coef_mag); %calculating the SWR and storing it into its array slot
end

plot(freq,SWR,'m','Linewidth',2);
ylim([1 3]);
xlim([1.5 3.5]);
grid on;
title('SWR to the left of the transformer vs. Frequency');
xlabel('Frequency [GHz]');
ylabel('SWR [ ]');
yline(2, 'r--','linewidth',1);
hold on
plot(2.182,2,'r*','linewidth',2);
plot(2.822,2,'r*','linewidth',2);

    