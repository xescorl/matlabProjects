clear all

fs = 10000;
Tm = 1.7;
t = -20:1/fs:20;
Lx = -20:1.7:20;
x = rectpuls(t-5,10);
N=fs/Tm;
X=fft(x,Lx);
plot(Lx,X);