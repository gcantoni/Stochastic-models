%% Simulazione e stima modello autogressivo (molte simulazioni)
%      y_(t)=b*y_(t-1)+z_(t)+z_(t-1)

% Dati
T=1000; % simulo 1000 instanti di tempo
beta=0.8; % modulo di beta < 1
sigma_zeta=0.5;

% due vettori inizializzati a 0
y=zeros(T,1); % vettore che mi contiene la y
z=zeros(T,1); % vettore che mi contiene la parte stocastica

% Simulazione -> ciclo for
for h=1:100 % sto decidendo di effettuare 100 simulazioni
    disp(h); % mostro a display
    
    for t=2:T
        z(t)=normrnd(0,sigma_zeta,1,1); % scalare
        y(t)=beta*y(t-1)+z(t)+z(t-1);
    end
    
    x=y(1:end-1); % y all'instante precedente
    y=y(2:end); % y(t)
    
    % Stima di beta mediante OLS
    X=x;
    beta_hat_OLS=inv(X'*X)*X'*y;
    
    % Stima di beta mediante GLS
    V=speye(T-1)*sigma_zeta^2; % matrice varianza p.12
                               % speye: matrice sparsa con in memoria
                               % solo la diagonale
                               % *2 poiche ho la somma dei due termini
    for i=1:T-2
         V(i,i+1)=sigma_zeta^2; % uguale alla covarianza, in questo caso (p.9) essa
                                % è uguale alla varianza
        V(i+1,i)=sigma_zeta^2;
    end
    
    V_inv=V\speye(size(V));
    beta_hat_GLS=inv(X'*V_inv*X)*X'*V_inv;
    
end

%% Simulazione e stima modello autogressivo (una singola simulazione)
%      y_(t)=b*y_(t-1)+z_(t)+z_(t-1)

T=1000; % numero instanti di tempo da simulare
beta=0.7; % modulo < 1
sigma_zeta=0.5;

% due vettori inizializzati a 0
y=zeros(T,1); % contiene la y
z=zeros(T,1); % contiene la parte stocastica

% Simulazione -> ciclo for
for t=2:T
    z(t)=normrnd(0,sigma_zeta,1,1);
    y(t)=beta*y(t-1)+z(t)+z(t-1);
end

x=y(1:end-1);
y=y(2:end);

%OLS
X=x;
beta_hat_OLS=inv(X'*X)*X'*y;

%GLS
V=speye(T-1)*sigma_zeta^2*2;
for i=1:T-2
    V(i,i+1)=sigma_zeta^2;
    V(i+1,i)=sigma_zeta^2;
end

V_inv=V\speye(size(V));

beta_hat_GLS=inv(X'*V_inv*X)*X'*V_inv*y;
