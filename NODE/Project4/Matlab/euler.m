function [x,y] = euler(f,x0,b,y0,varargin)
% Eulersches Polygonzugverfahren mit Schrittweitensteuerung
% [x,y] = euler(f,x0,b,y0,varargin)
% y     --> Solution for y
% f     --> right Hand side of ode
% y0    --> initial value of y at position x0
% x0    --> analog
% x0,b  --> intervall for solution
% varargin --> tolerance for error [default: tol=1e-2]

% initializing
y(1) = y0;
x(1) = x0;
h(1) = .5; % initial step size

% Tolerance:
if ~isempty(varargin) 
    tol = varargin{1};  % costumized tolerance
else
    tol = 1e-2;         % default tolerance
end

n = 1;
htmp = h(1);
while htmp>0 
    % calculate the next value of y like the simple euler method: ->y(n+1)
    y1 = y(n) + htmp*f(x(n),y(n)); 
    % calculate the value of y with half the step size: -> y(n+1/2)
    y2 = y(n) + htmp/2*f(x(n),y(n));
    % now calculate again with half the step size: -> y(n+1/2+1/2) = y(n+1)
    y2 = y2 + htmp/2*f(x(n)+htmp/2,y2);
    % Check the diffrence between the solutions: -> thats a indicator of error
    phi = 2*norm(y2-y1);
    % calculate the new step size with respect to htmp, tol, phi(error)
    hnew = htmp*min(max(.9*sqrt(tol/phi),.2),10);
    
    % If the error is greater than the tolerance:
    if phi > tol
        htmp = hnew;    % Reduce step size and start again
        
    % If the error is lower than the tolerance:
    else
        h(n) = htmp;    % store the temporal step size in h vec
        x(n+1) = x(n)+h(n); % calculate the next entry of x vec
        y(n+1) = 2*y2-y1;   % calc next entry of y. Since y2 \approx y1 -> 2*y2-y1 approx y
        htmp = min(b-x(n+1),hnew);  % store next step size: -> wheter hnew or the difference to the end of interval
        n = n+1;            % increase index
    end
end