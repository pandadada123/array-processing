function [x,XX,H,HH] = gendata_conv(s,P,N,sigma,m)
% default L=1
H=zeros(P,1);
for iter=1:P
    H(iter)=func_h((iter-1)*1/P);
end

sigma2=sigma^2;
noise=sqrt(sigma2/2)*randn(P,N) + 1i*sqrt(sigma2/2)*randn(P,N);
X=H*s+noise;
x=transpose(X(:));

XX=X(:,1:N-m+1); % initialize 
indices=find(XX);
for iter2=1:m-1
    stack=x(indices+iter2*P);
    XX=[XX;reshape(stack,P,N-m+1)];% stack m matrices, each one consists of P rows
end

Hcell=repmat({H},1,m);
HH=blkdiag(Hcell{:});
HH=transpose(rot90(HH));
end

function h=func_h(t)
h=1*(t>=0 & t<0.25)+(-1)*(t>=0.25 & t<0.5)+1*(t>=0.5 & t<0.75)+(-1)*(t>=0.75 & t<1)
end