function [x, y, fevals] = DOPRI5(odefun,tspan,y0,options)


% Check inputs
if nargin < 4
  options = [];
  rtol = 1e-3;
  if nargin < 3
        error(('DOPRI5:  NotEnoughInputs'));
  end
end

if ~isempty(odeget(options,'RelTol'))
    rtol = odeget(options,'RelTol');
end
if ~isempty(odeget(options,'Stats'))
    stats_str = odeget(options,'Stats');
    if stats_str == 'on'
        stats = true;
    end
else
    stats = false;
end



% Butcher Tablet:
a = [0 1/5 3/10 4/5 8/9 1 1];
B = [0          0           0           0           0           0           0;...
     1/5        0           0           0           0           0           0;...
     3/40       9/40        0           0           0           0           0;...
     44/45      -56/15      32/9        0           0           0           0;...
     19372/6564 -25360/2187 64448/6561  -212/729    0           0           0;...
     9017/3168  -355/33     46732/5247  49/176      -5103/18656 0           0;...
     35/384     0           500/1113    125/192     -2187/6784  11/84       0];
 c = [35/384     0           500/1113    125/192     -2187/6784  11/84       0];
 chat = [5179/57600 0   7571/16695  393/640 -92097/339200   187/2100    1/40];



% initializing
hmin = eps(tspan(1)); % lets begin with the maximum of computer accuracy for the step size
y(1,:) = y0; % Put the initial condition in solution vec
x(1) = tspan(1); % Same with the time vec
h(1) = hmin; % initial step size
fevals = 0; % for statistical purpose
break_dec = false; % Kind of safety thing. 
failed_attempts = 0; % this is also for stats ... (copy from ode45..)
htmp = h(1); % initializing the temporay step size
N = length(y0); % Looking for the dimension of the Problem



n_break_dec = 0; % counter for the break decision
n = 1; % classic counter.
while htmp>0 % as long we are not finish :)

    % init k
    k = zeros(7,N); 
    % this if quest is for the so called FILA - efficiency tune. First in = Lats out. But if n==1 we dont know the last.
    if n == 1
    start = 1; 
    else
        k(1,:) = k1;
        start = 2;
    end
    for i=start:7
        k(i,:) = odefun(x(n)+a(i)*htmp, y(n,:) + htmp*B(i,:)*k);
        fevals = fevals + 1;
    end
    k1 = k(7,:); % save the last entry.. 
    
    y1 = y(n,:) + htmp*c*k; % calc the 5th order solution
    y2 = y(n,:) + htmp*chat*k;  % calc the 4th order solution for err estimator
    
    % Check the diffrence between the solutions: -> thats an indicator of error
    err = norm((y1-y2));
    % calculate the new step size with respect to htmp, tol, (error)
    hnew = max(hmin, htmp * max(0.1, 0.8*(rtol/err)^(1/5))); % this is copied from ode45
    
    
    % If the error is greater than the tolerance:
    if err > rtol
        htmp = hnew;    % Reduce step size and start again
        n_break_dec = n_break_dec + 1;
        failed_attempts = failed_attempts + 1;
        if n_break_dec > 15 % to avoid an infinite loop.
            break_dec = true;
            break;
        end

        
    % If the error is lower than the tolerance:
    else
        n_break_dec = 0;
        h(n) = htmp;    % store the temporal step size in h vec
        x(n+1) = x(n)+h(n); % calculate the next entry of x vec
        y(n+1,:) = y1;   % calc next entry of y. Since y2 \approx y1 -> 2*y2-y1 approx y
        htmp = min(tspan(end)-x(n+1),hnew);  % store next step size: -> wheter hnew or the difference to the end of interval
        n = n+1;            % increase index
    end
    
    
end

% Some stats:
if ~break_dec
    if stats
        fprintf('%d \t\t successful steps \n', n)
        fprintf('%d \t\t failed attempts \n', failed_attempts)
        fprintf('%d \t\t function evaluations \n \n', fevals)
    end
else
    fprintf('DOPRI5 failed')
end

end

