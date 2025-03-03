function [B,A] = parameq(fs,fo,BW,G)
%
% Filtro paramétrico de Regalia-Mitra [1], con los siguientes argumentos
% de entrada:
% - fs: frecuencia de muestreo (en Hz)
% - f0: frecuencia central (en Hz)
% - bw: ancho de banda (en Hz)
% - G: ganancia del filtro (en dB)
%
% Los argumentos de salida son:
% - B: numerador del filtro
% - A: denominador del filtro
%
%
% [1] Regalia and Mitra (IEEE Trans. ASSP-35, no. 1, January, 1987)
K=10^(G/20);
b=-cos((2*pi*fo)/fs);
a=(1-tan(2*pi*(BW/fs)))/(1+tan(2*pi*(BW/fs)));
A=[1,b*(1+a),a];
B=[0.5*(1+K+a-a*K),b*(1+a),0.5*(1+a-K+K*a)];
end