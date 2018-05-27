if ~isempty(yk(yk<=0))  % Wenn ein Eintrag <= 0 :
            yj = zeros(1,N);
            yj(1,:) = y(i,:);
            yk = yj;
            j = 1;
            jj = 1;
            ht = .8*htemp; %
            while sum(abs(dec)) > tol || any(yk <= 0)
                JFinvF = (JFf(yj(j,:),y,n,k,ode,a,ht,t,N)\Ff(yj(j,:),y,n,k,ode,a,ht,t))';
                yk = yj(j,:) - JFinvF;
                yj(j+1,:) = yk;
                dec = Ff(yj(j+1,:),y,n,k,ode,a,ht,t);
                if ~isempty(yk(yk<=0))
                    ht = ht*.9;
                    if j > 5
                        ht = htemp*1/jj;
                        yj(1,:) = yi(i,:);
                        j = 0;
                        jj = jj+1;
                    end
                else
                    ht = 1*ht;
                end
                j = j+1;
            end