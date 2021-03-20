clear
clc

%% Run TS model Script
addpath('../TSmodel')
run('ScriptTakagiSugenoModel.m')

%% Run Hinf PDC Controller Script
run('Control/ScriptHinfPDCcontrol.m')

%% Simulation and Results
resp = input('--> Did you substituted the Gains obtained in the OutControllerGains folder into the simulink file "Simulink_Control_HinfPDC"?("y" or "n"):','s');
if strcmp(resp,'y') 
   disp('Good Job!') 
end
if strcmp(resp,'n')
    warning on
    warning('[WARNING!]Running simulations with previous loades Gains[WARNING!]')
end


addpath('../SimulinkFiles')
SimTime = 30;
out = sim('SIMULINK_InvertedPendulum_PDCHinf',SimTime)
disp('--> The initial Conditions are:')
% InitCond = [0 pi/4 0 0];
InitCond = [0 0 0 0];
set_param('SIMULINK_InvertedPendulum_PDCHinf/Integrator','InitialCondition',mat2str(InitCond))
disp(InitCond)
X1 = out.outX(:,1);
X2 = out.outX(:,2);
X3 = out.outX(:,3);
X4 = out.outX(:,4);
U = out.outU;
ALFA = out.outAlfa;
time = out.tout;
figure
subplot(2,2,1)
plot(time,X1,'-r',time,X2,'-b')
    xlabel('simulaton time')
    ylabel('States')
    legend('s','\theta')
     grid on
subplot(2,2,2)
plot(time,X3,'-g',time,X4,'-y')
    xlabel('simulaton time')
    ylabel('States')
    legend('v','\omega')
     grid on
subplot(2,2,3)
plot(time,U,'-r')
    xlabel('simulaton time')
    ylabel('Control Inputs')
    ylim([-7 7])
     grid on
subplot(2,2,4)
plot(linspace(0,time(end),length(ALFA)),ALFA,'-b')
 grid on
 set(gcf,'color','w');
 xlim([0 time(end)])
 xlabel('simulaton time')
 ylabel('Terrain Inclination')
  suptitle('Results For PDC Mixed w/ Hinf Controller')