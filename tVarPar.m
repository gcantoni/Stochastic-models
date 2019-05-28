function [A,B,C,D,Mean0,Cov0,StateType] = tVarPar(params,x)
% parameter mapping for model:
%
% beta(t) = A beta(t-1) + B u(t) 
% y(t) = beta(t) x(t) + D e(t)
%
% A=1, 
% D=1
% C(t) = x(t)=pressione
% params = log(B)

A = 1;
B = sqrt(exp(params(1))); % Positive variance constraints
D = 1; %sqrt(exp(params(2))); % Positive variance constraints
n = length(x);

Mean0 = [0];
Cov0 = eye(1)*10^10;

StateType = []; %[0 0 0 0];
A = repmat({A},n,1);
B = repmat({B},n,1);
C = num2cell(x);
D = repmat({D},n,1);
end