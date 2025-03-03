%3.1
n = [0:31];
fs=8000;
A=4;
fx = 2400;
xn = A*cos(2*pi*fx*n/fs);
xn = [xn zeros(1,512-32)];
figure
plot([0:511],abs(fft(xn)),'.');
%hem obtingut una grafica semblant a la de la seva
%transformada