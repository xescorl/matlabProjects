%2
n=[-9:9];
n1=[0:18];
A=4;
Fx = 0.25;
w=[1:10,9:-1:1]/10;
x= A*cos(pi*n*2*Fx);

y= x.*w;
y1=x.*w;

y1 = [y1 zeros(1,512-19)];
y = [y zeros(1,512-19)];

Y1dft = fft(y1);
Ydft = fft(y);

x = [x zeros(1,512-19)];
Xdft = fft(x);
%%5
no=10;
zn=ifft(Y1dft.*exp(-j*2*pi/512*no*[0:511]));
figure
subplot(2,1,1);
stem(fft(zn));
subplot(2,1,2);
stem(Y1dft);
