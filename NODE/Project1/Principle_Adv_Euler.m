% Modellierung
clear all   % clear the whole workspace
clc         % Clear the command line


% Time interval
t_start = 0 ;     % The simulation starts at
t_end = 1;       % The simulation ends at

% Initial value
f_0 = 1;           % 

% Modell function
f = @(t,y) y;






% Solving with the simple Euler Method, without controling the step size
[t1,f1] = euler_sim(f,t_start,t_end,f_0,1);

% Solving with the advanced Euler method, controlling the step size
[t2,f2] = euler(f,t_start, t_end,f_0);

% Exact solution
t = t_start:.1:t_end;
f = exp(t);



% legendentries:
legendentries = {'Simple Euler', 'Advanced Euler', 'Analytical Solution'};


% Formatted output.
plot(t1,f1,'b-x',t2,f2,'r-o',t,f,'g-');
legend(legendentries,'Location','southeast')
xlabel('x')
ylabel('y(x)')
grid
%matlab2tikz('OdeSolved.tex','width','.8\textwidth')