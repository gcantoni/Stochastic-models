%Esercitazione spline

%Simulare 20 coppie di dati (x,y) sul range [0,100] dalla funzione
%y=x*sin(x)+e con e~N(0,10);

%Considerando il comando spaps di MATLAB, trovare il valore
%massimo dell'argomento di input tol tale che il coefficiente
%di determinazione R^2 sia maggiore o uguale a 0.9

%Stimare la spline con il valore di tol trovato e rappresentare
%il normal probability plot dei residui dalla spline

y=zeros(20,1);
x = unifrnd(0,100,20,1);
x = sort(x);

for i=1:20
    y(i,1) = x(i)*sin(x(i)) + normrnd(0,sqrt(10),1,1);
end

exit = 0;
tol = 0;

while exit==0
    
    [sp, y_hat] = spaps(x,y,tol);
    y_hat = y_hat';
    RSS = 0;
    TSS = 0;
    for t=1:20
        RSS = RSS + (y(t)- y_hat(t))^2;
        TSS = TSS + (y(t) - mean(y))^2;
    end
    
    R_square = 1 - (RSS/TSS);

    if R_square <= 0.9
        exit = 1;
    else
        tol = tol + 1;
    end
end
       
normplot(y-y_hat);

