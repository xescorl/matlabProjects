%% Código para multiplexar las señales Figura 1:

n=0:length(x)-1; % Se define la variable temporal t 
t=n'/Fs;


f1 =    5000      ;         % Frec. f1 diseñada en estudio previo a)
xm=x.*cos(2*pi*f1*t);       % Modulacion x(t) para generar xm(t) 
GrafTrFourier(xm,Fs,'r')    % Dibuja el módulo de la TF en rojo
hold on                     % Fija la grafica para poder sobreponer la siguiente


f2=   15000  ;               % Frec. F2 diseñada en estudio previo a)
ym=y.*sin(2*pi*f1*t);       % Modulacion y(t) para generar ym(t)
GrafTrFourier(ym,Fs,'g')    % Dibuja el módulo de la TF en verde
hold off                    % Orden para no sobreponer más graficas 
title('senyales multiplexadas')

sm=xm+ym;                   % Suma las señales sm(t)=xm(t)+ym(t)
sound(10*sm,Fs)             % Reproduce el audio (auriculares)







