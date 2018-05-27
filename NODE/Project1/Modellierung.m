% Modellierung
clear all   % clear the whole workspace
clc         % Clear the command line

% Population Constant:
a = 0.4055;
% Uper bound
b = 250;


% Time interval
t_start = 2011;     % The simulation starts at
t_end = 2025;       % The simulation ends at

% Initial value
w_0 = 20;           % 

% Modell function
dw1 = @(t,w) (a*w)*(1-w/b);
dw2 = @(t,w) (a*w);
dw3 = @(t,w) 1-w/b;




tic % start measuring the time
% Solving with the simple Euler Method, without controling the step size
[t1,w1] = euler_sim(dw1,t_start,t_end,w_0,0.5);
timer(1) = toc; % end measuring
entry(1) = cellstr('Simple Euler');


tic % start measuring the time
% Solving with the advanced Euler method, controlling the step size
[t2,w2] = euler(dw1,t_start, t_end,w_0);
timer(2) = toc; % end measuring
entry(2) = cellstr('Advanced Euler');

tic % start measuring the time
% Solving with the Runge-Kutta method. Dont know really whats going on
% there
[t3,w3] = ode45(dw1,[t_start, t_end],w_0);
timer(3) = toc; % end measuring
entry(3) = cellstr('Runge-Kutta (ode45)');





% Post Processing
l(1)=length(t1);
l(2)=length(t2);
l(3)=length(t3);
legendentries = {};
for i = 1:3
    legendentries(i) = cellstr(sprintf(' %s -- proc. time: %.3f [sec] -- supporting points: %d',char(entry(i)),timer(i),l(i)));
end

error = [w3(end)-w1(end),w3(end)-w2(end)];


% Formatted output.
plot(t1,w1,'b-x',t2,w2,'r-o',t3,w3,'g*-');
legend(legendentries,'Location','southeast')
xlabel('time in [years]')
ylabel('population size in [1]')
title('Expected Behaviour of the wolf population in Luneburg Heath')
grid
%matlab2tikz('OdeSolved.tex','width','.8\textwidth')




