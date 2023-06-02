function [X,A,S] = gendata(M,N,Delta,theta,f,SNR)
k=1:N; % row vector
S=exp(1j*2*pi*f*k);

theta_rad=theta*pi/180;
phi=2*pi*Delta*sin(theta_rad);% col vector
m=0:M-1;
A=exp(1j*m'*phi'); % col*row

sigma2=1/(10^(SNR/10))/N; % Note: divided by N
noise=sqrt(sigma2/2)*randn(M,N) + 1i*sqrt(sigma2/2)*randn(M,N);
X=A*S+noise;