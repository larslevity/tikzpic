% Numerik gewoehnlicher Differentialgleichungen SoSe 2015
% Projekt 3 (Chemische Reaktion von H2 und O2)
% Autor: Lars Schott, 31.05.2015, R2015a
% Abgabe zum 17.06.2015
%
% Die Konzentrationen der an der Knallgasreaktion beteiligten Stoffe wird
% über die Zeit berechnet und aufgetragen. Vereinfachend wird angenommen,
% dass die Konzentrationen linear voneinander abhängen
% (Proportionalitätskoeffizient ist die Reaktionsgeschwindigkeit).

close all;
clear all;


%-------------------------------------------------------------------------
% Einstellbare Variablen
%-------------------------------------------------------------------------

% Anfangskonzentrationen
cH2 = 100;
cHP = 0;
cO2 = 50;
cPOP = 0;
cPOH = 0;
cH2O = 0;

% Zeit
t0 = 0;     % Anfangszeit
tend = 100; % Endzeit
dt = 0.0001;  % Zeitschritt
tol = 0.001;  % Toleranzwert des lokalen Fehlers (Schrittweitensteuerung)


%-------------------------------------------------------------------------
% Hilfsvariablen
%-------------------------------------------------------------------------

% Stützpunkte
NumPoints = (tend-t0)/dt;
Points = linspace(t0,tend,NumPoints);

% Anfangsbedingung/-konzentration
y0 = [cH2, cHP, cO2, cPOP, cPOH, cH2O];


%-------------------------------------------------------------------------
% Numerische Verfahren
%-------------------------------------------------------------------------

% % oder45
% tic
% [X,Y]=ode45('diffgl',Points,y0);
% t0ode45=toc;
% tode45 = ['ode45 ', num2str(t0ode45),' s'];
tode45 = 'ode45 - s';

% ode15s
tic
[X1,Y1]=ode15s('diffgl',Points,y0);
t0ode15s=toc;
tode15s = ['ode15s ', num2str(t0ode15s),' s'];

% oder23s
tic
% [X2,Y2]=adamsmoulton('diffgl',Points,y0);
[X2,Y2]=adamsbashforth('diffgl',Points,y0);
% [X2,Y2]=ode23s('diffgl',Points,y0);
t0ode23s=toc;
tode23s = ['ode23s ', num2str(t0ode23s),' s'];

% oder23t
tic
[X3,Y3]=ode23t('diffgl',Points,y0);
t0ode23t=toc;
tode23t = ['ode23t ', num2str(t0ode23t),' s'];

% oder23tb
tic
[X4,Y4]=ode23tb('diffgl',Points,y0);
t0ode23tb=toc;
tode23tb = ['ode23tb ', num2str(t0ode23tb),' s'];

% Rechenzeiten pro Verfahren (für Plot)
time = ['Rechenzeit\n',tode45,'\n',tode15s,'\n',tode23s,'\n',tode23t,...
        '\n',tode23tb];


%-------------------------------------------------------------------------
% Ausgabe des Graphen
%-------------------------------------------------------------------------

X = X2;
Y = Y2;
% Plot
hold on
plot(X(),Y(:,1),'k')     % H2
plot(X(),Y(:,3),'b')     % O2
plot(X(),Y(:,6),'r')     % H2O
plot(X(),Y(:,2),'--k')     % HP
plot(X(),Y(:,4),'--b')     % POP
plot(X(),Y(:,5),'--r')     % POH

% Beschriftung und Formatierung
legend('H_2','O_2','H_2O','H\cdot','\cdotO\cdot','\cdotOH');
annotation('textbox',[.15,.7,.5,.22],'LineStyle','none','String',...
    sprintf(time));
xlabel('Zeit')
ylabel('Konzentration')
% axis([t0 tend 0 100])
grid on