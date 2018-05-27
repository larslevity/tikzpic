function [ f ] = diffgl( ~,x )
% Reaktionsgleichung der Knallgasreaktion
%
% x(1) -> H2
% x(2) -> HP
% x(3) -> O2
% x(4) -> POP
% x(5) -> POH
% x(6) -> H2O
%
% Reaktionsgeschwindigkeiten
k1 = 10^(-4);
k2 = 10^4;
k3 = 2*10^(-2);
k4 = 10^(-3);
k5 = 10^(-3);

% Reaktionsgleichungen
f = zeros(6,1);
f(1,1) = -k1*x(1)-k3*x(4)*x(1)-k4*x(5)*x(1);
f(2,1) = -k2*x(2)*x(3)-k5*x(2)*x(5)+2*k1*x(1)+k3*x(4)*x(1)+k4*x(5)*x(1);
f(3,1) = -k2*x(2)*x(3);
f(4,1) = -k3*x(4)*x(1)+k2*x(2)*x(3);
f(5,1) = -k4*x(5)*x(1)-k5*x(2)*x(5)+k2*x(2)*x(3)+k3*x(4)*x(1);
f(6,1) = k4*x(5)*x(1)+k5*x(2)*x(5);
end