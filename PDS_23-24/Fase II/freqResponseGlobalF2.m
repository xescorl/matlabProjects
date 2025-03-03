function [H_LP,H_BP,H_HP,H,h,f] = freqResponseGlobalF2(dB_LP,dB_BP,dB_HP,SOS_LP,G_LP,SOS_BP,G_BP,SOS_HP,G_HP,fs,N)
    x = [1;zeros(N-1,1)];

    SOS_HP(1,1:3) = SOS_HP(1,1:3)*prod(G_HP)*10^(dB_HP/20);
    h_HP = sosfilt(SOS_HP,x);

    SOS_BP(1,1:3) = SOS_BP(1,1:3)*prod(G_BP)*10^(dB_BP/20);
    h_BP = sosfilt(SOS_BP,x);

    SOS_LP(1,1:3) = SOS_LP(1,1:3)*prod(G_LP)*10^(dB_LP/20);
    h_LP = sosfilt(SOS_LP,x);

    h = h_LP + h_BP + h_HP;
    % Pel filtre global les matrius SOS han dincorporar el guany passat a
    % lineal
    [H_LP,f] = freqz(h_LP,1,2048,fs);
    [H_BP,f] = freqz(h_BP,1,2048,fs);
    [H_HP,f] = freqz(h_HP,1,2048,fs);
    H = H_LP+H_BP+H_HP;
    % 
    % phi= phase(H_LP+H_HP+H_BP);
    % 
    % minim = min([dB_LP dB_BP dB_HP]) - 20;
    % maxim = max([dB_LP dB_BP dB_HP]) + 20;
    % 
    % tiledlayout('vertical')
    % 
    % semilogx(nexttile,f,20*log10(abs(H_LP)),f,20*log10(abs(H_BP)),f,20*log10(abs(H_HP)));
    % ylim([minim maxim])
    % xlim([10 fs/2])
    % grid on 
    % title('Individual filters')
    % legend('Lowpass filter','Bandpass filter','Highpass filter')
    % xlabel('Frequency (Hz)')
    % ylabel('Magnitude (dB)')
    % 
    % semilogx(nexttile,f,20*log10(abs(H_LP+H_BP+H_HP)));
    % ylim([minim maxim])
    % xlim([10 fs/2])
    % grid on 
    % title('Custom Filter Response')
    % xlabel('Frequency (Hz)')
    % ylabel('Magnitude (dB)')
    % 
    % plot(nexttile,f,phi);
    % grid on
    % xlim([10 fs/2])
    % title('Custom Filter Phase')
    % xlabel('Frequency (Hz)')
    % ylabel('Phase (degrees)')
end