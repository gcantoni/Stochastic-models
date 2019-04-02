clc
clear all

load Lisa_Lab_34col.mat

ElapsedTime=A.ElapsedTime;
TChambInt=A.TChambInt;

%Recupera gli indici dei cicli
idx=find(diff(ElapsedTime)<0);

%Estra il primo ciclo
ElapsedTime=ElapsedTime(1:idx(1));
TChambInt=TChambInt(1:idx(1));

%Modello di regressione semplice
y=TChambInt;
x=ElapsedTime;

figure
plot(x,y);
xlabel('Time');
ylabel('Temperature');

X=[ones(length(x),1) x];
[b,bint,r,rint,stats]=regress(y,X);

y_hat=b(1)+b(2)*x;

figure
plot(x,r); %Che caratteristica hanno i residui?

figure
plot(x,y);
hold on
plot(x,y_hat,'r-');
xlabel('Time');
ylabel('Temperature');

%Modello polinomiale?

x=(x-mean(x))./std(x); %Perché standardizzare? Provare senza

X=[ones(length(x),1) x x.^2 x.^3 x.^4 x.^5 x.^6];
[b,bint,r,rint,stats]=regress(y,X);

y_hat=b(1)+b(2)*x+b(3).*x.^2+b(4).*x.^3+b(5).*x.^4+b(6).*x.^5+b(7).*x.^6;

figure
plot(x,y);
hold on
plot(x,y_hat,'r-');
xlabel('Time');
ylabel('Temperature');

figure
plot(x,r); %Che caratteristica hanno i residui?

% Spline
x=ElapsedTime;

sp=spaps(x,y,0.1);
xx=min(x):0.1:max(x);
yy=fnval(sp,xx);

figure
plot(x,y);
hold on
plot(xx,yy,'r-');
xlabel('Time');
ylabel('Temperature');


res=y-fnval(sp,x);
figure;
plot(x,res);
xlabel('Time');
ylabel('Temperature');