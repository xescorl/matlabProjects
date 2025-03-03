
% Parámetros iniciales
delaySpread = 0.7;
dopplerFreq = 0.9;
carrierFreq = 15e6;
pathDelays = [0.99e-3 0.2e-3 1.5e-3];
pathGains = [0.9 1.5 2.25];

% Definición de los rangos de sampleRate
minSampleRate = 10;
maxSampleRate = 3e3;
stepSampleRate = 10;
sampleRates = minSampleRate:stepSampleRate:maxSampleRate;

% Prealocación de la variable ber
ber = zeros(size(sampleRates));

% Parámetros de la modulación QPSK
M = 2; % Orden de modulación (para QPSK) Con M=2 tenemos DPSK
numBits = 8000; % Número de bits a simular

% Generar el canal multipath
for i = 1:length(sampleRates)
    
    % Actualizar el SampleRate del canal
    channel = comm.RayleighChannel('SampleRate', sampleRates(i), ...
    'MaximumDopplerShift', dopplerFreq, ...
    'PathDelays', pathDelays, ...
    'AveragePathGains', pathGains);
    
    infos = info(channel).ChannelFilterDelay;

    % Generar los bits aleatorios
    
    %data = randi([0 M-1], numBits+800, 1);
    
    %fiquem tot a la mateixa matriu
    dataMatrix(:,1) = randi([0 M-1], numBits/8+100, 1);
    dataMatrix(:,2) = randi([0 M-1], numBits/8+100, 1);
    dataMatrix(:,3) = randi([0 M-1], numBits/8+100, 1);
    dataMatrix(:,4) = randi([0 M-1], numBits/8+100, 1);
    dataMatrix(:,5) = randi([0 M-1], numBits/8+100, 1);
    dataMatrix(:,6) = randi([0 M-1], numBits/8+100, 1);
    dataMatrix(:,7) = randi([0 M-1], numBits/8+100, 1);
    dataMatrix(:,8) = randi([0 M-1], numBits/8+100, 1);
    % Repartir los datos en 8 modulaciones
    %dataMatrix = reshape(data, [], 8); % la primera columna es igual a data
    
    % Modulación DPSK
    modSignalMatrix(:,1) = dpskmod(dataMatrix(:,1), M);
    modSignalMatrix(:,2) = dpskmod(dataMatrix(:,2), M);
    modSignalMatrix(:,3) = dpskmod(dataMatrix(:,3), M);
    modSignalMatrix(:,4) = dpskmod(dataMatrix(:,4), M);
    modSignalMatrix(:,5) = dpskmod(dataMatrix(:,5), M);
    modSignalMatrix(:,6) = dpskmod(dataMatrix(:,6), M);
    modSignalMatrix(:,7) = dpskmod(dataMatrix(:,7), M);
    modSignalMatrix(:,8) = dpskmod(dataMatrix(:,8), M);

    % OFDM
    %NFFT = size(modSignalMatrix,1);
    NFFT = 8;
    CPLEN = 0;
    %floor(NFFT/4);
    ofdmSignalMatrix = ofdmmod(modSignalMatrix',NFFT,CPLEN);
    
    % Aplicar el canal al signal
    receivedSignalMatrix = channel(ofdmSignalMatrix);
    receivedSignalMatrix = receivedSignalMatrix (infos+1: infos + numBits);
    %data = data (1:(numBits + 800)/8);%numBits es 8000
    
    %receivedSignalMatrix = ofdmSignalMatrix(1:numBits);

    % Demodulación OFDM
    demodSignalMatrix = ofdmdemod(receivedSignalMatrix,NFFT,CPLEN);
        
    % Demodulación DPSK
    demodSignalMatrix(1,:) = dpskdemod(demodSignalMatrix(1,:), M);
    demodSignalMatrix(2,:) = dpskdemod(demodSignalMatrix(2,:), M);
    demodSignalMatrix(3,:) = dpskdemod(demodSignalMatrix(3,:), M);
    demodSignalMatrix(4,:) = dpskdemod(demodSignalMatrix(4,:), M);
    demodSignalMatrix(5,:) = dpskdemod(demodSignalMatrix(5,:), M);
    demodSignalMatrix(6,:) = dpskdemod(demodSignalMatrix(6,:), M);
    demodSignalMatrix(7,:) = dpskdemod(demodSignalMatrix(7,:), M);
    demodSignalMatrix(8,:) = dpskdemod(demodSignalMatrix(8,:), M);

    %Desmuntem la matriu
    dataMatrixFinal = dataMatrix(1:1000,:);

    %Calculem BER
    for j= 1: 8
        ber1(i,j) = sum(dataMatrixFinal(:,j)' ~= demodSignalMatrix(j,:))/length(dataMatrixFinal(:,j)');
    end

    ber(i) = mean(ber1(i,:));
end

% Gráfica BER vs SampleRate
figure
plot(sampleRates, ber)
grid on
xlabel('Sample Rate (Hz)')
ylabel('Bit Error Rate (BER)')
title('BER vs Sample Rate OFDM')


