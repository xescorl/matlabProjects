
%GENERAR VARIABLES GLOBALS

% bits totals a simular
bitsTotals = 4*10^6;

% bits per bloc a transmetre
bitsSimulats = 100000;

%Generar codis, amb diferents longituds i mateixa capacitat de correccio i al reves
%on n=>2 n = 2^m -1 i K = n-m
m = 3;

%Generem num bits sortida
nHam = 2^m - 1;

%Generem num bits entrada, només pot seguir aquesta formula
kHam = nHam-m;

%Generem k y n per linear
kLin = 2;
nLin = 8;

%Declarem m y t Salmó
%on n=>3 n = 2^m -1 i K = n-2t on t=capacitat de correccio 
%cantidad de bits de información en cada símbolo de la codificación.
m = 3;
t = 2;


%Generem num paraules sortida
nSal = 2^m - 1;

%Generem num paraules entrada, només pot seguir aquesta formula
kSal = nSal-2*t;


% Calculem les paraules per bloc, donats els bits per bloc simulats màxims
% (bitsSimulats) i el nombre de bits per paraula (k). Truncant el nombre
% (fix()).
nParaulesBlocHam = fix(100000/kHam);
nParaulesBlocLin = fix(100000/kLin);
nParaulesBlocSal = fix(100000/(m*kSal)); 

% Calculem els bits per bloc (nbitsBloc) amb les paraules per bloc (nParaulesBloc)
% i el nombre de bits per paraula (k).
nbitsBlocHam = (nParaulesBlocHam)*kHam;
nbitsBlocLin = (nParaulesBlocLin)*kLin;
nBitsBlocSal = (nParaulesBlocSal)*(m*kSal);

% Calculem el numero de blocs totals a transmetre amb els bits totals a
% simular (bitsTotals) i els bits per bloc (nbitsBloc), redondejant a la
% alça (ceil()).
blocsHam = ceil(bitsTotals/nbitsBlocHam);
blocsLin = ceil(bitsTotals/nbitsBlocLin);
blocsSal = ceil(bitsTotals/nBitsBlocSal);

% Calculem els bits totals simulats (bitsTotalsSimulatsHamming) amb els
% bits per bloc (nbitsBloc) i la quantitat de blocs transmesos
% (blocsHamming).
nBitsHam = nbitsBlocHam*blocsHam;
nBitsLin = nbitsBlocLin*blocsLin;
nBitsSal = nBitsBlocSal*blocsSal;

% Calculem el nombre total de paraules transmeses (paraulesTotals) amb les 
% paraules per bloc (nParaulesBloc) i el nombre de blocs transmesos (blocsHamming).
paraulesTotalsHam = nParaulesBlocHam*blocsHam;
paraulesTotalsLin = nParaulesBlocLin*blocsLin;
paraulesTotalsSal = nParaulesBlocSal*blocsSal;

% Generem Probabilitat d'error del canal
i = [0,1,2,3,4,5,6,7,8];
p = 10.^((i-16)/8);

% Cas Hamming
% Generem matriu generadora hamming i matriu de correcio de paritat
[Hh,Gh] = hammgen(m);

% Cas Lineal
% Generem matriu generadora lineal 8x2 extreta d'exercisi de la colecció.
Gl=[0 0 1 1 1 1 1 0;1 1 1 1 1 0 0 1];

% Generem matriu de correcio de paritat
%Hl = gen2par(Gl);

% Cas red salmon
% Generem el codificador i decodificador del salmó k = nombre de simbols
% d'entrada, n = nombre de simbols de sortida, m = bits per simbol
 rsEncoder = comm.RSEncoder('BitInput',true,'CodewordLength',nSal,'MessageLength',kSal);
 rsDecoder = comm.RSDecoder('BitInput',true,'CodewordLength',nSal,'MessageLength',kSal);

%Generem vectors per cada probabilitat d'error
pErrHAM = zeros(9,1); 
pErrLIN = zeros(9,1);
pErrSALMON = zeros(9,1);

%9 es el tamany del vector de probabilitat d'error
for pActual = 1:9
errHAM=0;
% loop de per transmetre les paraules
    for bloc = 1:blocsHam
        % Generem dades a transmetre per nombre de parules per bloc i bits per paraula
        data = randi([0 1],nParaulesBlocHam,kHam);
          
            % Codifiquem dades
            encodedDataHAM = encode(data,nHam,kHam,'hamming/binary');
            
            % Passem dades codificades per el canal (bsc())
            encodedDataOutHAM = bsc(encodedDataHAM,p(pActual));
            
            % Decodifiquem les dades obtingudes
            decodedDataOutHAM = decode(encodedDataOutHAM,nHam,kHam,'hamming/binary');
        
            % Comprovem bits erronis afegim valors
            errHAM =+ biterr(data,decodedDataOutHAM);
   
    end
    % Calculem probabilitat d'errror
        pErrHAM(pActual) = errHAM/nbitsBlocHam;
end

for pActual = 1:9
errLIN=0;
% loop de per transmetre les paraules
    for bloc = 1:blocsLin
        % Generem dades a transmetre per nombre de parules per bloc i bits per paraula
        data = randi([0 1],nParaulesBlocLin,kLin);
          
            % Codifiquem dades
            encodedDataLIN = encode(data,nLin,kLin,'linear/binary',Gl);
        
            % Passem dades codificades per el canal (bsc())
            encodedDataOutLIN = bsc(encodedDataLIN,p(pActual));
            
            % Decodifiquem les dades obtingudes
            decodedDataOutLIN = decode(encodedDataOutLIN,nLin,kLin,'linear/binary',Gl);
        
            % Comprovem bits erronis afegim valors
            errLIN =+ biterr(data,decodedDataOutLIN);
        
        
    end
    % Calculem probabilitat d'errror
        pErrLIN(pActual) = errLIN/nbitsBlocLin;

end



 

 for pActual = 1:9
     errSALMON=0;

 % loop de per transmetre les paraules
     for bloc = 1:blocsSal
         % Generem dades a transmetre per nombre de parules per bloc i bits per paraula
          dataSal = randi([0 1],nParaulesBlocSal*m*kSal,1);

           
             % Codifiquem dades
             
             encodedDataSALMON = step(rsEncoder,dataSal);
         
             % Passem dades codificades per el canal (bsc())
             
             [encodedDataOutSALMON, error] = bsc(encodedDataSALMON,p(pActual));
             
             % Decodifiquem les dades obtingudes(Podem veure a les captures de la memòria que funciona TANT PERFECTE que ens corretgeix tots els bits i per tant no tenim pErrSALMO...)
             
             decodedDataOutSALMON = step(rsDecoder,encodedDataOutSALMON);
         
             % Comprovem bits erronis afegim valors
             
             errSALMON =+ biterr(dataSal,decodedDataOutSALMON);
             numchanerrs = sum(sum(error));

         
     end
     
     % Calculem probabilitat d'errror
         pErrSALMON(pActual) = errSALMON/nBitsBlocSal;
 
 end

%Grafiquem
a = loglog(p, pErrHAM, p, pErrLIN,p, pErrSALMON);
a(1).Color="g";
a(1).Marker="o";
a(2).Color="b";
a(2).Marker="o";
a(3).Color="r";
a(3).Marker="o";

legend('Hamming/Binary (n,k)=(7,4)','Linear/Binary (n,k)=(8,2)','RS (n,k)=(7,3)');
xlabel("Chanel error probability");
ylabel("Chanel code error probability");
title('Resultats Simulació');
grid on;

