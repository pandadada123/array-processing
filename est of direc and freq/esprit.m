function theta = esprit(X,d,Delta)
[MM,NN]=size(X);
% Rx=(1/NN)*(X*X');
% Cov=(1/NN)*kr(conj(Rx),Rx);
% theta = espritdoa(Cov,d); %Default as Half-Wavelength-Spaced

X0=X(1:MM-1,:);
X1=X(2:MM,:);
Z=[X0;X1];
[Uz,Sz,Vz] = svd(Z);
U=Uz(:,1:d); % get approximate of U, principal left d columns
U0=U(1:MM-1,:);
U1=U(MM:2*(MM-1),:);
Phi_est=eig(pinv(U0)*U1);

% th = 0:pi/50:2*pi;
% xunit = cos(th);
% yunit = sin(th);
% figure
% plot(xunit, yunit);hold on %plot unit circle
% plot(Phi_est,'*')

theta=asin(angle(Phi_est)/2/pi/Delta)*180/pi; % angle:[-pi,pi], asin: [-pi/2,pi/2]

