function [theta,f] = joint(Z,m_order2,M,N,d,Delta)
m=m_order2;
[Uz,Sz,Vz] = svd(Z); %rank Z = 2
U=Uz(:,1:d); % get approximate of U, principal left d columns

J11=kron([eye(m-1),zeros(m-1,1)],eye(M));
J12=kron([zeros(m-1,1),eye(m-1)],eye(M));

J21=kron(eye(m),[eye(M-1),zeros(M-1,1)]);
J22=kron(eye(m),[zeros(M-1,1),eye(M-1)]);

U11=J11*U;
U12=J12*U;
U21=J21*U;
U22=J22*U;

MM(:,:,1)=pinv(U11)*U12; % frequency
MM(:,:,2)=pinv(U21)*U22; % angle

% Jacobi
jthresh = 1.0e-16;
[V,D] = joint_diag(MM,jthresh);
Phi_est1=diag(D(:,:,1));
Phi_est2=diag(D(:,:,2));

f=angle(Phi_est1)/2/pi; 
theta=asin(angle(Phi_est2)/2/pi/Delta)*180/pi; % angle:[-pi,pi], asin: [-pi/2,pi/2]