%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 系统离散化 代码
%% 作者：简涛
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 程序初始化，清空工作空间，缓存，
clear all;
close all;
clc;
% 读取Octave控制数据库（注：如使用Matlab，可删除或注释掉本行代码）
%pkg load control;
%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 定义小车倒立摆物理性质
r = 0.075; %车轮的半径
d= 0.4048; %左轮、右轮两个轮子间的距离
l = 0.085; %摆杆质心到转轴距离
m = 0.32; %车轮的质量
M = 10.43; %摆杆质量
I = (1/2)*m*r^2; %车轮的转动惯量
Jz = (1/3)*m*l^2; %机器人机体对 z 轴的运动时产生的转动惯量(俯仰方向)
Jy = (1/12)*m*d^2; %机器人机体对 y 轴的运动时产生的转动惯量(偏航方向)
g = 9.8; %重力加速度b = 1e-4;
%% 状态空间矩阵
Q_eq = Jz*M + (Jz+M*l*l) * (2*m+(2*I)/r^2);
% A为系统矩阵
A_23=-(M^2*l^2*g)/Q_eq;
A_43=M*l*g*(M+2*m+(2*I/r^2))/Q_eq;  
A = [0 1 0 0;
0 0 A_23 0;
0 0 0 1;
0 0 A_43 0];
% B为输入矩阵
B_21=(Jz+M*l^2+M*l*r)/Q_eq/r;
B_41=-((M*l/r)+M+2*m+(2*I/r^2))/Q_eq;
B = [0 ;
2*B_21;
0 ;
2*B_41];
% C为输出矩阵
C = [1 0 0 0;
0 0 1 0];
D = [0;0];
%定义两组采样时间
Ts = 0.01;
%根据公式计算；
%Fd_1 = expm(A*Ts_1)
%Gd_1 = pinv(A)*(Fd_1-eye(size(Fd_1)))*B
sys_continuous=ss(A,B,C,D);
sys_discrete=c2d(sys_continuous, Ts, 'zoh');
A_discrete = sys_discrete.A;
B_discrete = sys_discrete.B;
C_discrete = sys_discrete.C;
D_discrete = sys_discrete.D;

% 设计离散时间 LQR 控制器
Q = diag([4 4 6 4]);  % 状态权重矩阵
R = 0.9;      % 输入权重矩阵

[K, S, e] = dlqr(sys_discrete.A, sys_discrete.B, Q, R);

sys_discrete.A=sys_discrete.A-sys_discrete.B*K;

% 初始条件
x0=[0 0 0.43 0];
t_discrete = 0:Ts:10;  % 离散时间向量
[row_count, col_count] = size(t_discrete);
% 创建与 TS 相似的零矩阵
u_discrete = zeros(row_count, col_count);%0输入

[y_discrete, t_discrete, x_discrete] = lsim(sys_discrete, u_discrete, t_discrete,x0);

% 绘制仿真结果
subplot(2, 1, 1);
plot(t_discrete, y_discrete(:,1));
title('Output Response (Discrete Time)');

subplot(2, 1, 2);
stairs(t_discrete, y_discrete(:,1));
title('Input Signal (Discrete Time)');
