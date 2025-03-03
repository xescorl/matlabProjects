function [audioOUT,audioIN] = processaudio(audioINfilename,effect,param)
close all
 % Els paràmetres d'entrada són:
 % audioINfilename: string amb el nom del fitxer d'àudio a processar
 % effect: string que indica el tipus d'efecte ('equalizer' o 'reverb')
 % param: vector numèric amb els paràmetres de l'efecte
 % si effect = 'equalizer' --> param és un vector de 3 components
 % amb els guanys en dBs dels 3 filtres LPF, BPF i HPF,
 % respectivament.
 % si effect = 'reverb' --> param(1) és el temps de reverberació en
 % segons i param(2) és el coeficient de mescla (M) en %

% PREGUNTA 1: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
[audioIN,FsIn] = audioread(audioINfilename);
[L,M] = rat(44100/FsIn,1e-4); % fs_final/fs_original = L/M = p/q*e
audioIN = resample(audioIN,L,M);
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

 if strcmpi(effect,'equalizer')
     % senyal in, passat per 3 filtres en paralel, sumantse en la sortida
     % un LP de 250 Hz
     % un BP de 250 a 2250 Hz
     % un HP de 2250 Hz
     % caracteristiques IIR: Butterworth, ordre 12
     % un cop tots els filtres fets i stored, anem a filter manager i
     % fvtool
     % Un cop exportats els coeficients tenim l'arxiu filtersSOS, aquest
     % esta composat per 3 components (1 per banda), aquestes 3 components
     % tenen una matriu de 6x6 de coeficients de denominador i numerador (SOS) a
     % més d'un vector de Guanys.
     % En la matriu filtersSOS, estan ordenats els coeficients dels filtres
     % de manera que filtersSOS{1,1} son els coefis del LP, filtersSOS{1,2}
     % son els del BP i filtersSOS{1,3} son els del HP.
     % Per a tindre el filtre ja posat amb els seus guanys cal fer el
     % producte del guany amb els coeficients dels filtres.
     [SOS_LP,SOS_BP,SOS_HP] = freqResponseGlobal(param(1),param(2),param(3));
     audioOUT_HP = sosfilt(SOS_HP, audioIN);
     audioOUT_BP = sosfilt(SOS_BP, audioIN);
     audioOUT_LP = sosfilt(SOS_LP, audioIN);
     audioOUT = audioOUT_LP + audioOUT_BP + audioOUT_HP;
     audioRep(audioIN,audioOUT);
     soundsc(audioOUT,44100);
 elseif strcmpi(effect,'reverb')
     audioOUT = reverb(audioIN,param(1),param(2));
     soundsc(audioOUT,44100);
     audioRep(audioIN,audioOUT);
 else
 end
end