clear all
close all
%% Data model
Delta=1/2;

d=2; % number of sources
M=5;
% M=10;
% M=3;
N=20000;
% N=40; 
theta=[70;-20];
% theta=[0;10];
% theta=[0;0];
f=[0.1;0.3];
% f=[0.1;0.12];
% f=[0.19;0.21];
% f=[0.1;0.1];
SNR=2000000; %dB, per source
[X,A,S] = gendata(M,N,Delta,theta,f,SNR);
%% Singular values of X
[U,evalue,V] = svd(X);
svalues = svd(X);
plot(svalues,'*');
title('');
xlabel('Index');
ylabel('Singular value');
%% ESPRIT
% est of directions
theta_est = esprit(X,d,Delta)

% est of freq
f_est = espritfreq(X,d)

% another method
m_order=2;
Z=zeros(m_order*M,N-m_order+1);
for ii=1:m_order
    for jj=1:(N-m_order+1)
        Z(1+M*(ii-1):ii*M,jj)=X(:,ii+jj-1);
    end
end
f_est2 = espritfreq(Z,d)
%% Joint
m_order2=2; % same as m_order
[theta_est_joint,f_est_joint] = joint(Z,m_order2,M,N,d,Delta);

%% Zero-forcing beamformers
% A is known
phi_est=2*pi*Delta*sin(theta_est*pi/180);
m=0:M-1;
A_est=exp(1j*m'*phi_est'); % col*row
W=pinv(A_est)';
S_est=W'*X
S

% S is known
k=1:N; % row vector
S_est_freq=exp(1j*2*pi*f_est*k);
A_est_freq=X*pinv(S_est_freq);
W_freq=pinv(A_est_freq)';
S_est2=W_freq'*X
S

%% Plot zero-forcing beamformers 
% by their spatial responses
% same parameters as before besides SNR = 10dB
% d=2, M=3, N=20, theta = [-20,30], f=[0.1,0.12]

theta_angle_comparison3 = -90:1:90;
% theta_angle_comparison3 = linspace(-90,90);
theta_rad_comparison3=theta_angle_comparison3*pi/180;
phi_comparison=2*pi*Delta*sin(theta_rad_comparison3);
m=0:M-1;
A=exp(1j*m'*phi_comparison); % col*row   col is the a for each theta

% W 
y1 = abs(W(:,1)'*A);
y2 = abs(W(:,2)'*A);
figure
plot(theta_angle_comparison3,y1,theta_angle_comparison3,y2);
title('Spatial response for first beamformer')
xlabel('-90 < \theta < 90')
ylabel('Amplification');
legend({'w1','w2'},'Location','southwest')
xlim([-90 90])

% W_freq
y3 = abs(W_freq(:,1)'*A);
y4 = abs(W_freq(:,2)'*A);
figure
plot(theta_angle_comparison3,y3,theta_angle_comparison3,y4);
title('Spatial response for second beamformer')
xlabel('-90 < \theta < 90')
ylabel('Amplification');
legend({'w1','w2'},'Location','southwest')
xlim([-90 90])
ylim([0 1.2])