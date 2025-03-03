%% Aquesta demo realitza el mostratge d'un to pur per tal de comprovar quan es produeix aliàsing i quan no.
%% Podem modificar la freqüència del to pur, i la freqüència de mostratge, i escoltar el senyal original i el que 
%% recupera a partir del senyal mostrejat

%% Eliminem variables i figures prèvies i netegem pantalla
clear all, close all, clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Paràmetres ajustables
%Freqüència del to pur que mostrejarem
f = 1800;
%Freqüència de mostratge
fm_out = 4000;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Paràmetres de la simulació
fm_in = 50000; 
f_min = 50;

% Inicialtitzem els paràmetres de l'eix de temps
t_sound = 1;
t_width = 1/f_min;
t_long_in = linspace(0,t_sound,fm_in*t_sound+1);
t_in = t_long_in(1:fm_in*t_width+1);
t_long_out = linspace(0,t_sound,fm_out*t_sound+1);
t_out = t_long_out(1:fm_out*t_width+1);
  
%% Generem el senyal d'entrada i el senyal mostrejat
s_long_in = sin(2*pi*f*t_long_in);
s_in = s_long_in(1:fm_in*t_width+1);
s_long_out = sin(2*pi*f*t_long_out);
s_out = s_long_out(1:fm_out*t_width+1);

%% Mostrem el senyal d'entrada, les mostres i el senyal reconstruït
figure(1)
set(gcf, 'Position', get(0, 'Screensize'));

plot(1000*t_in,s_in,'r','LineWidth',3);
hold on
plot([0 1000*t_width],[0 0],'k');
plot(1000*t_out,s_out,'b','LineWidth',3);
plot(1000*t_out,s_out,'ko','LineWidth',3,'MarkerSize',10);
hold off
axis([0 1000*t_width -1.1 1.1])
title(['{\itf} = ' num2str(f,'%.1f') ' Hz {\itf_m} = ' num2str(fm_out) ...
    ' Hz     {\itf_m} / 2 = ' num2str(fm_out/2) ' Hz'])
xlabel('temps (ms)')
ylabel('amplitud')
legend({'Senyal original x(t)', 'Mostres', 'Senyal reconstruït'})
drawnow

%% Reproducció dels senyals
%Escoltem el senyal original
uiwait(msgbox('Escolta el senyal original','modal'));
sound(s_long_in,fm_in)
pause(2.5)
%Escoltem el senyal reconstruït a partir del senyal mostrejat
uiwait(msgbox('Escolta el senyal mostrejat','modal'));
sound(s_long_out,fm_out)
pause(2)
