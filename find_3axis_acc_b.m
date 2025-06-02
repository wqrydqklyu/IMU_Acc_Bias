clc
clear
close all
%% read data from 6 files
% PX
n_PX = 400;
PX_tot = readtable('PX.TXT','Delimiter',',');
PX_3axis = table2array(PX_tot(1:n_PX,3:5));
PX_mean = mean(PX_3axis);

% NX
n_NX = 400;
NX_tot = readtable('NX.TXT','Delimiter',',');
NX_3axis = table2array(NX_tot(1:n_NX,3:5));
NX_mean = mean(NX_3axis)

% PY
n_PY = 600;
PY_tot = readtable('PY.TXT','Delimiter',',');
PY_3axis = table2array(PY_tot(1:n_PY,3:5));
PY_mean = mean(PY_3axis);

% NY
n_NY = 400;
NY_tot = readtable('NY.TXT','Delimiter',',');
NY_3axis = table2array(NY_tot(1:n_NY,3:5));
NY_mean = mean(NY_3axis);

% PZ
n_PZ = 400;
PZ_tot = readtable('PZ.TXT','Delimiter',',');
PZ_3axis = table2array(PZ_tot(1:n_PZ,3:5));
PZ_mean = mean(PZ_3axis);

% NZ
n_NZ = 400;
NZ_tot = readtable('NZ.TXT','Delimiter',',');
NZ_3axis = table2array(NZ_tot(1:n_NZ,3:5));
NZ_mean = mean(NZ_3axis);

%% Construct a mean list
mean_data = [PX_mean; NX_mean; PY_mean; NY_mean; PZ_mean; NZ_mean];

%% dirty bias:
g = 981;
std_g_list = [g 0 0;-g 0 0;0 g 0;0 -g 0;0 0 g;0 0 -g];
bias_only = mean(mean_data- std_g_list)

%% skew + scale + bias
% method 1
% Augment with 1¡¯s column ¡ú [G | 1] theta = A
X      = [std_g_list,  ones(6,1)];           % 6 ¡Á 4
theta  = X \ mean_data;                          % 4 ¡Á 3  (LS solution)

S_est  = theta(1:3, :)'    % 3¡Á3 scale + mis-alignment matrix (note ?)
b_est  = theta(4, :)'       % 3¡Á1 bias vector

% method 2 
% The same as solving it column by column
AA = X;
bb = mean_data(:,3)
xx = inv(AA'*AA)*AA'*bb

%% only scale + bias
Ax_list = [std_g_list(:,1) ones(6,1)]
Ax_corr_para_raw = inv(Ax_list'*Ax_list)*Ax_list'*mean_data(:,1);
AX_k = 1 / Ax_corr_para_raw(1)
AX_b = Ax_corr_para_raw(2)


%% save the calibration results
S_est_inv = inv(S_est);
save('calimat.mat','S_est_inv','b_est')


