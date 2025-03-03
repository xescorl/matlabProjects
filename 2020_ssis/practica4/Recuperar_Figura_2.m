%% C�digo para recuperar las se�ales Figura 2:

orden =100;                         %orden del filtro paso bajo

c=   cos(2*pi*t*5000+pi/4)     ;                     % Se�al c(t) dise�ada en estudio previo c)
v=sm.*c;                            % v(t)=sm(t)*c(t)
GrafTrFourier(v,Fs,'r')             % Dibuja el m�dulo de la TF en rojo
title('senyal a la entrada del filtro')

Fcorte=  7050 ;                     % Frec corte dise�ada en estudio previo c)
r=F_PasoBajo(orden,v,Fcorte,Fs);    % Filtro Paso Bajo
GrafTrFourier(r,Fs,'r')             % Dibuja el m�dulo de la TF se�al filtrada
sound(r,Fs)                         % Reproduce el audio (auriculares) 
title('senyal recuperada')



