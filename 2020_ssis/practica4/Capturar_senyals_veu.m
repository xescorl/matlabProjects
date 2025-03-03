%% C�digo para capturar las se�ales de voz:

% Para escuchar solo una de las dos se�ales, pulse el cursos d'escritura 
% dentro del subapartado correspondiente (ver� que el fondo del texto pasa 
% a ser de color amarillado) y pulse Control+Enter.

%% Se�al 1:

[x,Fs]=audioread('senyal1.wav');  % Carga el fichero 'senyal1.wav' 
sound(10*x,Fs) % Reproduce el audio (auriculares) 
figure;
GrafTrFourier(x,Fs,'r') % Dibuja el m�dulo de la TF en rojo 
title('senyal 1') 


%% Se�al 2:

[y,Fs]=audioread('senyal2.wav'); % Carga el fichero 'senyal2.wav' 
sound(10*y,Fs) % Reproduce el audio (auriculares)
figure;
GrafTrFourier(y,Fs,'g')  % Dibuja el m�dulo de la TF en verde
title('senyal 2')