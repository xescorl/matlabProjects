clear all, close all ,clc

%% FASE 1: ANALITZAR EL SENYAL DE POLS
pulso = load("Pulso.mat");
senyal_pols = pulso.data;
%1.1    Quantes mostres té el senyal del fotopletismògraf?
mostres_pleismograf = whos("senyal_pols").size(1)*whos("senyal_pols").size(2)
%1.2    Quina és la seva durada (en segons)? 
durada_pleismograf = mostres_pleismograf*(pulso.isi*10^3);
%1.3    Com estan relacionades la durada en mostres i en segons del senyal?
fsPOL = 1/(pulso.isi*10^-3);
disp("agafem una mostra cada isi, per lo tant #mostres * isi [segons] = duració [segons]")
%1.4    Format de dades de les mostres dels senyals a Matlab
disp("utilitza matrius, en aquest cas de doubles")
%1.4    # bits usa Matlab per guardar cada mostra del senyal
bits_mostra = 64
%1.5    Quants bytes de memòria ocupa el senyal?
bytes_senyal = (mostres_pleismograf*bits_mostra)/8
%1.6    Quin fluxe binari (en bits/sg) genera el Biopac en digitalitzar aquest senyal? 
fluxe_binari = (bytes_senyal*8)/durada_pleismograf

tPOL = (pulso.start_sample:mostres_pleismograf - 1)/fsPOL; % en segons
length(tPOL)
length(senyal_pols)
figure('Name','FASE1')
plot(tPOL*10^3,senyal_pols)
title(pulso.labels)
xlabel(pulso.isi_units)
ylabel(pulso.units)
%% FASE 2: DESPLAÇAMENT FREQÜENCIAL DEL SENYAL DE POLS
%2.1    Calcula i representa l’espectre de mòdul del senyal d’aquest senyal
espectre = fft(senyal_pols*10^-3);
fPOL = (0:mostres_pleismograf-1)*(fsPOL/mostres_pleismograf);
tPOL = 0:mostres_pleismograf-1;
figure('Name','FASE2')
tiledlayout(4,1)
semilogx(nexttile,fPOL,fftshift(20*log10(abs(espectre))))
title("espectre fotopleismograf")
grid on
xlabel("frequecia [Hz]")
ylabel("potencia senyal [dB]")
ylim([-80 30])
xlim([10 fsPOL])
disp("aproximadament té un ample de banda de 1000 Hz")
%2.2    Genera un to pur de freqüència 500 Hz, mostrejat a 2000 Hz
f_to = 500;
to_pur500 = sin(tPOL*2*pi*(f_to/fsPOL));
%2.3    Multiplica el senyal de pols pel to pur, i calcula i representa l espectre de mòdul del senyal del senyal resultant
polsXto500 = (senyal_pols*10^-3).*(to_pur500)';
semilogx(nexttile,fPOL,fftshift(20*log10(abs(fft(polsXto500)))))
title("espectre pols * to pur 500Hz")
grid on
xlabel("frequecia [Hz]")
ylabel("potencia senyal [dB]")
ylim([-80 30])
xlim([10 fsPOL])
f_to = 750;
to_pur750 = sin(tPOL*2*pi*(f_to/fsPOL));
polsXto750 = (senyal_pols*10^-3).*(to_pur750)';
semilogx(nexttile,fPOL,fftshift(20*log10(abs(fft(polsXto750)))))
title("espectre pols * to pur 750Hz")
grid on
xlabel("frequecia [Hz]")
ylabel("potencia senyal [dB]")
ylim([-80 30])
xlim([10 fsPOL])
f_to = 1100;
to_pur1100 = sin(tPOL*2*pi*(f_to/fsPOL));
polsXto1100 = (senyal_pols*10^-3).*(to_pur1100)';
semilogx(nexttile,fPOL,fftshift(20*log10(abs(fft(polsXto1100)))))
title("espectre pols * to pur 1100Hz")
grid on
xlabel("frequecia [Hz]")
ylabel("potencia senyal [dB]")
ylim([-80 30])
xlim([10 fsPOL])
disp("donat que la transformada de fourier d'un sinus son dos deltes desplaçades a +-fsen, el que veiem es una convolució del senyal_pols, que pràcticament és una delta a f0 = 1000, amb dues deltes a +-fsen, per propietats de convolució amb deltes, tenim que el senyal original queda desplaçat f0-fsen i f0+fsen , per lo tant tenim pics a: 1000-500 i 1000-750. A l'augmentar la freqüencia del sinus a més de 1000 Hz, donat que la transformada de fourier només es pot fer de senyals periòdics, el que veiem a partir dels 1000 Hz de desplaçament, es la convolució amb els hamónics, situats a n*f0 => veiem (2*fo)-fsen")
%% FASE 3: DISSENYAR FILTRES FIR PASSA-BAIXES DE DIFERENTS ORDRES PER FILTRAR L'EMG 
%3.1
emg = load("EMG.mat");
senyal_emg = emg.data;
fsEMG = 1/(emg.isi*10^-3);
tEMG = (0:length(senyal_emg) - 1)/fsEMG; % en segons
fEMG = (0:length(senyal_emg)-1)*(fsEMG/length(senyal_emg));
%3.2
filter_order = 5;
freq_tall = 20;
freq_norm = freq_tall/(fsEMG/2);
low_pass = fir1(filter_order,freq_norm,'low');
%3.3
figure('Name','FASE3:filtre20Hz')
freqz(low_pass);
%3.4
figure('Name','FASE3:senyalsfiltre20Hz')
tiledlayout(5,1)
nexttile
zplane(low_pass)
%3.5
senyal_filtrada = filter(low_pass,1,senyal_emg);
plot(nexttile,tEMG*10^3,senyal_emg)
title('senyal EMG')
xlabel(emg.isi_units)
ylabel(emg.units)
ylim([-1 1])
xlim([0 length(senyal_emg)*(1/fsEMG)*10^3])
semilogx(nexttile,fEMG,fftshift(20*log10(abs(fft(senyal_emg)))))
title('espectre senyal EMG')
xlabel('freqüencia [Hz]')
ylabel('dB')
ylim([-80 50])
xlim([0 fsEMG])
plot(nexttile,tEMG*10^3,senyal_filtrada)
title('senyal EMG filtrada')
xlabel(emg.isi_units)
ylabel(emg.units)
ylim([-1 1])
xlim([0 length(senyal_emg)*(1/fsEMG)*10^3])
semilogx(nexttile,fEMG,fftshift(20*log10(abs(fft(senyal_filtrada)))))
title('espectre senyal EMG filtrada')
xlabel('freqüencia [Hz]')
ylabel('dB')
ylim([-80 50])
xlim([1 fsEMG])
%3.6
filter_order = 20;
low_pass = fir1(filter_order,freq_norm,'low');

