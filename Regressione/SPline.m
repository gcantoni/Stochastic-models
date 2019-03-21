%% SPline generalizzati

x=[0 1 2.5 3.6 5 7 8.1 10 12];
y=sin(x);

xx=0:.01:10;
yy=spline(x,y,xx); % x, y + vettore passo fine xx
plot(x,y,'o',xx,yy);

% NOTA: aperto il grafico -> Tools -> Basic Fitting per vedere di piu (
% tipo residui )

%% Estrapolazione -> un dato lontano dagli altri 

x=[0 1 2.5 3.6 5 7 8.1 10 28];
y=sin(x);

xx=0:.01:28;
yy=spline(x,y,xx);
plot(x,y,'o',xx,yy);

%% Smoothing SPlines ( penalizzate )

x=[0 1 2.5 3.6 5 7 8.1 10];
y=sin(x);

tol=1; % tolleranza - prova a casa con 5 (ora è una curva ed è troppo penalizzato)
[sp,y_hat]=spaps(x,y,tol);

plot(x,y,'o');
hold on

fnplt(sp); % plotto un oggetto

res= y-y_hat;   
plot(res,'o-');

%% Smoothing SPlines ( penalizzate ) estrapolazione
x=[0 1 2.5 3.6 5 7 8.1 10 28];
y=sin(x);

tol=1; % tolleranza - prova a casa con 4 
[sp,y_hat]=spaps(x,y,tol);

plot(x,y,'o');
hold on

fnplt(sp); % plotto un oggetto

res= y-y_hat;   
plot(res,'o-');