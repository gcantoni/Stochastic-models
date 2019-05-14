load lawdata
rng default

% Bootstrap parametrico

corr(gpa, lsat)

histogram(lsat)
histogram(gpa)

%% bootstrap parametrico

m0 = mean([gpa, lsat]);

S0 = cov([gpa, lsat]);

ystar = mvnrnd(m0, S0, 1000*15);

lsat_star = reshape(ystar(:,2), 15, 1000);

gpa_star = reshape(ystar(:,1),15,1000);

corr_star = nan(1000, 1);

for j=1:1000
    corr_star(j) = corr(gpa_star(:,j), lsat_star(:,j));
end

histogram(corr_star)
title('corr via bootstrap parametrico')

%% Bootstrap non parametrico

[bootstat, bootsam] = bootstrp(1000, @corr, lsat, gpa);
    
histogram(bootstat)
title('corr via bootstrap non parametrico, bootstrp')

%costruisco rt

rt = unidrnd(15, 15, 1000);

lsat_star2 = lsat(rt);

gpa_star2 = gpa(rt);

corr_star2 = nan(1000,1);

for j=1:1000
    corr_star2(j) = corr(gpa_star(:,j), lsat_star(:,j));
end

histogram(corr_star2)
title('corr via bootstrap a mano')

mean([corr_star, bootstat, corr_star2]);

std([corr_star, bootstat, corr_star2])/sqrt(1000);

%% Esercizio modello AR (tema di esame 9 giugno 2017)

%1. mu != 0
%2. stimare modello M_hat
%3. simulare m=500 replicazioni di serie lunghe n = 700
%4. media, bias, MSE

% carico dati LEARNING cap 5

plot(y)

mhat = estimate(arima(2,0,0), y);

pAR = [1, -mhat.AR{1}, -mhat.AR{2}]; %polinomio caratteristico

zhat0 = max(abs(roots(pAR)));

rng default
ystar = simulate(mhat, 700, 'NumPaths', 500);

zhat_star = nan(500,1);
pAR_star = nan(500,3);


for j=1:700
    mhatj = estimate(arima(2,0,0), ystar(:,j), 'display', 'off');
    pAR_star(j,:) = [1, -mhatj.AR{1}, -mhatj.AR{2}];
    zhat_star(j) = max(abs(roots(pAR_star(j,:))));
end


























    
    
    
    
    
    
    
    
    