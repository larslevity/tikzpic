clear 
close all
clc


% initial valus
c0 = [ 100 50 0 0 0 0]';


%% Do the simulation
tol = 1e-4;
options = odeset('RelTol',1e-10,'stats','on');
h = .01;
k = 1;
tend=100;
fprintf('h = %.3f \t\t step size \nk = %d \t\t\t number of steps\ntol = %.0e \t Relative tolerance \n',h,k,tol)

disp(sprintf('\nODE15s:'))
tic
[t1,c1] = ode15s(@(t,c) myfun(t,c),[0:h:tend],c0,options);
toc
fprintf('\n')

disp(sprintf('\nself-implemented Adams-Moulton:'))
tic
c0A = c1(1:k,:);
[tA,cA,nstepsA,long] = AdamsMoulton(@(t,c) myfun(t,c),[0 tend],c0A,h,k,tol);
ctA = toc;
if ~long
errA = norm(c1-cA);
fprintf('%.4f \t\t computation time [sec] \n',ctA)
fprintf('%.4f \t\t norm of error \n',errA)
end

k = 5;
disp(sprintf('\nself-implemented BDF:'))
tic
c0B = c1(1:k,:);
[tB,cB,nsteps,long] = BDF(@(t,c) myfun(t,c),[0 tend],c0B,h,k,tol);
ctB = toc;
if ~long
errB = norm(c1-cB);
fprintf('%.4f \t\t computation time [sec] \n',ctB)
fprintf('%.4f \t\t norm of error \n',errB)
end

%% Plot the Results
fun = {'1','A','B'};
LineSpec = {'-','--',':'};
% tstart = 10.6;
% tend = 10.8;
% ymin = 59.8;
% ymax = 61.4;
% xmin = 10.64;
% xmax = 10.72;
figure(1)

clf
hold on
grid on
for nfun = 1:3
    % temp working data
    eval(sprintf('y = c%s;',fun{nfun}));
    eval(sprintf('t = t%s;',fun{nfun}));
    % Thinning of the data
    N = 600;% number of query points
    if length(t) > N % if necesarry
        tn = zeros(N,1);
        yn = zeros(N,6);
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
    
%     is = find(round(t*10)==tstart*10,1000,'first');
%     ie = find(round(t*10)==tend*10,1000,'last');

    %plot(t(is:ie),y(is:ie,:),LineSpec{nfun});
    plot(t,y,LineSpec{nfun});
    legend('H_2','O_2','H\cdot','\cdotOH','\cdotO\cdot','H_2O')
%    axis([xmin xmax ymin ymax])
end


for i = 1:length(t1)
   [H1(i),O1(i)] = evalConc(c1(i,:));
end
for i = 1:length(tB)
   [HB(i),OB(i)] = evalConc(cB(i,:));
end
for i = 1:length(tA)
   [HA(i),OA(i)] = evalConc(cA(i,:));
end
% figure(2)
% plot(t1,[H1' O1'],'-',tB,[HB' OB'],'--',tA,[HA' OA'],':')



% figure(3)
% plot(t,c)
% title('ode45')
% grid on


% filename = sprintf('detail2_sol_h%.0e_k%.0d.tex',h,k);
% matlab2tikz('filename',filename,'height','4.5cm','width','5.9cm',...
%         'extraAxisOptions','axis x line* = middle, axis y line = middle,','standalone',true);
