%7
N=15;

x=ones(1,6);
y=conv(x,x);

X=fft(x,N);
Z=X.*X;

z=ifft(Z,N);
%7.1
figure
subplot(2,1,1);
stem(y);
subplot(2,1,2);
stem(z);
%coincideixen amb 15, el valor mínim amb el que
%coincideixen es 10
%7.2
N=15;

x=ones(1,6);
y=conv(x,x);
z=conv(x,y);

X=fft(x,N);
Y=fft(y,N);

t=ifft(X.*Y,N);

figure
subplot(2,1,1);
stem(t);
subplot(2,1,2);
stem(z);
%7.3
