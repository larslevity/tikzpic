% Test

% rechte Seite definieren:
%f =@(x,y)  y^(1/3); % Aufgabe 2
f = @(x,y) -5*y+exp(-x); % Aufgabe 3
y0 = 5/4;
x0 = 0;
a = 6;
h = .1;


[x,y,dy] = euler(f,y0,x0,a,h);

figure(1)
clf
plot(x,y,'r.-');
hold on
%plot(x,dy,'b-*');

%plot(x,2/3*x.^(3/2),'y') % Aufgabe 2 analy. Lsg
plot(x,exp(-5*x)+1/4*exp(-x),'y') % Aufgabe 3 analy. Lsg