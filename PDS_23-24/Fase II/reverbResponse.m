function [hr, hrSize] = reverbResponse(fs,Tr)
   c = 10^(-6/Tr);  % grau de decreixement de l'energia de la resposta impulsional
   t = 0:1/fs:Tr-(1/fs); 
   s = randn(1,round(fs*Tr));    % soroll gaussià mitja 0, variancia 1, tamany igual que t
   A = c.^t;         % envolupant exponencial decreixent de la resposta impulsional
   hr = A.*s;        % resposta impulsional d'un sistema revereberador
   hrSize = fs*Tr;
end