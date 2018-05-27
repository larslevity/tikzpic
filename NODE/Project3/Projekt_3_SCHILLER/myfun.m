function [dc] = myfun(t,c)
% ODE for simulating a satelite

% 1 - H2
% 2 - O2
% 3 - H.
% 4 - .OH
% 5 - .O.
% 6 - H2O

dc = zeros(6,1);
% Reaktionsgeschwindigkeit
r1 = 1e-4;
r2 = 1e4;
r3 = 2e-2;
r4 = 1e-3;
r5 = 1e-3;
r = [r1 r2 r3 r4 r5]';

% Reaktanten:
a1 = c(1);
a2 = c(2)*c(3);
a3 = c(5)*c(1);
a4 = c(4)*c(1);
a5 = c(3)*c(4);
a = [a1 a2 a3 a4 a5]';
ar = a.*r;

% Guess who is taking part in what reaction:
T = [-1     0       -1      -1      0;...
     0      -1      0       0       0;...
     2      -1      1       1       -1;...
     0      1       1       -1      -1;...
     0      1       -1      0       0;...
     0      0       0       1       1];

 % Finally the ODE:
dc = T*ar;

