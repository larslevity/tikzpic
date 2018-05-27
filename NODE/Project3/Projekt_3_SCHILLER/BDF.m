
function [t,y,nsteps,long] = BDF(ode,tspan,y0,h,k,tol)

% BDF Coefficients
ABDF = [-1     1       0       0       0       0       0;...
     1/2    -2      3/2     0       0       0       0;...
     -1/3   3/2     -3      11/6    0       0       0;...
     1/4    -4/3    3       -4      25/12   0       0;...
     -1/5   5/4     -10/3   5       -5      137/60  0;...
     1/6    -6/5    15/4    -20/3   15/2    -6      49/20];
 

 h0 = h;
 a = ABDF(k,1:k+1);
 long = false;
 
 y(1:k,:) = y0;
 t(1:k,1) = tspan(1):h:(tspan(1)+(k-1)*h);
 n = 1;
 N = length(y0);
 
 fe = 0;
 hhat = 1e-2;
    
    

htemp = h0; 

  while (n+k-1)*htemp <= tspan(end)
     % Newton Verfahren:
     yi = zeros(1,N);
     yi(1,:) = y(n+k-1,:);
     yk = yi;
     i = 1;
     htemp = h0;
     F = Ff(yi(i,:),y,n,k,ode,a,htemp,t);
     fe = fe + 1;

     while norm(F) > tol %|| any(yk <= 0)
        JF = zeros(N,N);
        Fs = F;
        for m = 1:N
            dh = zeros(1,N);
            dh(m) = 1*hhat; 
            dF = Ff(yi(i,:)+dh,y,n,k,ode,a,h,t);
            fe = fe + 1;
            JF(:,m) = (dF-Fs)/hhat;  
        end
        JFinvF = (JF\F)';
        yk = yi(i,:) - JFinvF; 
        yi(i+1,:) = yk;
        F = Ff(yi(i+1,:),y,n,k,ode,a,htemp,t);
        fe = fe + 1;
        i = i+1;
        if i >20
            long = true;
        end
     end
     nsteps(n) = i-1;
     y(n+k,:) = yk;  
     t(n+k) = t(n+k-1) + htemp;
     n = n+1;
     if long
        fprintf('Newton method does not convergate \nBDF method FAILED.\n')
        break
     end
  end
  if ~long
  fprintf('%d \t\t function evaluations \n', fe)
  fprintf('%d \t\t\t maximal number of newton steps \n', max(nsteps))
  fprintf('%.4f \t\t average number of newton steps \n', mean(nsteps))
  end
end


function F = Ff(yi,y,n,k,ode,a,h,t)
        yrel = y(n:n+k-1,:);
        X = (a(1:k)*yrel+a(k+1)*yi)';
        F = X - h*ode(t,yi);
end