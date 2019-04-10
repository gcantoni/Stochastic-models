%% ASSEGNAZIONE
% Tramite un approccio di simulazione stocastica valutare la matrice di
% varianza-covarianza dei parametri della mistura stimati tramite algoritmo
% EM sulla segmentazione immagine. Rappresentare graficamente la 
% distribuzione marginale di ciascun parametro. 

%% SVOLGIMENTO
clc
clearvars

Y = imread('daphne.jpg');

Y=nanmean(Y,3);
s=size(Y);
Y=Y(:);

disp_opt = 'off';
options = statset('Display',disp_opt);
k = 3;
obj = gmdistribution.fit(Y,k,'Options',options);

P = posterior(obj,Y);
[~,idx]=max(P,[],2);
idx=reshape(idx,s);

mu=obj.mu;
v=squeeze(obj.Sigma);

%Simulazione stocastica
par_all=[];
for i=1:250
    disp(i);
    image_sim=normrnd(mu(idx), sqrt(v(idx)));
    obj = gmdistribution.fit(Y,k,'Options',options);
    
    mu_sim=obj.mu';
    [~,idx2]=sort(mu_sim);
    
    mu_sim=mu_sim(idx2);
    sigma_sim=squeeze(obj.Sigma)';
    sigma_sim=sigma_sim(idx2);
    p_sim=obj.ComponentProportion;
    p_sim=p_sim(idx2);
    
    par_all=cat(1,par_all,[mu_sim sigma_sim p_sim]);
end

%Calcolo della matrice varianza-covarianza
C=cov(par_all);

%Rappresentazione grafica delle distribuzioni dei parametri
for i=1:size(C,1)
    subplot(sqrt(size(C,1)),sqrt(size(C,1)),i);
    hist(par_all(:,i),15);
end
