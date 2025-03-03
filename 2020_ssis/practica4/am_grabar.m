function [ voz ] = am_grabar( Fs,bits)
%[ voz ] = am_grabar( Fs,bits)
%rutina para grabar audio. Fs frecuencia de muestreo
%las más comunes (8000,11025,44100,48000,96000 Hz)
%bits: bits/muestra (8,16 or 24)
input('Pulsa enter para empezar a grabar y al terminar')
r=audiorecorder(Fs,bits,1);
record(r);
pause;
stop(r);
voz=getaudiodata(r,'double');

end

