clc
clearvars

Y = imread('daphne.jpg');
imagesc(Y);

Y=nanmean(Y,3);
s=size(Y);
imagesc(Y)
colormap gray

Y=Y(:);

disp_opt = 'iter';
options = statset('Display',disp_opt);
k = 3;
obj = gmdistribution.fit(Y,k,'Options',options);

P = posterior(obj,Y);
[~,idx]=max(P,[],2);
idx=reshape(idx,s);
imagesc(idx)

%noise
mu=obj.mu;
v=squeeze(obj.Sigma);
imagesc(normrnd(mu(idx), sqrt(v(idx))));
colormap gray

% Algoritmo EM non permette di fornire un incertezza alle stime ( NO
% inferenza statistica )
