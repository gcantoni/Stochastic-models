%% Esercitazione SSM - Regressione Dinamica

% esercizi su state space 2016-05-17
% argomento: regressione a coefficienti tempo-varianti
%return
close all
if 0
    clear all
    load('QARIA_A.mat')
end

if 1
    y=tA.logPM;
    x=tA.Temperatura;
    y = zscore(y); % standardizzate - media 0 e varianza 1
    x = zscore(x); % idem
    n = length(y);
    figure(9)
    subplot(1,3,1)
    plot(y)
    title('logPM')
    axis tight
    subplot(1,3,2)
    plot(x)
    title('temperature')
    axis tight
    subplot(1,3,3)
    scatter(x,y,'.')
    axis tight
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % regressione ordinaria
    m_regr=fitlm(x,y)
    hold on
    m_regr.plot
    subplot(1,3,1)
    hold on
    plot(m_regr.Fitted) % grafico valori interpolati
    legend({'obs','ols.fit'})
end

% return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% modello local level
% state space tempo-invariante
% x(t) = A*x(t-1) + B*eta(t)
%      =   x(t-1) + B*N(0,1)
% y(t) = C*x(t) + D*eps(t)
% y(t) =   x(t) + D*N(0,1)

if 0
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % due varianze ignote
    A = 1; B = nan; C = 1; D = nan;
    m0 = ssm(A,B,C,D);
    % valori iniziali dei parametri
    params0 = [1,1]; %[B,D]
    % stima MLE
    mhat = estimate(m0,y,params0,'lb',[0,0],'Display','full');
    %return
end
if 0
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % una sola varianza ignota x identificabilità
    m0 = ssm(1,NaN,1,.1);
    % valori iniziali dei parametri
    params0 = [1];
    % stima MLE
    mhat = estimate(m0,y,params0,'lb',[0]);
    
    % stime dello stato
    x_ks = smooth(mhat,y);
    x_kf = filter(mhat,y);
    x_h = [nan; x_kf(1:n-1)*mhat.A];
    figure(1)
    plot([y x_kf x_ks x_h])
    legend({'data','filt','smooth','forecast'})
    %plot([y])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% regressione a 1 coeff. variabile via
% modello state space a matrici tempo-varianti
%
% y(t) = beta(t)x(t) + e(t)
% beta(t) = beta(t-1) + omega(t)
% A=1
% B=nan
% C=x(t) -> tempo variante
% D=nan

% modello implicito via tVarPar()
% il vettore x deve essere definito nella workspace
if 1
%     y = m_regr.Residuals.Raw;
%    D0 = 1;
    m0= ssm(@(params)tVarPar(params,x));
    params0 = [1,log(m_regr.MSE)]; % valori iniziali -> 1 e varianza residua della regressione
    
    % log(MSE) -> varianza residua
    % SSM nel caso matriciale vuole deviazioni standard
    
    disp('Stima')
    mhat = estimate(m0,y,params0); % MLE - attenzione ai parametri che posso prendere
    
    % stima dello stato
    beta.filt = filter(mhat,y);
    beta.smooth = smooth(mhat,y);
    beta.forecast = [beta.filt(1); beta.filt(1:end-1)];
    
    % INTERVALLI DI CONFIDENZA
    % EstParamCov -> matrice di varcov di teta (p. 10 slide)
    % ?? DA CHIEDERE
    
    % calcolo dei beta con filtro, smooth e previsione (p. 4 slide)
    % moltiplico per la x per ottenere la y!!!
    yh_kf = beta.filt.*x;
    yh_ks = beta.smooth.*x;
    yhat = beta.forecast.*x;
    
    % KF -> KALMAN FILTER // KS -> KALMAN SMOOTH
    e_kf=y-yh_kf;
    e_ks=y-yh_ks;
    e =y-yhat;
    [mean(e_kf), var(e_kf); ...
        mean(e_ks), var(e_ks); ...
        mean(e), var(e)]
    
    ols=m_regr.Fitted;
    
    figure(2)
    plot([ols, y, yh_kf, yh_ks, yhat])
    title('y(t)=beta(t)x(t)+e(t) via KF/KS')
    axis tight
    legend({'data','kf','ks', 'yhat','OLS'})
end