figure('Name','FASE3:filtre20Hz_n20')
freqz(low_pass);

figure('Name','FASE3:senyalsfiltre20Hz_n20')
tiledlayout(5,1)
nexttile
zplane(low_pass)

senyal_filtrada = filter(low_pass,1,senyal_emg);
plot(nexttile,tEMG*10^3,senyal_emg)
title('senyal EMG')
xlabel(emg.isi_units)
ylabel(emg.units)
ylim([-1 1])
xlim([0 length(senyal_emg)*(1/fsEMG)*10^3])
semilogx(nexttile,fEMG,fftshift(20*log10(abs(fft(senyal_emg)))))
title('espectre senyal EMG')
xlabel('freqüencia [Hz]')
ylabel('dB')
ylim([-80 50])
xlim([0 fsEMG])
plot(nexttile,tEMG*10^3,senyal_filtrada)
title('senyal EMG filtrada')
xlabel(emg.isi_units)
ylabel(emg.units)
ylim([-1 1])
xlim([0 length(senyal_emg)*(1/fsEMG)*10^3])
semilogx(nexttile,fEMG,fftshift(20*log10(abs(fft(senyal_filtrada)))))
title('espectre senyal EMG filtrada')
xlabel('freqüencia [Hz]')
ylabel('dB')
ylim([-80 50])
xlim([1 fsEMG])

filter_order = 50;
low_pass = fir1(filter_order,freq_norm,'low');

figure('Name','FASE3:filtre20Hz_n50')
freqz(low_pass);

figure('Name','FASE3:senyalsfiltre20Hz_n50')
tiledlayout(5,1)
nexttile
zplane(low_pass)

