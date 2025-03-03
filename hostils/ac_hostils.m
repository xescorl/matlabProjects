f = [0.5 0.1 0.4];
F = [0.5,1,0.4,0,0;0,0.5,1,0.4,0;0,0,0.5,1,0.4];
d0vector = transpose([1 0 0 0 0]);
cd0 = ((F*ctranspose(F))^-1)*F*d0vector
gd0 = ctranspose(F)*cd0
d1vector = transpose([0 1 0 0 0]);
cd1 = ((F*ctranspose(F))^-1)*F*d1vector
gd1 = ctranspose(F)*cd1
d2vector = transpose([0 0 1 0 0]);
cd2 = ((F*ctranspose(F))^-1)*F*d2vector
gd2 = ctranspose(F)*cd2
d3vector = transpose([0 0 0 1 0]);
cd3 = ((F*ctranspose(F))^-1)*F*d3vector
gd3 = ctranspose(F)*cd3
d4vector = transpose([0 0 0 0 1]);
cd4 = ((F*ctranspose(F))^-1)*F*d4vector
gd4 = ctranspose(F)*cd4

x = [1:1:5];

plot(x,gd0,x,gd1,x,gd2,x,gd3,x,gd4)
grid on;
legend('gd0','gd1','gd2','gd3','gd4');

