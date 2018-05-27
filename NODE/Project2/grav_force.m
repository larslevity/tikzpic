function [fx,fy] = grav_force(r1,r2,m1,m2,gamma)
% Function calculates the resulting gravity force between two masspoints
% with the position vectors r1 and r2 and the masses m1 and m2.

f12 = gamma*m1*m2/(norm(r2-r1))^3*(r2-r1);

ex = [1;0];
ey = [0;1];

fx = f12'*ex;
fy = f12'*ey;


