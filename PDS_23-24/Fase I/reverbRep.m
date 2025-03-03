clear all
fs=44100;
Tr=0.2;

c = 10^(-6/Tr);  % grau de decreixement de l'energia de la resposta impulsional
t = 0:1/fs:Tr-(1/fs); 
s = randn(1,fs*Tr);    % soroll gaussià mitja 0, variancia 1, tamany igual que t
A = c.^t;         % envolupant exponencial decreixent de la resposta impulsional
hr = A.*s;        % resposta impulsional d'un sistema revereberador

f = (0:length(t)-1)*fs/length(t);

tiledlayout('vertical')

nexttile
plot(t,hr)
title('hr-time')

nexttile
plot(f,fft(hr))
title('hr-frequency')