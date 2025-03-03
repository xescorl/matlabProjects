close all; % tanca totes les grafiques

% fitxer per a simular el canal NOMES AMB DOPPLER i MULTIPATH

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% ++++++++++++++++++++++GENERACIO SEQUENCIA PN++++++++++++++++++++++
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

pnSequence = [6 1 0]; % 6 1 0 son els coeficients de x^6, x^1, x^0
chipIndex = [0 0 0 0 0 1]; % longitud de tamany 6
seqPN = genPNSequence(pnSequence, chipIndex); % sequencia PN generada

mostres = 4; % aquesta sequencia PN, te 4 mostres a cada xip
% x lo tant te 256*4 mostres

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

tau = [0 100e-6 600e-9 1200e-6]; % segons del retard
pdB = [0 -6 -6 -9]; % dBs de cada retard

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% ++++++++++++++++++++++DOPPLER+++++++++++++++++++++++++++++
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

fd1 = 20; % freq doppler, ens marca la velocitat de canvi del canal

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% ++++++++++++++++++++++GENERACIO CANAL+++++++++++++++++++++++++++++
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

%  generem un canal amb multipath
fm = 100000; % freq de mostratge/velocitat de simbol. SampleRate ha de conicidir amb la velocitat de simbol
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

% veiem la variacio temporal i eixamplament temporal (retard) respecte el
% temps
figure
imagesc(abs(matriu_canal));
% eix horitzontal -> eixamplament temporal (pel multicami)
% cada linea horitzonal es una estimacio del canal
% eix vertical -> variacio temporal (pel doppler)
% blau es baix, vermell es alt (dB)
figure;
mesh(abs(matriu_canal));
% recorda que el retard en el temps es pot escalar tenint en compte la fm,
% cada mostra es fa cada 10 ms


% veiem la variacio temporal i eixamplament temporal (retard) respecte la
% frequencia
% veiem l'espectre doppler de cadascun dels camins
% l'eix vertical es frequencia
% l'eix horitzontal es el doppler
figure
imagesc(abs(Fscatt));
figure;
mesh(abs(Fscatt));

% veiem funcio de transferencia del canal
% veiem l'espectre doppler de cadascun dels camins
% l'eix vertical es frequencia
% l'eix horitzontal es el doppler
figure
imagesc(abs(Ftransf));
figure;
mesh(abs(Ftransf));