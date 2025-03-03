%% 1 

clear all

L=7;

n=0:L-1;

x=ones(1,L);

figure; stem(n,abs(x)), grid

%% 1 a b

N=3000;

F=(0:1:N-1)/N; % frec. equiespaciadas en el intervalo [0,1)

X=fft(x,N);

figure; subplot(211), plot(F, abs(X)),

title('|X(F)|'), xlabel('F')

subplot(212), plot(F, angle(X)), title('Arg[X(F)]'),xlabel('F')

%% 1 c

Xt= (sin(pi*F*L)./sin(pi*F)).*exp(-j*pi*F*(L-1)); % escriba aquí la expresión analítica, función de F, que ha

% calculado en el apartado 1 del trabajo previo. (Recuerde

% el ./ para dividir vectores punto a punto)

% comparación gráfica de la TF teórica y con fft

figure; subplot(221), plot(F, abs(X))

grid, title('|X(F)| con fft')

subplot(223), plot(F, angle(X))

grid, title('fase de X(F)con fft')

subplot(222), plot(F, abs(Xt))

grid, title('|X(F)| teórico')

subplot(224), plot(F, angle(Xt))

grid, title('fase teórica de X(F)')



%% 2

clear all

L=7;

n=0:L-1;

x=ones(1,L);

N=3000;



F=(0:1:N-1)/N; % frec. equiespaciadas en el intervalo [0,1)

F0= 1/4;

x= exp(j*2*pi*F0*n).*x;

X=fft(x,N);



Xt= (sin(pi*(F-F0)*L)./sin(pi*(F-F0))).*exp(-j*pi*(F-F0)*(L-1)); % escriba aquí la expresión analítica, función de F, que ha

% calculado en el apartado 1 del trabajo previo. (Recuerde

% el ./ para dividir vectores punto a punto)

% comparación gráfica de la TF teórica y con fft

figure; subplot(221), plot(F, abs(X))

grid, title('|X(F)| con fft')

subplot(223), plot(F, angle(X))

grid, title('fase de X(F)con fft')

subplot(222), plot(F, abs(Xt))

grid, title('|X(F)| teórico')

subplot(224), plot(F, angle(Xt))

grid, title('fase teórica de X(F)')

%% 3

clear all

load('senyal_p5-a3_1.mat'); % lo carga en el vector x

 N=100;

 F=(0:1:N-1)/N;

 X=fft(x,N);

figure; subplot(211), plot(F, abs(X)),

title('|X(F)|'), xlabel('F')

subplot(212), plot(F, angle(X)), title('Arg[X(F)]'),xlabel('F')

%% 4 b

T=0.1;

f =linspace(0,2000,4000);

Xa=(T/2)*sinc((f-1000)*T).*exp(-j*pi*(f-1000)*T) +(T/2)*sinc((f+1000)*T).*exp(-j*pi*(f+1000)*T);

nfig=figure; subplot(211), plot(f, abs(Xa)), title('|Xa(f)|')



N=4000;

fm=2100; % frecuencia de muestreo

Tm=1/fm; % periodo de muestreo

f0=1000; % frecuencia de la sinusoide de xa(t)

F0=f0/fm; % frecuencia de la sinusoide de xd[n]

T=0.1; % duración del pulso en seg

t=0:Tm:1

 F =(0:1:N-1)/N;

 xd=(t<T).*cos(2*pi*f0*t);

Xd=fft(xd,N);

nfig=figure;

figure(nfig); subplot(212), plot(F, abs(Xd));



figure; plot(f,abs(Xa),F*fm,abs(Xd)/fm), grid, xlim([0 fm/2]); % visualizar la transformada en el intervalo [0,0.5)

%% 5 
clear all
fm= 4300;
x = gensenpbanda(fm);
N = 8061;
X = fft(x,N);
k1=1/fm;
k2=fm;
F=(0:N-1)/N;
plot(F*k2, abs(k1*X));
