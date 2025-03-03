%% Código para recuperar las señales Figura 2:

orden =100;                         %orden del filtro paso bajo

c=   cos(2*pi*t*5000+pi/4)     ;                     % Señal c(t) diseñada en estudio previo c)
v=sm.*c;                            % v(t)=sm(t)*c(t)
GrafTrFourier(v,Fs,'r')             % Dibuja el módulo de la TF en rojo
title('senyal a la entrada del filtro')

Fcorte=  7050 ;                     % Frec corte diseñada en estudio previo c)
r=F_PasoBajo(orden,v,Fcorte,Fs);    % Filtro Paso Bajo
GrafTrFourier(r,Fs,'r')             % Dibuja el módulo de la TF señal filtrada
sound(r,Fs)                         % Reproduce el audio (auriculares) 
title('senyal recuperada')



