function audioRep(audioIN, audioOUT)
    LIN = length(audioIN);
    LOUT = length(audioOUT);
    fs = 44100;
    Ts = 1/fs;
    tin = 0:Ts:Ts*(LIN-1);
    tout = 0:Ts:Ts*(LOUT-1);
    fin = (0:LIN-1)*fs/LIN;
    fout = (0:LOUT-1)*fs/LOUT;

    INTrans = fft(audioIN);
    OUTTrans = fft(audioOUT);

    figure
    tiledlayout(2,2)
    
    plot(nexttile,tin,audioIN);
    grid on
    title('Original - Time')
    xlabel('Time (s)')
    ylabel('Amplitude')

    semilogx(nexttile,fin,20*log10(abs(INTrans)));
    grid on 
    title('Original - Frequency')
    xlabel('Frequency (Hz)')
    ylabel('Magnitude (dB)')
    xlim([10 fs/2])

    plot(nexttile,tout,audioOUT);
    grid on
    title('Filtered - Time')
    xlabel('Time (s)')
    ylabel('Amplitude')
    
    semilogx(nexttile,fout,20*log10(abs(OUTTrans)));
    grid on 
    title('Filtered - Frequency')
    xlabel('Frequency (Hz)')
    ylabel('Magnitude (dB)')
    xlim([10 fs/2])
end