%% Código para capturar las señales de voz:

% Para escuchar solo una de las dos señales, pulse el cursos d'escritura 
% dentro del subapartado correspondiente (verá que el fondo del texto pasa 
% a ser de color amarillado) y pulse Control+Enter.

%% Señal 1:

[x,Fs]=audioread('senyal1.wav');  % Carga el fichero 'senyal1.wav' 
sound(10*x,Fs) % Reproduce el audio (auriculares) 
figure;
GrafTrFourier(x,Fs,'r') % Dibuja el módulo de la TF en rojo 
title('senyal 1') 


%% Señal 2:

[y,Fs]=audioread('senyal2.wav'); % Carga el fichero 'senyal2.wav' 
sound(10*y,Fs) % Reproduce el audio (auriculares)
figure;
GrafTrFourier(y,Fs,'g')  % Dibuja el módulo de la TF en verde
title('senyal 2')