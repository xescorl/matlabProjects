% close all; % tanca totes les grafiques

dataSize = 100000;
padding = 600;
fd = 20; % freq doppler, ens marca la velocitat de canvi del canal
dbpskmod = comm.DBPSKModulator;
dbpskdemod = comm.DBPSKDemodulator;

% TempsCoherencia = 10700e-6
% throughput = fm*(1/BxS)
% TempsSimbolDBPSK = (1/fm)*(BxS)

dadesIN = randi([0 1],dataSize+padding,1);

tau = [0 300e-6 1300e-6 2600e-6 4800e-6 7600e-6 10700e-6];
pdB = [33 33 25 18 12 8 6]; % dBs de cada retard, a partir de 12 dB queden emmascarades pel soroll i no es veuen

fm = 1100;

% iteracions
SNRInit = 0;
SNRFinal = 70;
steps = 200;
SNRStep = (SNRFinal-SNRInit)/steps;
iteracio = 1;

BERTotal = zeros(1,steps+1);

for SNR = SNRInit:SNRStep:SNRFinal
    % creem canal -------------------------------------------------------------
    chan = comm.RayleighChannel('SampleRate', fm,...
                                'MaximumDopplerShift',fd,...
                                'PathDelays',tau,...
                                'AveragePathGains',pdB); % passarem les dades per chan (chan es model del canal)
    AWGN = comm.AWGNChannel('NoiseMethod', 'Signal to noise ratio (SNR)', 'SNR', SNR);
    retard = info(chan).ChannelFilterDelay;
    %--------------------------------------------------------------------------
    
    % modulem, les passem pel canal, traiem el retard, demodular---------------
    dadesMOD = dbpskmod(dadesIN);
    
    dadesChan = chan(dadesMOD);
    y = AWGN(dadesChan);

    
    dadesOUT = dbpskdemod(y(retard+1:(dataSize+retard),:));
    % -------------------------------------------------------------------------
    
    [nBitsErronisTotal, BERTotal(1,iteracio)] = biterr(dadesIN(1:dataSize,:),dadesOUT);
    iteracio = iteracio + 1;
end

% la funcio que posa soroll et diu quina potencia et dona (awgn.m)

% BER max 0.1

% throughput = f*BxS;
SNR = SNRInit:SNRStep:SNRFinal;
figure('Name','dbpskSNR')
plot(SNR,BERTotal);
grid on
grid minor
ylabel('BER')
xlabel('SNR')
title('DBPSK BER-SNR')
xlim([SNRInit SNRFinal])
ylim([0 0.4])