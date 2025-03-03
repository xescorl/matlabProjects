% SIMULAR CANAL AMB CARACTERISTIQUES
% SIMULAR SONDEIG I CALCUL DE LES CARACTERISTIQUES DEL CANAL
%  les caracteristiques son: doppler/delay spread, temps de coherencia i
%  ample de banda de coherencia
%  aixo es fara provant amb sequencies PN, per a obtenir una matriu del
%  canal
% SOBRE EL MODEL DEL CANAL FAREM UNA MODULACIO PER A PODER TRANSMETRE PEL
% CANAL VEIENT COM ES COMPORTA
%  -maximitzant bit rate
%  -minimitzant BER
%   començar per modulacio BPSK, (no cal enviar trames de sincronitzacio)
%   un cop funcioni o tinguem clar que esta passant, caldrà passarho a
%   multiportadora
%   transmetem a diferents velocitats i amb aixo veiem a quines velocitats
%   podem enviar (per lo del temps de bit menor/major al temps de coherencia)


close all; % tanca totes les grafiques

% fitxer per a simular el canal NOMES AMB DOPPLER i MULTIPATH

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% ++++++++++++++++++++++GENERACIO SEQUENCIA PN++++++++++++++++++++++
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

pnSequence = [7 6 0]; % 6 1 0 son els coeficients de x^7, x^6, x^0 <-- https://liquidsdr.org/doc/msequence/
chipIndex = [0 0 0 0 0 0 1]; % longitud de tamany 7 => 2^7 - 1 mostres
seqPN = genPNSequence(pnSequence, chipIndex); % sequencia PN generada

mostres = 4; % aquesta sequencia PN, te 4 mostres a cada xip
% x lo tant te 127*4 mostres = 508 mostres

% afegim 0 cada 3 mostres ************************************ - revisar
NouseqPN = upsample(seqPN, mostres); % afegim 0 cada 4 mostres
NouseqPN = filter([1 1 1 1], 1, NouseqPN); % canviem els zeros per la mostra anterior

%plot(NouseqPN, '*');

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% ++++++++++++++++++++++GENERACIO DADES A TRANSMETRE++++++++++++++++
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% Enviarem un munt de repeticions (200) de la sequencia PN i amb aixo farem una
% estimacio del canal segons la seva correlacio
% dades es la sequencia NouseqPN repetida "repeticions" cops
repeticions = 200;
dades = repmat(NouseqPN, 1, repeticions);

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
TempsSPN = (1/fm)*((2^7)-1)*4
chan = comm.RayleighChannel('SampleRate', fm,...
                            'MaximumDopplerShift',fd1,...
                            'PathDelays',tau,...
                            'AveragePathGains',pdB); % passarem les dades per chan (chan es model del canal)

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% ++++++++++++++++++++++PASSEM LES DADES PEL CANAL++++++++++++++++++
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% passem les dades traspostes (dades') pel model del canal, cada repeticio sortira diferent per
% culpa de la frequencia doppler (fd1)
y = chan(dades');
%plot(abs(y)) % fem abs per que les dades tenen variacions en fase

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% ++++++++++++++++++++++CORRELEM++++++++++++++++++++++++++++++++++++
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% per a veure que passa en el canal, fem la correlacio creuada (?) entre el que hem
% rebut despres del canal i el que hem enviat

% Hem de fer 2 correlacions, amb les dades sense passar pel canal (canal perfecte) i passant pel canal (canal amb merdes)
% per cada sequencia enviada tenim 1 pic
correlPerf = xcorr(dades, NouseqPN);
correlCanal = xcorr(y, NouseqPN);

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++MATRIU DE CANAL++++++++++++++++++++++++++++
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% Com hi ha una part de correlacio que es tot 0, no ens interessa, per lo
% que nomes agafem la part de la correlacio que no tingui 0

% em quedo la part de la correlacio des de la meitat fins al final, per a
% no tallar la primera mostra just a l'inici, agafarem 10 zeros més dels
% que toca
correlCanal_util = correlCanal(length(dades)-10:2*length(dades)-11); % 50400 mostres

matriu_canal = reshape(correlCanal_util, length(NouseqPN), repeticions)';

% la durada de la sequencia PN (temps de bit*nombre de bits) sempre ha de ser més gran que el retard del
% canal (des del primer senyal fins a l'ultim retard)
% ho podem solucionar canviant la fm o el nombre de bits de la sequencia PN

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% ++++++++++++++++++++++FUNCIO SCATTERING+++++++++++++++++++++++++++
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% estem transformant la variacio temporal per a obtindre lespectre doppler
% fftshift desplaça les mostres de manera que al mig de la gràfica queda el
% 0

for i = 1:length(NouseqPN)
    Fscatt(:,i) = fftshift(fft(matriu_canal(:,i)));
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% ++++++++++++++++++++++FUNCIO DE TRANSFERENCIA+++++++++++++++++++++
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% estem transformant l'eixamplament temporal per a obtindre la resposta en
% frequencia del canal
% fftshift desplaça les mostres de manera que al mig de la gràfica queda el
% 0

for i = 1:repeticions
    Ftransf(i,:) = fftshift(fft(matriu_canal(i,:)));
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% ++++++++++++++++++++++REPRESENTEM+++++++++++++++++++++++++++++++++
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

plot(abs(correlCanal_util))
title('correlacio del canal')

% veiem la variacio temporal i eixamplament temporal (retard) respecte el
% temps
figure
imagesc(abs(matriu_canal));
title('matriu del canal')

% eix horitzontal -> eixamplament temporal (pel multicami)
% cada linea horitzonal es una estimacio del canal
% eix vertical -> variacio temporal (pel doppler)
% blau es baix, vermell es alt (dB)
figure;
mesh(abs(matriu_canal));
title('matriu del canal');

% recorda que el retard en el temps es pot escalar tenint en compte la fm,
% cada mostra es fa cada 10 ms


% veiem la variacio temporal i eixamplament temporal (retard) respecte la
% frequencia
% veiem l'espectre doppler de cadascun dels camins
% l'eix vertical es frequencia
% l'eix horitzontal es el doppler
figure
imagesc(abs(Fscatt));
title('variacio temporal i eixamplament temporal (retard) respecte la frequencia')
figure;
mesh(abs(Fscatt));
title('variacio temporal i eixamplament temporal (retard) respecte la frequencia')

% veiem funcio de transferencia del canal
% veiem l'espectre doppler de cadascun dels camins
% l'eix vertical es frequencia
% l'eix horitzontal es el doppler
figure
imagesc(abs(Ftransf));
title('funcio de transferencia del canal i espectre doppler de cadascun dels camins')
figure;
mesh(abs(Ftransf));
title('funcio de transferencia del canal i espectre doppler de cadascun dels camins')