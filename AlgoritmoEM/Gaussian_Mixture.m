%rng(1); % For reproducibility
MU1 = [1 2];
SIGMA1 = [2 0; 0 .5];
MU2 = [-3 -5];
MU2 = [-1 .5];

SIGMA2 = [1 0; 0 1];
X = [mvnrnd(MU1,SIGMA1,1000);mvnrnd(MU2,SIGMA2,500)];


scatter(X(:,1),X(:,2),10,'.')
hold on

disp_opt = 'iter'; %'final'
options = statset('Display',disp_opt);
k = 2; % k = 3 , k = 5
obj = fitgmdist(X,k,'Options',options);
obj2 = gmdistribution.fit(X,k,'Options',options);
h = ezcontour(@(x,y)pdf(obj,[x y]),[-8 6],[-8 6]);
hold off
