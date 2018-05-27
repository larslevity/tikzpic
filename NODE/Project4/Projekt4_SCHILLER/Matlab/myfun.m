function [dy] = myfun(x,y)

% questions ? look up in the  doc of project 4 

g = 9.81;
vw = -10;
rhoT = 408;
rhoL = 1.2250;
cw = 0.47;
r = 0.034;

m = 4/3*pi*r^3*rhoT;
k = 1/2*pi*r^2*rhoL*cw;
y4stat = sqrt(g*m/k); % static velocity in y2 dir %% rly??
absvrel = sqrt((y(3)-vw)^2+(y(4))^2);

dy = [y(3) ,... 
      y(4) ,...
      -k/m*absvrel*(y(3) - vw) ,...
      -k/m*absvrel*y(4)  - g   ];