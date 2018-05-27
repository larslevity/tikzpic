function [params] = RANDNewton(odefun,tspan,ya,yb,options)
    % Stats:
    global nfeval
    nfeval = 0;
    
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

    % Extract the bounds:
    a = tspan(1);
    b = tspan(end);
    
    % Guess som initial value for eta
    eta(1,:) = yb-ya;
    
    % calc the first residual.
    Fn = Fcalc(odefun,a,b,eta,ya,yb,rtol);
    
    % Init counter
    n = 1;
    while norm(Fn) > rtol % while the residual fun is greater than the tolerance ...
        JFn = JFcalc(odefun,a,b,eta(n,:),ya,yb,rtol,Fn); % calc Jacobian..
        eta(n+1,:) = eta(n,:) - (JFn\Fn)'; % calc new eta..
        Fn = Fcalc(odefun,a,b,eta(n+1,:),ya,yb,rtol); % calc new Residual fun...
        n = n+1; % inrease counter... bla bla
    end
    params = eta(end,:); % Found the solution ... yeah
    
    % Wanna stats?
    if stats
        fprintf('%.2e \t\t newton steps \n', n-1)
        fprintf('%.2e \t\t overall function evaluations to find start params \n', nfeval)
    end
end

    
    
%% Residual function
function F = Fcalc(odefun,a,b,eta,ya,yb,rtol)
    global nfeval
    optionsF = odeset('RelTol',rtol); % odeset up .. little try to be as smart as the mathwork guys..
    y0 = [ya eta]; % set up the initial value problem..
    [t,y,fevals] = DOPRI5(odefun,[a,b],y0,optionsF); % and solve it
    nfeval = nfeval + fevals; % going for the stats.
    yb_eta = y(end,1:2)'; % extract the wanted solution
    F = yb_eta - yb'; % calc the rsidual
end


%% We have to do this.. since were calculating with newton method: The Jacobian of the residual fun::
function JF = JFcalc(odefun,a,b,eta,ya,yb,rtol,Fi)
    N = length(Fi); % dim of task
    hhat = 1e-2; % random step size 
    JF = zeros(N,N); % init Jacobian
    for j = 1:N % do the following for each column of the jacobian
        e = zeros(1,N); % creat a col vec
        e(j) = 1; % set the j-th entry to the random step size hhat
        JF(:,j) = 1/hhat*(Fcalc(odefun,a,b,eta+e*hhat,ya,yb,rtol) - Fi)'; % and calc the numerical derivative with respect to yj: dF(y+hhat*ej) / dyj..
    end
end


