%% Código (opcional) para grabar sus propias señales de audio. Para esta práctica utilice Fs=96000

Fs=96000;
Bx = XXXX ;
s1 = am_grabar(Fs,16); %graba una señal 
s1f = F_PasoBajo(1000,v,Bx,Fs); % filtra la señal para que tenga un ancho de banda Bx 
audiowrite('filename.wav',s1f,Fs) %guarda la señal en un fichero 








