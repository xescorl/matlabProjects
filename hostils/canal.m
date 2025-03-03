% fitxer per a simular el canal

pnSequence = [6 1 0]; % 6 1 0 son els coeficients de x^6, x^1, x^0
chipIndex = [0 0 0 0 0 1]; % longitud de tamany 6
seqPN = genPNSequence(pnSequence, chipIndex); % sequencia PN generada

mostres = 4; % aquesta sequencia PN, te 4 mostres a cada xip

% afegim 0 cada 3 mostres ************************************ - revisar
NouseqPN = upsample(seqPN, mostres); % afegim 0 cada 4 mostres
NouseqPN = filter([1 1 1 1], 1, NouseqPN); % canviem els zeros per la mostra anterior

plot(NouseqPN, '*');