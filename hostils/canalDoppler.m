% fitxer per a simular el canal NOMES AMB DOPPLER

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% ++++++++++++++++++++++GENERACIO SEQUENCIA PN++++++++++++++++++++++
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

pnSequence = [6 1 0]; % 6 1 0 son els coeficients de x^6, x^1, x^0
chipIndex = [0 0 0 0 0 1]; % longitud de tamany 6
seqPN = genPNSequence(pnSequence, chipIndex); % sequencia PN generada

mostres = 4; % aquesta sequencia PN, te 4 mostres a cada xip

% afegim 0 cada 3 mostres ************************************ - revisar
NouseqPN = upsample(seqPN, mostres); % afegim 0 cada 4 mostres
NouseqPN = filter([1 1 1 1], 1, NouseqPN); % canviem els zeros per la mostra anterior

%plot(NouseqPN, '*');

% Enviarem un munt de repeticions (200) de la sequencia PN i amb aixo farem una
% estimacio del canal segons la seva correlacio
% dades es la sequencia NouseqPN repetida "repeticions" cops
repeticions = 200;
dades = repmat(NouseqPN, 1, repeticions);

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% ++++++++++++++++++++++GENERACIO CANAL+++++++++++++++++++++++++++++
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

%  generem un canal sense multipath
fm = 100000; % freq de mostratge/velocitat de simbol. SampleRate ha de conicidir amb la velocitat de simbol
fd1 = 20; % freq doppler, ens marca la velocitat de canvi del canal
chan = comm.RayleighChannel('SampleRate', fm,'MaximumDopplerShift',fd1); % passarem les dades per chan (chan es model del canal)

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% ++++++++++++++++++++++PASSEM LES DADES PEL CANAL+++++++++++++++++++++++++++++
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% passem les dades traspostes (dades') pel model del canal, cada repeticio sortira diferent per
% culpa de la frequencia doppler (fd1)
y = chan(dades');
%plot(abs(y)) % fem abs per que les dades tenen variacions en fase

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% ++++++++++++++++++++++CORRELEM+++++++++++++++++++++++++++++
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% per a veure que passa en el canal, fem la correlacio creuada (?) entre el que hem
% rebut despres del canal i el que hem enviat

% Hem de fer 2 correlacions, amb les dades sense passar pel canal (canal perfecte) i passant pel canal (canal amb merdes)
% per cada sequencia enviada tenim 1 pic
correlPerf = xcorr(dades, NouseqPN);
correlCanal = xcorr(y, NouseqPN);

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% ++++++++++++++++++++++REPRESENTEM+++++++++++++++++++++++++++++
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

plot(abs(correlCanal))