
%% Exercici2



clear all;



t = linspace(-2,2,1000);

A = 2;

B = 3;

f0 = 4;

S0 = pi;

x = A*cos(2*pi*f0*t+S0).*exp(-B*t).*ft_p_heaviside(t);

[mval,index] = max(x)

index

t(index)

plot(t,x)