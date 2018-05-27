function [x,y] = euler_sim(f,x0,b,y0,h0)
% Eulersches Polygonzugverfahren
% [x,y] = euler(f,x0,b,y0,h0)
% y     --> Solution for y
% f     --> right Hand side of ode
% y0    --> initial value of y at position x0
% x0    --> analog
% x0,b  --> intervall for solution
% h0    --> step size

% First part of solution and initializing
y(1) = y0;
x(1) = x0;
dy(1) = f(x0,y0);


% Taylor series expansion around the point a:

% f(x)|a = f(a) + f'(a)*(x-a) + 1/2*f''(a)*(x-a)^2 + 1/6*f'''(a)*(x-a)^3 +
% ... + 1/inf*f^(inf)(a)*(x-a)^inf .
% Linearized:
% f(x)|a = f(a) + f'(a)*(x-a)
% Discretized:
% f(n+1) = f(n) + f'(n)*(x(n+1)-x(n))
% f(n+1) = f(n) + f'(n)*(stepsize)


n = 1;
while (x(n)+h0-x0) <= (b-x0) % while the working point is in the solution interval
        x(n+1) = x(n)+h0;   % create new entry in x vec
        y(n+1) = y(n)+h0*dy(n); % create new entry in y vec with respect to the linearized taylor expansion
        dy(n+1) = f(x(n),y(n)); % create new value in dy - right hand side of ode -> f'
        n = n+1;        % increase index
end