% Simulation

clear 
close all
clc

tspan = [0 1.5];
% y0 = [0 1 11.8 6.7]; %geraten
ya = [0 1];
yb = [14 0];

options = odeset('Stats','on','RelTol',1e-4);

fprintf('RANDNewton: \n')
tic
[veloN] = RANDNewton(@(x,y) myfun(x,y), tspan, ya, yb, options);
ctN = toc;
fprintf('%.2d\t\t computational time\n', ctN)

fprintf('\nRANDBroyden: \n')
tic
[veloB] = RANDBroyden(@(x,y) myfun(x,y), tspan, ya, yb, options);
ctB = toc;
fprintf('%.2d\t\t computational time\n', ctB)
err = norm(veloN - veloB);
fprintf('%.2d\t\t difference between solutions\n', err)


velo = veloB;
y0 = [ya velo];
fprintf('\nDOPRI5: \n')
tic
[t,y] = DOPRI5(@(x,y) myfun(x,y), tspan, y0,options);
toc



%% PLOTTing

y1 = y(:,1);
y2 = y(:,2);
y3 = y(:,3);
y4 = y(:,4);
figure(2)
plot(t,y3);
hold on
grid on
plot(t,y4);


figure(1)
clf 
for i = 1:length(t)
    plot(y1(i),y2(i),'o','MarkerSize',12,'MarkerFaceColor','y')
    hold on
    c = 1e-1;
    tang = [y1(i)       y2(i);...
            y1(i)+c*y3(i) y2(i)+c*y4(i)];
    plot(tang(:,1),tang(:,2))
    
    plot(y1,y2,'k*:')
    
    axis equal
    grid on
    title(sprintf('Time: %.2f',t(i)))
    hold off
    drawnow;
end
hold on
c = .5;
tang = [y1(1)       y2(1);...
        y1(1)+c*y3(1) y2(1)+c*y4(1)];
plot(tang(:,1),tang(:,2))
text(y1(1)+c*y3(1),y2(1)+c*y4(1),sprintf(' \\eta: [%.1f, %.1f]',velo(1),velo(2)));
% 
% filename = sprintf('Solution_x%.0d_y%.0d.tex',yb(1),yb(2));
% matlab2tikz('filename',filename,'height','4.5cm','width','5.9cm',...
%         'extraAxisOptions','axis x line* = middle, axis y line* = middle,','standalone',true);
% 
