function audioOUT = reverb(audioIN,time,M)
[hr, hrSize] = reverbResponse(44100,time);
audioINpad = [audioIN;zeros(hrSize-1,1)];
audioReverb = fftfilt(hr/norm(hr),audioINpad);
audioOUT = audioINpad*(1-M/100) + audioReverb*(M/100)';
end