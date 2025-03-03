% close all; % tanca totes les grafiques

% modular x ex 8 subportadores amb dpsk

dataSize = 1000*8;
padding = 60*8;
fd = 20;
portadores = 8;
cplen = 0;

dbpskmod = comm.DBPSKModulator;
dbpskdemod = comm.DBPSKDemodulator;

% TempsCoherencia = 10700e-6
% throughput = fm*(1/BxS)
% TempsSimbolDBPSK = (1/fm)*(BxS)

dadesIN = randi([0 1],dataSize+padding,portadores);

tau = [0 300e-6 1300e-6 2600e-6 4800e-6 7600e-6 10700e-6];
pdB = [33 33 25 18 12 8 6]; % dBs de cada retard, a partir de 12 dB queden emmascarades pel soroll i no es veuen

% iteracions
fmInit = fd*10;
fmFinal = 15000;
steps = 1000;
fmStep = (fmFinal-fmInit)/steps;
iteracio = 1;

BERTotal = zeros(1,steps+1);

for fm = fmInit:fmStep:fmFinal
    % creem canal -------------------------------------------------------------
    chan = comm.RayleighChannel('SampleRate', fm,...
                                'MaximumDopplerShift',fd,...
                                'PathDelays',tau,...
                                'AveragePathGains',pdB); % passarem les dades per chan (chan es model del canal)
    retard = info(chan).ChannelFilterDelay;
    %--------------------------------------------------------------------------
            % dadesBPSK(:,n) = dbpskmod(dadesIN(:,n));

    % modulem, les passem pel canal, traiem el retard, demodular---------------
    for n = 1:portadores
        dadesBPSK(:,n) = dbpskmod(dadesIN(:,n));
    end
    
    dadesOFDM = ofdmmod(dadesBPSK',portadores,cplen);

    y = chan(dadesOFDM);

    dadesOFDMdem = ofdmdemod(y(retard+1:dataSize*portadores+retard,:),portadores,cplen);

    dadesOFDMdem = dadesOFDMdem';
    for n = 1:portadores
        dadesOUT(:,n) = dbpskdemod(dadesOFDMdem(:,n));
    end

    % -------------------------------------------------------------------------
    [nBitsErronisTotal, BERTotal(1,iteracio)] = biterr(dadesIN(1:dataSize,:),dadesOUT);
    iteracio = iteracio + 1;
end

% la funcio que posa soroll et diu quina potencia et dona

% BER max 0.1
f = fmInit:fmStep:fmFinal;
figure('Name','ofdm')
plot(f,BERTotal);
grid on
grid minor
ylabel('BER')
xlabel('frequency [Hz]')
title('OFDM BER-frequency')
xlim([fmInit fmFinal])
ylim([0 0.4])