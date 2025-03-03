sampling_rate = 48000;
frameLength = 2048;


%% Create input and output objects
deviceReader = audioDeviceReader('SamplesPerFrame',frameLength,'SampleRate',sampling_rate);
deviceWriter = audioDeviceWriter('SampleRate',sampling_rate);

signal_in = zeros(frameLength,1);
signal_out = zeros(frameLength,1);

play(deviceWriter,zeros(frameLength,1)); % Buffer delay DA (proteccion frente jitter)
play(deviceWriter,zeros(frameLength,1));

   
while 1,
    signal_in = step(deviceReader);
    play(deviceWriter,signal_out);
    PlotOnline_trF(signal_in,sampling_rate);
    drawnow;
    signal_out = signal_in;
end

release(deviceReader)
release(deviceWriter)