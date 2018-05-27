function y = myfun1(t,w)

% Population Constant:
a = 0.4055;
% Uper bound
b = 250;


% Initial value
w_0 = 20;           % 

% Modell function
y = (a*w)*(1-w/b);