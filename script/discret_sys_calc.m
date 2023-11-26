clear all;
clc;
A=[0 1;-2 -3];
B=[0;1];
T=0.2;
F=expm(A*T)
G=inv(A)*(F-eye(size(A,1)))*B