function [dy] = myfun(t,y,mass,gamma)
% ODE for simulating a satelite

dy(1:6,:) = y(7:12,:);

r(:,1) = y(1:2);
r(:,2) = y(3:4);
r(:,3) = y(5:6);


for n = 1:3
    for m = 1:3
        if n ~= m
            [fx(n,m),fy(n,m)] = grav_force(r(:,n),r(:,m),mass(n),mass(m),gamma);
        end
    end   
end

dy(7) = (fx(1,2) + fx(1,3))/mass(1);
dy(8) = (fy(1,2) + fy(1,3))/mass(1);

dy(9) = (fx(2,1) + fx(2,3))/mass(2);
dy(10) = (fy(2,1) + fy(2,3))/mass(2);

dy(11) = (fx(3,1) + fx(3,2))/mass(3);
dy(12) = (fy(3,1) + fy(3,2))/mass(3);





