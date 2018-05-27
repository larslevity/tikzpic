clear 
close all
clc

%% initializing
m1 = 100;
m2 = 10;
m3 = 1;
mass = [m1 m2 m3];
gamma = 1;


% initial valus
r1 = [0;0];
r2 = [20;0];
r3 = [20;-2];
v1 = [-.02;-.22];
v2 = [0;2];
v3 = [2.1;2.1];
% initial state vec
x0 = [r1;r2;r3;v1;v2;v3];


%% Do the simulation
tol = 1e-3;
tols = '1e-3';
options = odeset('RelTol',tol,'stats','on');

%disp('ode45:')
%[t45,y45] = ode45(@(t,y) myfun(t,y,mass,gamma),[0,300],x0,options);
[te,ye] = euler(@(t,y) myfun(t,y,mass,gamma),0,100,x0,1e-3);
%disp('ode113:')
%[t113,y113] = ode113(@(t,y) myfun(t,y,mass,gamma),[0,100],x0,options);
%disp('ode15s:')
%[t15s,y15s] = ode15s(@(t,y) myfun(t,y,mass,gamma),[0,100],x0,options);




%% Plot the Results

fun = {'45','e','113','15s'};
for nfun = 2:2
    % temp working data
    eval(sprintf('y = y%s;',fun{nfun}));
    eval(sprintf('t = t%s;',fun{nfun}));
    % Thinning of the data
    N = 600;% number of query points
    if length(t) > N % if necesarry
        tn = zeros(N,1);
        yn = zeros(N,12);
        for i = 1:N;
            n = floor(length(t)/N*i);
            if n < length(t);
                tn(i) = t(n);
                yn(i,:) = y(n,:);
            else
                tn(i) = t(end);
                yn(i,:) = y(end,:);
            end
        end
        t = tn;
        y = yn;
    end
    % Postprocess
    xS = y(:,1);
    yS = y(:,2);
    xE = y(:,3);
    yE = y(:,4);
    xSat = y(:,5);
    ySat = y(:,6);
    % Plotting
    figure('Name',sprintf('Results: ode%s',fun{nfun})); 
    axis manual
    scaler = 1;
    shade_length = length(t)/5;

    b = 1.5;
    begin_shade = 0;
    start = min(find(round(t)==begin_shade));
    lookat=40;
    for i = max(find(round(t)==lookat)):max(find(round(t)==lookat))
    %for i = 1:scaler:length(t)
        clf
        hold on
        grid on
        title(sprintf('Time: %.1f',t(i)))
        % Plot trajectories
        if i > shade_length
            s = floor(shade_length);
            plot(xS(start:scaler:i-s),yS(start:scaler:i-s),':','Color',[.5 .5 .5]);
            plot(xE(start:scaler:i-s),yE(start:scaler:i-s),':','Color',[.5 .5 1]);
            plot(xSat(start:scaler:i-s),ySat(start:scaler:i-s),':','Color',[1 .5 .5]);
        end
        % Plot Current position
        plot(xS(i),yS(i),'Marker','O','MarkerSize',20,'MarkerEdgeColor','k',...
            'MarkerFaceColor','y');
        plot(xE(i),yE(i),'kO','MarkerSize',8,'MarkerFaceColor','b');
        plot(xSat(i),ySat(i),'kO','MarkerSize',5,'MarkerFaceColor','r');
        % Plot fading shade
            for bright = 1:shade_length
                if bright+2 < i && i > 10*scaler
                    bb = round(bright/shade_length/b*10)/10;
                    plot(xS(i-bright),yS(i-bright),'o','MarkerSize',1,...
                        'Color',[bb bb bb]);
                    plot(xE(i-bright),yE(i-bright),'o','MarkerSize',1,...
                        'Color',[bb bb 1]);
                    plot(xSat(i-bright),ySat(i-bright),'o','MarkerSize',1,...
                        'Color',[1 bb bb]);
                end
            end
        %axis([-15 22 -18 20])
        axis equal
        axis tight
        drawnow
        hold off
    end
    %MATLAB2TIKZ('extraAxisOptions',CHAR or CELLCHAR,...) explicitly adds extra
    %   options to the Pgfplots axis environment. (default: [])
    filename = sprintf('sol_ode%s_40_%s.tex',fun{nfun},tols);
    matlab2tikz('filename',filename,'height','4.5cm','width','5.9cm',...
        'extraAxisOptions','axis x line* = middle, axis y line = middle,','standalone',true);

end

