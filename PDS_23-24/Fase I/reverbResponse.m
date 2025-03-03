function [hr, hrSize] = reverbResponse(fs,Tr)
   % hr(t) = A(t)*s(t)
   % A(t) = c^t * u(t)
   % 𝐴(𝑡) = l envolupant exponencial decreixent de la resposta impulsional, i 𝑠(𝑡) és un soroll 
   % blanc i Gaussià de mitja 0 i variància 1. La constant real 𝑐 (𝑐<1) determina el grau de 
   % decreixement de l%energia de la resposta impulsional. 
   % Tr = temps de reverberacio
   % c = grau de decreixement de l'energia de la resposta impulsional

   % PREGUNTA 3: c respecte Tr
   % A(0) = c^0 = 1
   % A(Tr) = c^Tr
   % 10log10(|A(Tr)|) = 10log10(|A(0)|)-60
   % sustituim a la 3ra equacio amb les 2 primeres:
   % -> 10log10(|c^Tr|) = 10log10(|c^0|)-60 -> 10log10(|c^Tr|) = -60 ->
   % -> 10*Tr*log10(|c|) = -60 -> c = 10^(-6/Tr)
   
   % PREGUNTA 4: resposta impulsional d'un sistema revereberador
   % temps de reverberació, com tenim una frequencia de mostratge, agafem fs mostres cada 1 segon, per lo tant tenim 2 opcions per a fer el vector  de temps:
   % 1. vector de 0 a Tr amb (1/fs)*Tr mostres pel mig
   % 2. vector de 0 a fs*Tr mostres
   % la opció 1 fa que el vector ja vagi escalat en funció a les unitats de
   % Tr però randn no admet vectors de nombres no sencers
   c = 10^(-6/Tr);  % grau de decreixement de l'energia de la resposta impulsional
   t = 0:1/fs:Tr-(1/fs); 
   s = randn(1,fs*Tr);    % soroll gaussià mitja 0, variancia 1, tamany igual que t
   A = c.^t;         % envolupant exponencial decreixent de la resposta impulsional
   length(A)
   length(s)
   hr = A.*s;        % resposta impulsional d'un sistema revereberador
   hrSize = fs*Tr;

   figure
   tiledlayout("vertical")

   nexttile
   plot(t,A)
   ylabel('A(t)')
   xlabel('t [s]')
   title('A(t)')

   nexttile
   plot(t,s)
   ylabel('s(t)')
   xlabel('t [s]')
   title('s(t)')

   nexttile
   plot(t,hr)
   ylabel('hr(t)')
   xlabel('t [s]')
   title('hr(t)')

end