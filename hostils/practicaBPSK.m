% SOBRE EL MODEL DEL CANAL FAREM UNA MODULACIO PER A PODER TRANSMETRE PEL
% CANAL VEIENT COM ES COMPORTA

close all; % tanca totes les grafiques

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% ++++++++++++++++++++++GENERACIO DADES A TRANSMETRE++++++++++++++++
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

dadesIN = randi([0 1],10600,1);

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% ++++++++++++++++++++++MODULACIO DBPSK+++++++++++++++++++++++++++++
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

dbpskmod = comm.DBPSKModulator;
dbpskdemod = comm.DBPSKDemodulator;
BxS = 1; % bits per simbol

dadesMOD = dbpskmod(dadesIN);

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% ++++++++++++++++++++++RETARD DE POTENCIA++++++++++++++++++++++++++
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

tau = [0 300e-6 1300e-6 2600e-6 4800e-6 7600e-6 10700e-6]; % segons del retard
TempsCoherencia = 10700e-6
pdB = [33 33 25 18 12 8 6]; % dBs de cada retard, a partir de 12 dB queden emmascarades pel soroll i no es veuen
% per a trobar els pics en nombre de mostres: retard/(1/fm) = nº de mostra
% respecte la inicial

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% ++++++++++++++++++++++DOPPLER+++++++++++++++++++++++++++++
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

fd1 = 20; % freq doppler, ens marca la velocitat de canvi del canal

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% ++++++++++++++++++++++GENERACIO CANAL+++++++++++++++++++++++++++++
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

%  generem un canal amb multipath
% freq de mostratge/velocitat de simbol. SampleRate ha de conicidir amb la velocitat de simbol
fm = 15000;
TempsSimbolDBPSK = (1/fm)*(BxS)
chan = comm.RayleighChannel('SampleRate', fm,...
                            'MaximumDopplerShift',fd1,...
                            'PathDelays',tau,...
                            'AveragePathGains',pdB); % passarem les dades per chan (chan es model del canal)

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% ++++++++++++++++++++++PASSEM LES DADES PEL CANAL++++++++++++++++++
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% passem les dades traspostes (dades') pel model del canal, cada repeticio sortira diferent per
% culpa de la frequencia doppler (fd1)
y = chan(dadesIN);
%plot(abs(y)) % fem abs per que les dades tenen variacions en fase

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% ++++++++++++++++++++++DECODIFIQUEM++++++++++++++++++++++++++++++++
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

dadesOUT = dbpskdemod(y);

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% ++++++++++++++++++++++CORRELEM++++++++++++++++++++++++++++++++++++
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% per a veure que passa en el canal, fem la correlacio creuada (?) entre el que hem
% rebut despres del canal i el que hem enviat

correlCanal = xcorr(dadesOUT, dadesIN);

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++MATRIU DE CANAL++++++++++++++++++++++++++++
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% Com hi ha una part de correlacio que es tot 0, no ens interessa, per lo
% que nomes agafem la part de la correlacio que no tingui 0

% em quedo la part de la correlacio des de la meitat fins al final, per a
% no tallar la primera mostra just a l'inici, agafarem 10 zeros més dels
% que toca
correlCanal_util = correlCanal(length(dadesIN)-10:2*length(dadesIN)-11); % 50400 mostres

%matriu_canal = reshape(correlCanal_util, length(dadesIN), repeticions)';
BER = sum(abs(dadesIN-dadesOUT))/length(dadesIN)
throughput = fm*(1/BxS)