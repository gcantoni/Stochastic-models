function [A,B,C,D,Mean0,Cov0,StateType] = tVarPar(params,x)
% parameter mapping for model:
%
% alfa(t) = A1 alfa(t-1) + B1 u(t) 
% beta(t) = A2 beta(t-1) + B2 u(t) 
% y(t) = alfa(t) + beta(t) x(t) + D e(t)
%
% A=I2, 
% D=1
% C(t) = x(t)=pressione
% params = log(B)

A = eye(2);
B = sqrt(exp(params(1:2))); % Positive variance constraints
B=B(:);
D = 1; %sqrt(exp(params(2))); % Positive variance constraints
n = length(x);

Mean0 = [0;0];
Cov0 = eye(2)*10^10;

StateType = []; %[0 0 0 0];
A = repmat({A},n,1);
B = repmat({B},n,1);
C = num2cell([ones(n,1),x],2);
D = repmat({D},n,1);
end