senyal_filtrada = filter(low_pass,1,senyal_emg);
plot(nexttile,tEMG*10^3,senyal_emg)
title('senyal EMG')
xlabel(emg.isi_units)
ylabel(emg.units)
ylim([-1 1])
xlim([0 length(senyal_emg)*(1/fsEMG)*10^3])
semilogx(nexttile,fEMG,fftshift(20*log10(abs(fft(senyal_emg)))))
title('espectre senyal EMG')
xlabel('freqüencia [Hz]')
ylabel('dB')
ylim([-80 50])
xlim([0 fsEMG])
plot(nexttile,tEMG*10^3,senyal_filtrada)
title('senyal EMG filtrada ordre 50')
xlabel(emg.isi_units)
ylabel(emg.units)
ylim([-1 1])
xlim([0 length(senyal_emg)*(1/fsEMG)*10^3])
semilogx(nexttile,fEMG,fftshift(20*log10(abs(fft(senyal_filtrada)))))
title('espectre senyal EMG filtrada')
xlabel('freqüencia [Hz]')
ylabel('dB')
ylim([-80 50])
xlim([1 fsEMG])
disp("al augmentar l'ordre del filtre, podem observar que la penden descendent del filtre es molt més pronunciada a la freqüencia de tall, en quant a la fase, podem observar que a major ordre, més varia la fase respecte la freqüencia")
%3.4
disp("veig tants pols i zeros com ordre té el filtre. a major ordre, tots els zeros estan més aprop del cercle unitat")
%3.5
disp("al augmentar l'ordre del filtre podem observar que el senyal s'atenua més")
%% FASE 4: Estudi de filtres FIR i IIR
emg = load("EMG.mat");
senyal_emg = emg.data;
fsEMG = 1/(emg.isi*10^-3);
tEMG = (0:length(senyal_emg) - 1)/fsEMG; % en segons
fEMG = (0:length(senyal_emg)-1)*(fsEMG/length(senyal_emg));
%4.6
FIR = load("FIR.mat");
IIR = load("IIR.mat");
[bIIR,aIIR] = sos2tf(IIR.SOS,IIR.G);
figure('Name','FASE4:resposta freqüencial FIR')
[h_FIR,freqs_FIR] = freqz(FIR.Num,1,length(senyal_emg),fsEMG);
freqz(FIR.Num,2048)
figure('Name','FASE4:resposta freqüencial IIR');
[h_IIR,freqs_IIR] = freqz(bIIR,aIIR,length(senyal_emg),fsEMG);
freqz(IIR.SOS,2048)
%4.7
figure('Name','FASE4:resposta dels filtres')
tiledlayout('flow')
%4.7.1
nexttile
semilogx(fEMG,fftshift(20*log10(abs(fft(senyal_emg)))))
title('fft senyal EMG')
xlabel('freqüencia [Hz]')
ylabel('dB')
ylim([-80 50])
xlim([0 fsEMG])
%4.7.2
nexttile
semilogx(fEMG,fftshift(20*log10(abs(fft(senyal_emg)))),fEMG,fftshift(20*log10(abs(h_FIR))),fEMG,angle(h_FIR))
title('fft senyal EMG - resposta FIR')
xlabel('freqüencia [Hz]')
ylabel('dB')
ylim([-160 50])
xlim([0 fsEMG])
yyaxis left
%4.7.3
nexttile
semilogx(fEMG,fftshift(20*log10(abs(fft(senyal_emg)))),fEMG,fftshift(20*log10(abs(h_IIR))),fEMG,angle(h_IIR))
title('fft senyal EMG - resposta IIR')
xlabel('freqüencia [Hz]')
ylabel('dB')
ylim([-160 50])
xlim([0 fsEMG])
yyaxis left
%4.7.4
plot(nexttile,tEMG*10^3,senyal_emg)
title('senyal EMG')
xlabel(emg.isi_units)
ylabel(emg.units)
ylim([-1 1])
xlim([0 length(senyal_emg)*(1/fsEMG)*10^3])
%4.7.5
emg_FIR = filter(FIR.Num,1,senyal_emg);
plot(nexttile,tEMG*10^3,emg_FIR)
title('senyal EMG filtrada FIR')
xlabel(emg.isi_units)
ylabel(emg.units)
ylim([-1 1])
xlim([0 length(senyal_emg)*(1/fsEMG)*10^3])
%4.7.6
emg_IIR = filter(bIIR,aIIR,senyal_emg);
plot(nexttile,tEMG*10^3,emg_IIR)
title('senyal EMG filtrada IIR')
xlabel(emg.isi_units)
ylabel(emg.units)
ylim([-1 1])
xlim([0 length(senyal_emg)*(1/fsEMG)*10^3])
%4.6
disp("El filtre IIR es molt més selectiu que el filtre FIR.")
%4.7
disp("Podem conclore que el filtre IIR elimina més senyal que el FIR. El filtre IIR atenua més. Per què té una resposta impulsional més pronunciada a les bandes de pas.")