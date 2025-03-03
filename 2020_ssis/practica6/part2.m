%2.1
n = [0:31];
fs=8000;
A=4;
fx = 2400;
xn = A*cos(2*pi*fx*n/fs);
DFTx = fft(xn);
figure
stem(n,abs(DFTx));
%hem incomplert la relacio de lapartat 5.4