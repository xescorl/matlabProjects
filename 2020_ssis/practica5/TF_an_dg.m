%  Programa para comparar la TF de senyales analogicas y secuencias 
%  Obtenidas a partir de sus muestras.
%     1. pulso rectangular 
%     2. exponencial unilateral
%     3. gaussiana
 
clear all

 
senyal=menu('Senyal', 'Pulso rect.','Exp. unilateral','Gaussiana');
fm=input('Introduzca la frecuencia de muestreo (max 20Hz) fm= ');
 
tmin=-5; tmax=10; tinc=0.0123; t=tmin:tinc:tmax;
nini=floor(tmin*fm);nmax=floor(tmax*fm); n=nini:nmax;

F=linspace(-1,1,1001);
f=linspace(-fm,fm,10001); % frecuencia analogica entre -fm y fm Hz
 
 
if senyal==1;
    T=5;                                  % Duracion del pulso en seg T
    xa=1.*(t>=0)&(t<T);                   % Senyal analogica
    x =1.*(n>=0)&(n/fm<T);                % Secuencia
    Xa=T*exp(-j*2*pi*T/2).*sinc(T*f);     % TF senyal analogica

elseif senyal==2
    xa=exp(-t).*(t>=0);                   % Senyal analogica
    x=exp(-n/fm).*(n>=0);x(n==0)=0.5;     % Secuencia
    Xa= 1./(1+j*2*pi*f);                  % TF senyal analogica

elseif senyal==3
    xa=(1/(2*pi)^1/2)*exp(-pi*(t).^2);    % Senyal analogica
    x =(1/(2*pi)^1/2)*exp(-pi*(n/fm).^2); % Secuencia
    Xa=(1/(2*pi)^1/2)*exp(-pi*f.^2);      % TF senyal analogica
end
 
%Transformada de Fourier de la secuencia calculada con la rutina
 
Xd=DFT_mostra(x,n,F) ; % Introduzca la rutina para calcular la TF de la secuencia x

figure
subplot(4,1,1);plot(t,xa,'r');hold on; stem(n/fm,x,'b'); hold off; title('x(t) (rojo) y x[n] (azul)');
 
subplot(4,1,2); plot(f,abs(Xa));title('Modulo de la TF senyal analogica |Xa(f)|');xlabel('f(Hz)')

subplot(4,1,3);plot(F,abs(Xd),'r');title('TF calculada con rutina |Xd(F)|');xlabel('F')

subplot(4,1,4);plot(fm*F,abs(Xd)/fm,'r',f,abs(Xa),'b'); 
title ('Comparación de |Xd(f/fm)|/fm (roja) y |Xa(f)|(azul)'); xlabel('f(Hz)')

