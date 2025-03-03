%1.1
n = [0:31];
fs=8000;
A=4;
fx = 2000;
xn = A*cos(2*pi*fx*n/fs);
%1.2
DFTx = fft(xn);
figure
stem(n,abs(DFTx));
%1.3
%1.4
%15