function [t, y] = AdamBashforth(ode,tspan,y0,h,k)


 
 
% Adams-Bashforth - Coeffs
BABa = [1      0       0       0       0;...
     -1/2   3/2     0       0       0;...
     5/12   -16/12  23/12   0       0;...
     -9/24  37/24   -59/24  55/24   0;...
     251/720    -1274/720   2616/720    -2774/720   1901/720];
 
 
 %%
 % y_n+k = y_n+k-1 + h* sum_j=0^k b_j * f_n+j
 b = BABa(k,1:k);
 
 y(1:k,:) = y0;
 t(1:k,1) = tspan(1):h:(tspan(1)+(k-1)*h);
 n = 1;
 % initialising of function 
 f = zeros(k,length(y0));
 for j = 0:k-1
     yt = y(j+1,:)';
     f(j+1,:) = ode(t(j+1),yt)';
 end
 while (n+k)*h <= tspan(end)
     y(n+k,:) = y(n+k-1,:) + h * b*f;     
     t(n+k) = t(n+k-1) + h;
     f(1:k-1,:) = f(2:k,:);
     f(k,:) = ode(t(j+1),y(n+k,:)')'; 
     n = n+1;
 end
end