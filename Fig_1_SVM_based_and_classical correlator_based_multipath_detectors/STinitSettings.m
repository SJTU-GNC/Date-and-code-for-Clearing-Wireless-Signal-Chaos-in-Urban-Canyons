function settings = STinitSettings

%% ------------------------ Inizialization-------------------------------

settings.fs                          = 4e6;                                           % sampling frequency [Hz]
% settings.fs=4.092e6;
settings.lamda1                      = 154;
settings.lamda2                      = 120;
settings.lamda5                      = 115;
settings.B1I                         = 153;
settings.B3                          = 124;
settings.f0                          = 10.23e6;                                       %原子钟基准频率

%lamad*f0=载波中心频率

%%------OCXO------%%
settings.h2                          =3.565e-26; %TCXO
settings.h1                          =8.752e-26; %暂定
settings.h0                          =5.261e-26; %OCXO
settings.c                           =299792458;
%%------dynamic parameter: qa-------%%
settings.qa                          = 50;                                            %多普勒变化率有关
settings.Tic_D                       = 10e-3;                                         % Dll coherent integration time [s]
settings.Tic_P                       = 10e-3;                                         % Pll coherent integration time [s]
%DLL、PLL积分时间可以分别设置，相干/非相干
settings.Order_P                     = 3;                                            % PLL order
settings.Order_D                     = 2;                                            % DLL order

settings.L_D                         = round( settings.Tic_D * settings.fs );         % Number of samples used by the I&D block(DLL)
settings.L_P                         = round( settings.Tic_P * settings.fs );         % Number of samples used by the I&D block(PLL)

settings.ds                          = 1;                                            % Early-minus-Late chip spacing
settings.BW_dll                      = 0.5;                                          % DLL bandwidth [Hz]
settings.BW_pll                      = 10  ;                                         % PLL bandwidth [Hz]
settings.BL_dll                      = settings.BW_dll * settings.Tic_D;             % DLL bandwidth * Integration Time
settings.BL_pll                      = settings.BW_pll * settings.Tic_P;             % PLL bandwidth * Integration Time

settings.nc_L1                       = 1023; %L1 码长 [chip]
settings.Tcode_L1                    = 1 ;   %L1 码周期 [ms]
settings.Tc_L1                       = settings.Tcode_L1 / settings.nc_L1; % Chip duration [ms/chip]
settings.codeFreq_L1                 = 1.023e6; %L1码率[HZ]

settings.nc_L2                       = 10230; %L2 码长
settings.Tcode_L2                    = 20 ;   %L2 码周期[ms]
settings.Tc_L2                       = settings.Tcode_L2 / settings.nc_L2; % Chip duration
settings.codeFreq_L2                 = 1.023e6; %L2C码率[HZ]

settings.nc_L5                       = 10230; %L5 code period
settings.Tcode_L5                    = 1 ;   %L5 码周期[ms]
settings.Tc_L5                       = settings.Tcode_L5 / settings.nc_L5; % Chip duration
settings.codeFreq_L5                 = 10.23e6; %L5码率[HZ]


settings.BIF                         = settings.fs/2;                                 % Front-end bandwidth [Hz]
settings.CN0dB_L1                    = 40;                                       % Carrier-to-noise-density ratios [dB-Hz]
settings.Ncn0_L1                     = length(settings.CN0dB_L1);
settings.CN0dB_L2                    = 40;                                       % Carrier-to-noise-density ratios [dB-Hz]
settings.Ncn0_L2                     = length(settings.CN0dB_L2);
settings.CN0dB_L5                    = 40;                                       % Carrier-to-noise-density ratios [dB-Hz]
settings.Ncn0_L5                     = length(settings.CN0dB_L5);
settings.Ts                          = 50;                                           % Time of simulaton [s]
settings.numPoints_D                 = settings.Ts / settings.Tic_D;                   % number of simulation points(DLL)
settings.numPoints_P                 = settings.Ts / settings.Tic_P;                   % number of simulation points(PLL)

settings.trans_D                     = 0;                                          % Duration of the loop transient response (approximate value,DLL)
settings.trans_P                     = 0;                                          % Duration of the loop transient response (approximate value,PLL)
%过渡时间（DLL\PLL可以分别设置）

%NLOS parameters             
settings.codedelay_N                 = settings.ds*0.6;                           %多径码延迟
settings.att_coe                     = 0.5; %0.707                                  %多径衰减系数 
settings.phi_err_N                   = 0.6*pi;                                    %多径相位旋转
settings.fd_err_N                    = 1;                 %多径反射频率
% settings.fd_err_N                    = 0;                 %多径反射频率
%% 2 --------------------- True (input) parameters ------------------------
%真值，phase 和时延一致，统一一下，一个频点统一 比如伪距要根据时间相关量更新
%L1真值
settings.fdot0_L1                     = 1.313456*1e-3;%初始多普勒频移变化率
settings.fd0_L1                       = -401.3423333333*1e-3;%初始多普勒频移
settings.tdot0_L1                     = -0.04;  %初始时延变化率
settings.tau0_L1                      = 0.4;  %初始时延 [chip]
settings.rou0_L1                      = 0;  %初始伪距

% settings.taudotL1                       = 0;  %时延变化率
% settings.tauL1                          = 0;  %时延 [chip]
% settings.fdotL1                         = 0.5;%多普勒频移变化率
% settings.fdL1                           = 40; %多普勒频移
% settings.rouL1                         = 0;  %伪距

%L2真值
settings.fdot0_L2                     = 1.313456*1e-3;
settings.fd0_L2                       = -401.3423333333*1e-3;
settings.tdot0_L2                     = -0.04;  %初始时延变化率
settings.tau0_L2                      = 0.4;  %初始时延
settings.rou0_L2                      = 0;  %初始伪距

% settings.taudotL2                       = 0;  %时延变化率
% settings.tauL2                          = 0;  %时延
% settings.fdotL2                         = 0.5;
% settings.fdL2                           = 40;
% settings.rouL2                          = 0;  %伪距

%L5真值
settings.fdot0_L5                      = 1.313456*1e-3;
settings.fd0_L5                        = -401.3423333333*1e-3;
settings.tdot0_L5                      = -0.04;  %初始时延变化率
settings.tau0_L5                       = 0.4;  %初始时延
settings.rou0_L5                       = 0;  %初始伪距

% settings.taudotL5                       = 0;  %时延变化率
% settings.tauL5                          = 0;  %时延
% settings.fdotL5                         = 0.5;
% settings.fdL5                           = 40;
% settings.rouL5                          = 0;  %伪距
%% --------------------------Acquistion bias--------------------------------
%捕获偏差，最好默认为0，作为接口留出
settings.dphi_L1                       = 0;
settings.dfd_L1                        = 0;
settings.dfdot_L1                      = 0;
settings.dtau_L1                       = 0;
settings.dtdot_L1                      = 0;

settings.dphi_L2                       = 0;
settings.dfd_L2                        = 0;
settings.dfdot_L2                      = 0;
settings.dtau_L2                       = 0;
settings.dtdot_L2                      = 0;


settings.dphi_L5                       = 0;
settings.dfd_L5                        = 0;
settings.dfdot_L5                      = 0;
settings.dtau_L5                       = 0;
settings.dtdot_L5                      = 0;


end