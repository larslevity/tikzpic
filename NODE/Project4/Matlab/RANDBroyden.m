function [params] = RANDBroyden(odefun,tspan,ya,yb,options)
    % Stats:
    global nfeval % dont know if this idea is good...
    nfeval = 0; % init stat counter
    
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
    else
        rtol = 1e-3;
    end
    if ~isempty(odeget(options,'Stats'))
        stats_str = odeget(options,'Stats');
        if stats_str == 'on'
            stats = true;
        end
    else
        stats = false;
    end

    % extract the bounds
    a = tspan(1);
    b = tspan(end);
    
    
    eta(1,:) = yb-ya; % Guess some initial values for eta
    JF(:,:,1) = eye(2); % Guess some initial values for JK
    Fk(:,1) = Fcalc(odefun,a,b,eta,ya,yb,rtol); % calc residual fun
    
    % Init counter
    k = 1;
    while norm(Fk(:,k)) > rtol % while we are not finished :)
        s(k,:) = -(JF(:,:,k)\Fk(:,k))' ; % why doing this?? -> look in the script.
        eta(k+1,:) = eta(k,:) + s(k,:);
        Fk(:,k+1) = Fcalc(odefun,a,b,eta(k+1,:),ya,yb,rtol);
        JF(:,:,k+1) = JF(:,:,k) + Fk(:,k+1)*s(k,:)/(norm(s(k,:)))^2 ;
        k = k+1; 
    end
    params = eta(end,:); % we have found what were looking for!
    
    % Some stats
    if stats
        fprintf('%.2e \t\t iteration steps \n', k-1)
        fprintf('%.2e \t\t overall function evaluations to find start params \n', nfeval)
    end
end

    
    
%% This is the resudual function::
function F = Fcalc(odefun,a,b,eta,ya,yb,rtol)
    global nfeval % 
    optionsF = odeset('RelTol',rtol);
    y0 = [ya eta]; % set up the initial value problem ...
    [t,y,fevals] = DOPRI5(odefun,[a,b],y0,optionsF); % and ask DOPRI5 to solve it
    nfeval = nfeval + fevals;
    yb_eta = y(end,1:2)'; % extract the solution at t_fin
    F = yb_eta - yb'; % calc the err (the residual)
end



