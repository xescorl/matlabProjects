%% C�digo (opcional) para grabar sus propias se�ales de audio. Para esta pr�ctica utilice Fs=96000

Fs=96000;
Bx = XXXX ;
s1 = am_grabar(Fs,16); %graba una se�al 
s1f = F_PasoBajo(1000,v,Bx,Fs); % filtra la se�al para que tenga un ancho de banda Bx 
audiowrite('filename.wav',s1f,Fs) %guarda la se�al en un fichero 








