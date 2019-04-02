%Esercitazione spline

%Simulare 20 coppie di dati (x,y) sul range [0,100] dalla funzione
%y=x*sin(x)+e con e~N(0,10);

%Considerando il comando spaps di MATLAB, trovare il valore
%massimo dell'argomento di input tol tale che il coefficiente
%di determinazione R^2 sia maggiore o uguale a 0.9

%Stimare la spline con il valore di tol trovato e rappresentare
%il normal probability plot dei residui dalla spline
clc
clearvars

N=20;
x=unifrnd(0,100,N,1);
x=sort(x);
y=x.*sin(x);
y=y+normrnd(0,sqrt(10),N,1);

tol=0;
exit=0;
while (exit==0) % non conosco numero iterazioni ? uso il while
    [sp,y_hat]=spaps(x,y,tol);
    y_hat=y_hat';
    R2=1-var(y_hat-y)/var(y);
    if R2<0.9
        exit=1;
    end
    tol=tol+1;
end

figure
fnplt(sp);
hold on
plot(x,y,'*r');

figure
normplot(y-y_hat)
