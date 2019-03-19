%% Regressione - Exe 19/03/2019

%% Simulazione e stima modello autogressivo
%% y_(t)=b*y_(t-1)+z_(t)+z_(t-1)

T=1000; % numero instanti di tempo da simulare
beta=0.8; % modulo < 1
sigma_zeta=0.5; 

% Simulazione -> ciclo for
for h=1:100 % ho deciso di fare cento simulazioni
    disp(h)
    % due vettori inizializzati a 0
    y=zeros(T,1); % contiene la y
    z=zeros(T,1); % contiene la parte stocastica
    
    for t=2:T % simulo la traiettoria (intero vettore y(t)) dell'equazione ricorsiva
        z(t)=normrnd(0,sigma_zeta,1,1); % attenzione ai due 1: scalare necessario
        y(t)=beta*y(t-1)+z(t)+z(t-1); % equazione del modello autoregressivo
    end
    
    x=y(1:end-1);
    y=y(2:end);
    
    % CLS
    X=x;
    beta_hat(h)=inv(X'*X)+X'*y; % minimi quadrati
    
    % GLS - minimi quadrati generalizzati
    V=speye(T-1)*sigma_zeta^2*2; % matrice varianza p.12
                                 % speye: matrice sparsa con in memoria
                                 % solo la diagonale
                                 % *2 poiche ho la somma dei due termini
    for i=1:T-2
        V(i,i+1)=sigma_zeta^2; % uguale alla covarianza, in questo caso (p.9) essa
                               % è uguale alla varianza
        V(i+1,i)=sigma_zeta^2;
    end
    
    V_inv=V\speye(size(V));
    
    beta_hat_GLS=inv(X'*V_inv*X)*X'*V_inv
        
end

% NOTE:  plot(y) per vedere il grafico dei miei dati
%        histogram
%        imagesc(V) vedere la matrice
%        plot(x,y,'*') plotto i vettori

%        slide 8-9 fondamentali

% Regressione pesata
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

% Perturbazione
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

% Minimi quadrati ponderati

D=diag([1 1 1 1 1 1 1 1 1 1 1 2 2 1 1]);
beta2 = inv(X'*inv(D)*X)*X'*inv(D)*y;
yy=xx*beta2(2)+beta2(1);
figure
plot(xx,yy,'r');
hold on
plot(x,y,'o');
