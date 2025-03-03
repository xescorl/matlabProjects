%% Código para capturar las señales de voz:

    %% SENYAL 1
[x Fs]=audioread('senyal1.wav'); % Carga el fichero 'senyal1.wav'
sound(10*x,Fs) % Reproduce el audio (auriculares)
GrafTrFourier(x,Fs,'r') % Dibuja el módulo de la TF en rojo
title('senyal 1')

    %% SENYAL 2
[y Fs]=audioread('senyal2.wav'); % Carga el fichero 'senyal2.wav'
sound(10*y,Fs) % Reproduce el audio (auriculares)
GrafTrFourier(y,Fs,'g') % Dibuja el módulo de la TF en verde
title('senyal 2')

%% Código para multiplexar las señales Figura 1:

n=0:length(x)-1; % Se define la variable temporal t
t=n'/Fs;

f1=6000; % Frec. f1 (B<fs/2) diseñada en estudio previo a)
xm=x.*cos(2*pi*f1*t); % Modulacion x(t) para generar xm(t)
GrafTrFourier(xm,Fs,'r') % Dibuja el módulo de la TF en rojo
hold on % Fija la grafica para poder sobreponer

% la siguiente

f2=17000; % Frec. F2 diseñada en estudio previo a)
ym=y.*cos(2*pi*f2*t); % Modulacion y(t) para generar ym(t)
GrafTrFourier(ym,Fs,'g') % Dibuja el módulo de la TF en verde
hold off % Orden para no sobreponer más graficas
title('senyales multiplexadas')

sm=xm+ym; % Suma las señales sm(t)=xm(t)+ym(t)
sound(10*sm,Fs) % Reproduce el audio (auriculares)
%% Código para recuperar las señales Figura 2:

orden =100; %orden del filtro paso bajo

c=cos(2*pi*f1*t+pi/2); % Señal c(t) diseñada en estudio previo c)
v=sm.*c; % v(t)=sm(t) * c(t)
GrafTrFourier(v,Fs,'r') % Dibuja el módulo de la TF en rojo
title('senyal a la entrada del filtro')

Fcorte=5000; % Frec corte (fa=a/2pi;fa=fc(2^1/(n+1)-1)^-1/2) diseñada en estudio previo c)
r=F_PasoBajo(orden,v,Fcorte,Fs); % Filtro Paso Bajo
GrafTrFourier(r,Fs,'r') % Dibuja el módulo de la TF señal filtrada
sound(r,Fs) % Reproduce el audio (auriculares)
title('senyal recuperada')
%% Código para multiplexar las señales Figura 1 pero sin2pif1t:

n=0:length(x)-1; % Se define la variable temporal t
t=n'/Fs;

f1=6000; % Frec. f1 (B<fs/2) diseñada en estudio previo a)
xm=x.*cos(2*pi*f1*t); % Modulacion x(t) para generar xm(t)
GrafTrFourier(xm,Fs,'r') % Dibuja el módulo de la TF en rojo
hold on % Fija la grafica para poder sobreponer

% la siguiente

f2=17000; % Frec. F2 diseñada en estudio previo a)
ym=y.*sin(2*pi*f1*t); % Modulacion y(t) para generar ym(t)
GrafTrFourier(ym,Fs,'g') % Dibuja el módulo de la TF en verde
hold off % Orden para no sobreponer más graficas
title('senyales multiplexadas')

sm=ym+xm; % Suma las señales sm(t)=xm(t)+ym(t)
sound(10*sm,Fs) % Reproduce el audio (auriculares)