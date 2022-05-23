%% m03_trim_and_linearize
% Script to linearize m02_linearization_model

clear
clc

[X0, U0, Y0] = trim('m02_linearization_model');

[As,Bs,Cs,Ds] = linmod('m02_linearization_model', X0, U0) %#ok<NOPTS>

%% Convert to a transfer function
P = ss(As,Bs,Cs,Ds);
zpk(P)

%% Visualize in frequency domain

figure(1)
clf
om_rad = logspace(-4, 4, 1001);

bode(P, om_rad)
grid on

%% Save data so I don't need to run everything again
P = sminreal(P); % cut out extra states
save linearization_data P X0 Y0 U0

