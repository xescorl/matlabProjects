function [B,A,y] = parameq_fullband(x,fs,f0,bw,G)
% function [B,A,y] = parameq_fullband(x,fs,f0,bw,G)
%
%Función que implementa y aplica un banco de filtros paramétricos a la
% señal de entrada x. Sus argumentos de entrada son los siguientes:
% - x: señal discreta de entrada del filtro
% - fs: frecuencia de muestreo (en Hz)
% - f0: vector de frecuencias centrales (en Hz)
% - bw: vector de anchos de banda (en Hz)
% - G: vector de ganancias del filtro (en dB)
%
% Los argumentos de salida son:
% - B: numerador del banco de filtros
% - A: denominador del banco de filtros
% - y: señal discreta de salida, que se corresponde con la aplicación del
% banco de filtros paramétricos a la señal x.
[B1,A1] = parameq(fs,f0(1),bw(1),G(1));
[B2,A2] = parameq(fs,f0(2),bw(2),G(2));
[B3,A3] = parameq(fs,f0(3),bw(3),G(3));

B = conv(B3,conv(B1,B2));
A=conv(A3,conv(A1,A2));

y=filter(B,A,x);



end


