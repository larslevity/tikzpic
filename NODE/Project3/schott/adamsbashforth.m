function [ t,Y ] = adamsbashforth( diffgl,Points,y0 )
% k-Schritt Adams-Bashforth-Verfahren (explizites Merhschrittverfahren)

% Parameter bis zu einem 5-Schritt-Verfahren
b = [1      0       0       0       0;
     -0.5   1.5     0       0       0;
     5/12   -16/12  23/12   0       0;
     -9/24  37/24   -59/24  55/24   0;
     251/720    -1274/720   2416/720    -2774/720   1901/720];
% Einstellung für ein 1- bis 5-Schrittverfahren
k = 1;
% Matrix mit Funktionsauswertungen der vorherigen Schritte
evdiffgl = zeros(k,length(y0));
% Schrittweite
h = Points(2)-Points(1);
% Zeitschrittvektor
t = zeros(length(Points),1);
t(1) = Points(1);
% Ausgabevektor
Y = zeros(length(Points),length(y0));
% Anfangswerte
Y(1,:) = y0;
% Schleifen-Laufvariable
i=1;
% Berechnung der ersten k Schritte (ebenfalls nach Adams-Bashforth)
while k>i
    % Nutzung der vorhergegangenen Funktionsauswertungen
    for j=1:1:length(evdiffgl(:,1))-1
        evdiffgl(j,:) = evdiffgl(j+1,:);
    end
    % Funktionsauswertung für aktuellen Schritt
    evdiffgl(length(evdiffgl(:,1)),:) = feval(diffgl,t(i),Y(i,:))';
    % Berechnung des nächsten Wertes
    Y(i+1,:) = Y(i,:) + h.*( b(i,1:i)*evdiffgl(length(evdiffgl(:,1))-i+1:length(evdiffgl(:,1)),:) );
    % Eintragung des nächsten Schrittes
    t(i+1) = h+t(i);
    % Nächste Schleifenvariable
    i = i+1;
end
% Zurücksetzen der Schleifen-Laufvariable
i=1;
% Berechnung mit nun k berücksichtigten Schritten
while i<length(Points)-k+1
    % Nutzung der vorhergegangenen Funktionsauswertungen
    for j=1:1:length(evdiffgl(:,1))-1
        evdiffgl(j,:) = evdiffgl(j+1,:);
    end
    % Funktionsauswertung für aktuellen Schritt
    evdiffgl(length(evdiffgl(:,1)),:) = feval(diffgl,t(i+k-1),Y(i+k-1,:))';
    % Berechnung des nächsten Wertes
    Y(i+k,:) = Y(i+k-1,:) + h.*( b(k,1:k)*evdiffgl(length(evdiffgl(:,1))-k+1:length(evdiffgl(:,1)),:) );
    % Eintragung des nächsten Schrittes
    t(i+k) = h+t(i+k-1);
    % Nächste Schleifenvariable
    i = i+1;
end

end