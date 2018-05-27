
xd = [0,.15,.3,.6,.8,1]';
yd = [0,-.1,0,.06,.09,.1]';
n = 3;


p = polyfit(xd,yd,n)

g = fittype( @(a,b,c,x) a*x.^2+b*x+c, 'problem', 'c' );
g2 = fittype( @(a,b,c,d,e,f,x) a-(exp(b.*x)).*(c*x.^3+d*x.^2+e*x+f));
f1 = fit( xd, yd, g, 'problem', 0 );
f2 = fit( xd, yd, g2, 'StartPoint', [0.1, -4, 0, .1, 0, 0])


t = 0:0.01:1;
%Y = p(1)*t.^4 + p(2)*t.^3 + p(3)*t.^2 + p(4)*t + p(5);
YY = polyval(p,t);


figure(1)
clf
plot(t,YY)
hold on
plot(xd,yd,'o')
plot(f1,'r--')
plot(f2,'k--')