%4.1
n=[-9:9];
n1=[0:18];
A=4;
Fx = 0.25;
w=[1:10,9:-1:1]/10;
x= A*cos(pi*n*2*Fx);

y= x.*w;
y1=x.*w;

figure
subplot(2,1,1);
stem(n,y);
subplot(2,1,2);
stem(n1,y1);
%hem obtingut la mateixa senyal desplaçada
%4.2
y1 = [y1 zeros(1,512-19)];
Ydft = fft(y1);
x = [x zeros(1,512-19)];
Xdft = fft(x);

figure
subplot(2,1,1);
plot([0:511],abs(Ydft),'.');
subplot(2,1,2);
plot([0:511],abs(Xdft),'.');
figure
plot((0:512-1),mag2db(abs(Xdft)),'.b', (0:512-1),mag2db(abs(Ydft)),'.r');
grid
