function [t, y, nsteps,long] = AdamsMoulton(ode,tspan,y0,h,k,tol)
% Adams-Moulton- Coeffs
A =[1 -1;...
    1 -1;...
    1 -1;...
    1 -1;...
    1 -1];

BAMo = [1/2        1/2         0           0           0           0;...
        -1/12      8/12        3/12        0           0           0;...
        1/24       -5/24       19/24       9/24        0           0;...
        -19/720    106/720     -264/720    646/720     251/720     0;...
        27/1440    -173/1440   482/1440    -798/1440   1427/1440   475/1440];


 
 %%
 fe = 0;
 b = BAMo(k,1:k+1);
 hhat = 1e-2;
 long = false;
 y(1:k,:) = y0;
 t(1:k,1) = tspan(1):h:(tspan(1)+(k-1)*h);
 n = 1;
 N = length(y(1,:));
 % initialising of function evaluation
 f = zeros(k,length(y0));
 for j = 0:k-1
     yt = y(j+1,:)';
     f(j+1,:) = ode(t(j+1),yt)';
     fe = fe+1;
 end
 % Mehrschritt-Verfahren Loop:
 while (n+k-1)*h <= tspan(end)
     % Newton-Verfahren Init:
     yi = zeros(1:N);
     yi = y(n+k-1,:);
     yl = yi;
     i = 1;
     F = Ff(yi,yl,t(n+k-1),b,f,ode,k,h);
     fe = fe+1;
     while norm(F) > tol
        JF = zeros(N,N);
        for m = 1:N
            dh = zeros(1,N);
            dh(m) = 1*hhat; 
            dF = Ff(yi(i,:)+dh,yl,t(n+k-1),b,f,ode,k,h);
            fe = fe+1;
            JF(:,m) = (dF-F)/hhat;  
        end
        JFinvF = JF\F;
        yi(i+1,:) = yi(i,:) - JFinvF'; 
        i = i+1;
        F = Ff(yi(i,:),yl,t(n+k-1),b,f,ode,k,h);
        fe = fe+1;
        if i > 20
            long = true;
            break
        end
     end
     nsteps(n) = i-1;
     % Wert aus Newton Iteration in Lsg schreiben:
     y(n+k,:) = yi(i,:);     
     t(n+k) = t(n+k-1) + h;
     % aktualisieren des function evaluation storage
     f(1:k-1,:) = f(2:k,:);
     f(k,:) = ode(t(j+1),y(n+k,:)')'; 
     fe = fe+1;
     % Index erhöhen
     n = n+1;
     if long
         fprintf('Newton method does not convergate \nAdams Moulton method FAILED.\n')
         break
     end
 end
 if ~long
 fprintf('%d \t\t function evaluations \n', fe)
 fprintf('%d \t\t\t maximal number of newton steps \n', max(nsteps))
 fprintf('%.4f \t\t average number of newton steps \n', mean(nsteps))
 end
 
end

function F = Ff(yi,yl,t,b,f,ode,k,h)
    F = yi' - yl' - h*((b(1:k)*f)'+b(k+1)*ode(t,yi));
end