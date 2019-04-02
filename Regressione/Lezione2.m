%Simulazione e stima modello autoregressivo
%y_{t}=b*x+z_{t}+z_{t-1}
clc
clear all

T=10000;
beta=0.8;
sigma_zeta=0.5;

for h=1:100
    disp(h)
    y=zeros(T,1);
    z=zeros(T,1);
    for t=2:T
        z(t)=normrnd(0,sigma_zeta,1,1);
        y(t)=beta*y(t-1)+z(t)+z(t-1);
    end
    
    x=y(1:end-1);
    y=y(2:end);
    
    %OLS
    X=x;
    beta_hat(h) = inv(X'*X)*X'*y;
end

%GLS
V=speye(T-1)*sigma_zeta^2*2;
for i=1:T-2
    V(i,i+1)=sigma_zeta^2;
    V(i+1,i)=sigma_zeta^2;
end

V_inv=V\speye(size(V));

beta_hat_GLS = inv(X'*V_inv*X)*X'*V_inv*y;

%Regressione pesata
x=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15]';
y=[1.5 1.7 3.4 4.7 5.9 7 6.9 8.3 9.5 10 11.3 12.8 13.5 13.9 15.6]';
X=[ones(length(x),1) x];
beta = inv(X'*X)*X'*y;

xx=1:0.01:15;
yy=xx*beta(2)+beta(1);
figure
plot(xx,yy,'r');
hold on
plot(x,y,'o');

%Perturbazione
x=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15]';
y=[1.5 1.7 3.4 4.7 5.9 7 6.9 8.3 9.5 10 11.3 20 22 13.9 15.6]';
X=[ones(length(x),1) x];
beta = inv(X'*X)*X'*y;

xx=1:0.01:15;
yy=xx*beta(2)+beta(1);
figure
plot(xx,yy,'r');
hold on
plot(x,y,'o');

%Minimi quadrati ponderati

D=diag([1 1 1 1 1 1 1 1 1 1 1 20 20 1 1]);
beta2 = inv(X'*inv(D)*X)*X'*inv(D)*y;
yy=xx*beta2(2)+beta2(1);
figure
plot(xx,yy,'r');
hold on
plot(x,y,'o');

%algoritmo iterativo pesi
x=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15]';
y=[1.5 1.7 3.4 4.7 5.9 7 6.9 8.3 9.5 10 11.3 20 22 13.9 15.6]';
xx=1:0.01:15;
D=[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
plot(x,y,'o');
hold on
last_beta=[0 0]';
exit=0;
iteration_count=1;
while exit==0
    disp(['Iteration ',num2str(iteration_count)]);
    DD(iteration_count,:)=D;
    D = diag(D);
    beta = inv(X'*inv(D)*X)*X'*inv(D)*y;
    res = y - (beta(1)+beta(2)*x);
    D = abs(res)'+0.001;
    yy=xx*beta(2)+beta(1);
    plot(xx,yy);
    pause(2)
    delta=norm(last_beta-beta);
    if delta<0.001
        exit=1;
    end
    iteration_count=iteration_count+1;
    last_beta=beta;
end