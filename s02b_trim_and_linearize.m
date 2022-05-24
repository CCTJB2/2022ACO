%% ACO Q2 model trimming and convert to linearized model 
%
%Trim script for Q2
%#ok<*NOPTS>
clc
clear

%% Setting trim parameters and performing trim
%Model Name
MODEL_NAME = 'm02_linearization_model';

%initial guess for values of outputs
TARGET_GAMMA_DEG = 730;
TARGET_ALPHA_DEG = 70;

%initial guess for values of inputs
TARGET_VAZ_VOLT = 5;
TARGET_VEL_VOLT = 5;

%initial guess for values of states
STATE_GAMMA_DEG = 15;
STATE_dGAMMA_DEG = 1;
STATE_ALPHA_DEG = 30;
STATE_dALPHA_DEG = 1;
STATE_QGAMMA_NM = 1; %azimuth motor torque
STATE_QALPHA_NM = 1; %elevation motor torque

triminit.Y0 = [TARGET_GAMMA_DEG;TARGET_ALPHA_DEG]; %initial guess for the output angles
triminit.U0 = [TARGET_VAZ_VOLT;TARGET_VEL_VOLT]; %initial guess for motor input voltages
triminit.X0 = [STATE_GAMMA_DEG;STATE_dGAMMA_DEG;STATE_ALPHA_DEG;
STATE_dALPHA_DEG;STATE_QGAMMA_NM;STATE_QALPHA_NM]; %starting rough guesses  
%for states at equilibirum for trim, 
%set number greater than zero

triminit.fixedX0Idx = []; %none fixed - let optimizer change
triminit.fixedU0Idx = []; %none fixed - let optimizer change
triminit.fixedY0Idx = []; %fixed - only one element
%triminit.fixeddX0Idx = [];

display(triminit)

%initial state of output at equilibirum point, input to get that, final
%state of output
[X0, U0, Y0] = trim(MODEL_NAME, ...
                 triminit.X0, triminit.U0, triminit.Y0,...
                 triminit.fixedX0Idx, triminit.fixedU0Idx,...
                 triminit.fixedY0Idx)
             %, ...
%                 triminit.dX0, triminit.fixedX0Idx)
             
if abs(triminit.Y0 - Y0) > 1e-6
       warning('Trimming might not have worked.')
end

%% Linearization, getting the trasnfer function

[A_ss, B_ss, C_ss, D_ss] = linmod(MODEL_NAME, X0, U0) %state space matrices 

P_ss_self = ss(A_ss, B_ss, C_ss, D_ss); %forms the state space function for the system

P_self = zpk(P_ss_self) %zero pole gain of system, transfer function

save linearizedModel_Outputs.mat X0 Y0 U0 P_self P_ss_self  %save the variables here named 'linearizedModel_Outputs'

%% Plotting the diagrams for the Plant
om_rad = logspace (-2, 5 , 1001); %logspace 10^(-3) to 10^3 in 1001 steps
step_t = linspace(0, 0.3, 1001); %linespace for plotting step graph

figure(1) %explicitely define the figure to use
clf %explicitely clear the figure
% subplot(121)
bode(P_self, 'b-',om_rad)
legend
grid on

% %% Find S and T
% S = feedback(1, P_self);
% T = 1-S;
% 
% subplot(222)
% bodemag(S, 'b:', T, 'b-',om_rad)
%     
% legend('S','T', ...
%     'Location', 'southwest');
% 
% ylim([-50 10])
% grid on
% 
% subplot(224);
% step(T,'b-',P_self,'r-')
% legend
% grid on
% 
% figure(3)
% nyqplot(P_self);
