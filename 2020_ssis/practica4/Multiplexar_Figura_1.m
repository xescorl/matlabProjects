%% C�digo para multiplexar las se�ales Figura 1:

n=0:length(x)-1; % Se define la variable temporal t 
t=n'/Fs;


f1 =    5000      ;         % Frec. f1 dise�ada en estudio previo a)
xm=x.*cos(2*pi*f1*t);       % Modulacion x(t) para generar xm(t) 
GrafTrFourier(xm,Fs,'r')    % Dibuja el m�dulo de la TF en rojo
hold on                     % Fija la grafica para poder sobreponer la siguiente


f2=   15000  ;               % Frec. F2 dise�ada en estudio previo a)
ym=y.*sin(2*pi*f1*t);       % Modulacion y(t) para generar ym(t)
GrafTrFourier(ym,Fs,'g')    % Dibuja el m�dulo de la TF en verde
hold off                    % Orden para no sobreponer m�s graficas 
title('senyales multiplexadas')

sm=xm+ym;                   % Suma las se�ales sm(t)=xm(t)+ym(t)
sound(10*sm,Fs)             % Reproduce el audio (auriculares)







