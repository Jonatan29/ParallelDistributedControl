clear
clc
%% Configure Folders Needed
addpath('../SimulinkFiles')
%% Define Simulation Time
disp('++++++++++++++++++++++++++++++++++++')
SimTime = input('-->Define the duration of the simulation:')
warning('--> Make sure both simulinks are running with the same step values')
warning('--> Make sure both the disturbance applied is the same for both situations')
disp('++++++++++++++++++++++++++++++++++++')
%% Define Initial Conditions
InitCondqp = [0 pi/4];
InitCondq = [0 0];
%% Run Simulink PDC Control
out = sim('SIMULINK_InvertedPendulum_PDC',SimTime)
disp('--> The initial Conditions are:')
% set_param('SIMULINK_InvertedPendulum_PDC/Integrator','InitialCondition',mat2str(InitCond))
set_param('SIMULINK_InvertedPendulum_PDC/Integratorqpp','InitialCondition',mat2str(InitCondqp))
set_param('SIMULINK_InvertedPendulum_PDC/Integratorqp','InitialCondition',mat2str(InitCondq))
disp(InitCondqp)
disp(InitCondq)
X1 = out.outX(:,1);
X2 = out.outX(:,2);
X3 = out.outX(:,3);
X4 = out.outX(:,4);
U = out.outU;
ALFA = out.outAlfa;
time = out.tout;
%% Run Simulink PDC Hinf Control
out_ = sim('SIMULINK_InvertedPendulum_PDCHinf',SimTime)
disp('--> The initial Conditions are:')
% set_param('SIMULINK_InvertedPendulum_PDC/Integrator','InitialCondition',mat2str(InitCond))
set_param('SIMULINK_InvertedPendulum_PDCHinf/Integratorqpp','InitialCondition',mat2str(InitCondqp))
set_param('SIMULINK_InvertedPendulum_PDCHinf/Integratorqp','InitialCondition',mat2str(InitCondq))
disp(InitCondqp)
disp(InitCondq)
X1_ = out_.outX(:,1);
X2_ = out_.outX(:,2);
X3_ = out_.outX(:,3);
X4_ = out_.outX(:,4);
U_ = out_.outU;
ALFA_ = out.outAlfa;
% time = out.tout;

%% Plot Results
figure
subplot(2,2,1)
plot(time,X1,'-r',time,X1_,'--r')
    xlabel('simulaton time')
    ylabel('s')
    legend('s-PDC','s - PDCHinf')
    xlim([0 SimTime])
     grid on
subplot(2,2,2)
plot(time,X2,'-b',time,X2_,'--b')
    xlabel('simulaton time')
    ylabel('\theta')
    legend('\theta - PDC','\theta - PDCHinf')
   xlim([0 SimTime])
     grid on
subplot(2,2,3)
plot(time,X3,'-g',time,X3_,'--g')
    xlabel('simulaton time')
    ylabel('v')
    legend('v - PDC','v - PDCHinf')
%     ylim([-7 7])
  xlim([0 SimTime])
     grid on
subplot(2,2,4)
% plot(linspace(0,time(end),length(ALFA)),ALFA,'-b')
plot(time,X3,'-g',time,X3_,'--g')
 grid on
 set(gcf,'color','w');
xlim([0 SimTime])
 xlabel('simulaton time')
 ylabel('\omega')
 legend('\omega - PDC','\omega - PDCHinf')
 suptitle('Comparison Between PDC and PDC mix Hinf')
 figure
 plot(time,U,'-g',time,U_,'--g')
 grid on
 set(gcf,'color','w');
  xlabel('simulaton time')
 ylabel('Control Inputs')
 legend('Controller PDC','Controller PDCHinf')
title('Comparison Between PDC and PDC mix Hinf Controller')