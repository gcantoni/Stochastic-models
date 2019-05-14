% ese 2018 block bootstrap via stationaryBB() (in calce!!!)
if 1
    close all
    clear all
    load('Lisa_Lab_34col.mat')
    if 0
        % seleziono un run a caso
        irun = unidrnd(length(A))
    else
        % seleziono il primo run
        irun = 1;
    end
    y=A.TChambInt(A.ID_Run==A.ID_Run(irun));
    x=A.ElapsedTime(A.ID_Run==A.ID_Run(irun));
    
    figure(9)
    subplot(1,2,1)
    plot(y)
    subplot(1,2,2)
    scatter(x,y,'.')
end
n = length(y);
if 0%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % regressione ordinaria
    m_regr=fitlm(x,y)
    hold on
    m_regr.plot
    e=m_regr.Residuals.Raw;
end

if 1
    % splines
    nk = 30;
    xstep = fix(n/nk);
    xi = x(1:xstep:n)';
    %xi=linspace(1,x(end),nk)';
    xxi = xi(1:nk)+xstep/2;
    Y = mean(reshape(y(1:xstep*nk),xstep,nk));

    % B-form smoothing cubic splines
    % using tol constraint
    % errore quadratico corrispondente a 1°C
    tol = .1; 
    [By,yh,rho] =spaps(xxi,Y(:),tol);

    yh = fnval(By,x);
    figure(2)
    fnplt(By, 'b')
    title( [num2str(A.ID_Run(irun)), ...
        '   tol=' num2str(tol)])
%     disp('Nodi')
%     By.knots(:)
%     disp('Coefficienti')
%     By.coefs(:)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    % analisi dei residui
    e=(y-yh);
    e=e(50:end-100);
    yh=yh(50:end-100);
    
    figure(1)
    subplot(2,2,1)
    plot(e)
    title('spline residuals')
    axis tight
    
    subplot(2,2,2)
    histfit(e,30)
    axis tight
    
    subplot(2,2,3)
    normplot(e)
    axis tight
    
    subplot(2,2,4)
    autocorr(e,100)
    axis tight
    if 0
        kurtosis(e)
        skewness(e)
        [h,pval]=jbtest(e)
    end
    % valutazione distorsione
    mean(e)
end

m=100;
n = length(e);
e_star=nan(n,m);
y_star=nan(n,m);

disp('Bootstrap')
tic
for j=1:m
    %disp(sprintf('boot iter %d',j))
    e_star(:,j) = stationaryBB(e,1,30);
    y_star(:,j) = yh + e_star(:,j);
end
toc

figure(4)
plot(y_star)
title('Bootstrapped trajectories')


return
function Zb = stationaryBB(Z,sim,L)
% PURPOSE: Stationary Block Bootstrap for a vector time series
% ------------------------------------------------------------
% SYNTAX: Zb = stationaryBB(Z,sim,L);
% ------------------------------------------------------------
% OUTPUT: Zb : nxkz resampled time series
% ------------------------------------------------------------
% INPUT:  Z   : nxkz --> vector time series to be resampled
%         sim : 1x1  --> type of bootstrap: 
%                       1 => stationary geometric pdf
%                       2 => stationary uniform pdf
%                       3 => circular (non-random b)
%         L --> block size, depends on sim
%           sim = 1 --> L:1x1 expected block size
%           sim = 2 --> L:2x1 lower and upper limits for uniform pdf
%           sim = 3 --> L:1x1 fixed block size (non-random b)
%        If L=1 and sim=3, the standard iid bootstrap is applied
% ------------------------------------------------------------
% LIBRARY: loopBB [internal]
% ------------------------------------------------------------
% SEE ALSO: overlappingBB, seasBB
% ------------------------------------------------------------
% REFERENCES: Politis, D. and Romano, J. (1994) "The starionary 
% bootstrap", Journal of the American Statistical Association, vol. 89,
% n. 428, p. 1303-1313.
% Politis, D. and White, H (2003) "Automatic block-length
% selection for the dependent bootstrap", Dept. of Mathematics, Univ.
% of California, San Diego, Working Paper.
% ------------------------------------------------------------

% written by:
%  Enrique M. Quilis
%  Macroeconomic Research Department
%  Fiscal Authority for Fiscal Responsibility (AIReF)
%  <enrique.quilis@airef.es>

% Version 2.1 [October 2015]

% Dimension of time series to be bootstrapped
[n,kz] = size(Z);

% ------------------------------------------------------------
%  ALLOCATION
% ------------------------------------------------------------
I = zeros(1,n);
b = zeros(1,n);
xb = -999.99*ones(n,1);

% ------------------------------------------------------------
% WRAPPING THE TIME SERIES AROUND THE CIRCLE
% ------------------------------------------------------------
Z = [Z; Z(1:n-1,:)];

% ------------------------------------------------------------
% INDEXES to Starting of blocks
% ------------------------------------------------------------
I = round(1+(n-1)*rand(1,n));

% ------------------------------------------------------------
% BLOCK sizes 
% ------------------------------------------------------------
switch sim
case 1 % Stationary BB, geometric pdf
   b = geornd(1/L(1),1,n);
case 2 % Stationary BB, uniform pdf   
   b = round(L(1)+(L(2)-1)*rand(1,n));
case 3 % Circular bootstrap (fixed block size)
   b = L(1) * ones(1,n);
end

% ------------------------------------------------------------
% BOOTSTRAP REPLICATION
% ------------------------------------------------------------
Zb = [];
for j=1:kz
   Zb = [Zb loopBB(Z(:,j),n,b,I)];
end
end

% ============================================================
% loopBB ==> UNIVARIATE BOOTSTRAP LOOP
% ============================================================
function xb = loopBB(x,n,b,I);

h=1;
for m=1:n
   for j=1:b(m)
      xb(h) = x(I(m)+j-1);
      h = h + 1; 
      if (h == n+1); break; end;
   end
   if (h == n+1); break; end;
end

xb=xb';
end