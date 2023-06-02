clear all 
close all
%% Signal model
N=500;
% P=4;
P=8;
% sigma=0;
sigma=0.5;
m=2;
s0=[2*randi([0,1],1,N)-1;2*randi([0,1],1,N)-1];
s=1/sqrt(2)*[1,1j]*s0;% QPSK
% s=randi([1,100],1,N);

[x,XX,H,HH]=gendata_conv(s,P,N,sigma,m);
r=rank(XX)
[U,S,V]=svd(XX)

%% Zero-forcing and Wiener equalizer
W1=pinv(HH)';
SS_est=W1'*XX;
s_est=[transpose(flip(SS_est(:,1))),SS_est(1,2:end)];

W2=pinv((HH*HH'+sigma*eye(m*P)))*HH;
SS_est2=W2'*XX;
s_est2=[transpose(flip(SS_est2(:,1))),SS_est2(1,2:end)];

plot(s_est,'*b')
hold on
plot(s_est2,'*y')
hold on
plot(s,'*r')
legend('estimated by Zero-forcing','estimated by Wiener','original s')
