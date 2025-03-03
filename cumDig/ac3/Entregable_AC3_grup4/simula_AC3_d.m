function [ber, numBits] = simula_AC3_d(EbNo, maxNumErrs, maxNumBits)
%BERTOOLTEMPLATE Template for a BERTool simulation function.
%   This file is a template for a BERTool-compatible simulation function.
%   To use the template, insert your own code in the places marked "INSERT
%   YOUR CODE HERE" and save the result as a file on your MATLAB path. Then
%   use the Monte Carlo panel of BERTool to execute the script.
%
%   [BER, NUMBITS] = YOURFUNCTION(EBNO, MAXNUMERRS, MAXNUMBITS) simulates a
%   communication system's error rate performance. EBNO is a vector of
%   Eb/No values, MAXNUMERRS is the maximum number of errors to collect
%   before stopping, and MAXNUMBITS is the maximum number of bits to run
%   before stopping.  BER is the computed bit error rate, and NUMBITS is
%   the actual number of bits run. 
%
%   For more information about this template and an example that uses it,
%   see the Communications Toolbox documentation.
%
%   See also BERTOOL, VITERBISIM.

% Copyright 2020-2021 The MathWorks, Inc.

narginchk(3,3)

% ==== DO NOT MODIFY if you intend to generate MEX file with MATLAB Coder. ====
% ==== Otherwise, you can remove the following two lines. ====
%#codegen
coder.extrinsic('isBERToolSimulationStopped')
% ==== END of DO NOT MODIFY ====

% Initialize variables related to exit criteria.
totErr  = 0; % Number of errors observed
numBits = 0; % Number of bits processed

% --- Set up parameters. ---

% quantitat de bits per trama ideals a passar pel canal
nbitsBloc =  1*10^4;

% frequencia de transmissio (bitrate)
Rb = 180*10^3;

% frequencia de canvi 
dopplerFreq = 50;

% Generar codis, amb diferents longituds i mateixa capacitat de correccio i al reves
% on n=>2 n = 2^m -1 i K = n-m
m = 3;

% Generem num bits sortida
nHam = 2^m - 1;

% Generem num bits entrada, només pot seguir aquesta formula
kHam = nHam-m;

% bits per simbol QAM; per cada kQAM bits d'entrada traiem nQAM simbols, per
% lo tant redueix la freqüencia de simbol nQAM = 2log(M) on M = length(constel_bits)
kQAM = 3;
nQAM = 1;

% nº d'etapes de K bits del registre del codificador convolucional
% codis optims on k son bits d'entrada al codificador i n son els de sortida:
% [k/n,K]= [1/2,3][1/2,4][1/2,5][1/2,6][1/2,7]...
% [k/n,K]= [1/3,3][1/3,4][1/3,5][1/3,6][1/3,7]
K = 3;
kconv = 1;
nconv = 3;

% Com fem una codificació on n nombres passen a ser n(n/*k) nombres per la QAM
% si volem simular nbitsBloc cada cop, hem de dividir el nombre de nombres
% aleatoris que fem entre M*(n/k), ja que despés els multiplicarem per M*(n/k) al
% codificar, sabent que en aquest codi (n/k) = 3/1

% bits aleatoris generats per a passat nbitsBloc pel canal
nRands = fix(fix(fix(nbitsBloc/(nHam/kHam))/(nconv/kconv))/(nQAM/kQAM));

% bits que passen pel canal
bitsSimulats = fix(fix(fix(nbitsBloc/(nHam/kHam))/(nconv/kconv))/(nQAM/kQAM))*(nHam/kHam)*(nconv/kconv)*(nQAM/kQAM);

% profunditat de la descodificacio
tbdepth = 5000;

% estructura del diagrama de trellis, entra un bit de 
% poly2trellis(memoria o retards,[suma bits]);
trellis = poly2trellis(K,[7 6 6]);

% frequencia de simbol
fs = Rb*(nQAM/kQAM)*(nconv/kconv)*(nHam/kHam);

% simbols de la constelacio
Vu = sqrt(2)/2;
constel_symb = [2,Vu+1i*Vu,-Vu+1i*Vu,2i,Vu-1i*Vu,-2i,-2,-Vu-1i*Vu];

% bits corresponents a cada simbol de la constelacio
constel_bits_str = ['000';'001';'010';'011';'100';'101';'110';'111'];
constel_bits_mat = [0 0 0;0 0 1;0 1 0;0 1 1;1 0 0;1 0 1;1 1 0;1 1 1];

% dimensió del bloc aleatori per a l'interleaving (profunditat de l'entrellaçat) 
% es el vector de permutacions aleatories (no es repeteixen) per a generar
% el mapat d'un sistema d'entrellaçat aleatori
% marca cada quan reordenem les mostres
L1 = (nRands*(nHam/kHam));
blocAleatori1 = randperm(L1);
L2 = (nRands*(nHam/kHam)+((K-1)*kconv))*(nconv/kconv);
blocAleatori2 = randperm(L2);

% --- INSERT YOUR CODE HERE.

% potencia de constel·lació
Ps = mean(abs(constel_symb).^2);

% Simulate until number of errors exceeds maxNumErrs
% or number of bits processed exceeds maxNumBits.
while((totErr < maxNumErrs) && (numBits < maxNumBits))
    % Check if the user clicked the Stop button of BERTool.
    % ==== DO NOT MODIFY ====
    if isBERToolSimulationStopped()
        break
    end
    % ==== END of DO NOT MODIFY ====
  
    % --- Proceed with simulation.
    % --- Be sure to update totErr and numBits.
    % --- INSERT YOUR CODE HERE.

    % GENERAR INFORMACIÓ A ENVIAR:

    % cadena de numeros entre 0 i 1 de "nRands"
    txSymb = randi([0 1],1,nRands);

    % CODIFICAR:

    % CODI DE BLOC:

    % passem d'un vector de dades a una matriu de nRands/kHam per kHam
    data = reshape(txSymb,[],kHam);

    % codifiquem
    encodedDataHAM = encode(data,nHam,kHam,'hamming/binary');

    % INTERLEAVING 1:

    % passem d'una matriu de nRands/kHam per kHam a un vector de nRands*(nHam/kHam)
    intrlv1Data = transpose(encodedDataHAM(:));
    intrlv1Data = intrlv(intrlv1Data, blocAleatori1);

    % CODI CONVOLUCIONAL:
       
    % codifiquem la trama de bits a enviar txSymb ha de tindre una
    % llargària múltiple de el nombre de bits per trama (kConv o kQAM)
    % a l'entrada afegim el codi mes (K-1)*k zeros
    txConv = convenc([intrlv1Data zeros(1,(K-1)*kconv)], trellis);

    % INTERLEAVING 2:
    txIntrlv2 = intrlv(txConv, blocAleatori2);

    % QAM:

    % De binari (cada 3 bits) a índex de la constelacio
    dataIndex = bin2dec2(txIntrlv2,constel_bits_str);

    % de nombres a simbols de constel·lació (real + imaginari)
    txBb = constel_symb(dataIndex);

    % generem senyal a enviar
    txSig = txBb;
   
    % ENVIAMENT:

    % potencia soroll
    noisePower = Ps/(EbNo*kQAM);
    
    % passem el senyal a enviar per un canal no selectiu en frequencia on 
    % txSig es el senyal transmès en banda base, fs la frequencia de
    % mostratge= simbols/segon, noisePower es la potencia del soroll blanc
    % gaussià
    % fs depèn de la velocitat de bit despres d'afegir redundancia i els
    % bit per simbol (k) de la QAM de torn (3 si 8QAM)
    % wf son els coeficients de fading, es un vector de complexos, el modul
    % daquests afecta a l'amplitud i largument a la fase.
    [rxSig,wf] = nsfading(txSig, fs, dopplerFreq, noisePower);
    
    % REBUDA:

    % compensem el fading en el canal (equalitzem). Assumint que el fading
    % es txSig*wf, aquesta compensació provoca que el soroll s'accentui de
    % senyal i mes errors de desmodulacio en periodes amb fading
    eqSig = rxSig./wf;

    % DEMOD QAM:

    % detSym es la senyal rebuda, demodulada i decodificada
    % retorna els bits detectats (detBits)
    [detSym_idx,detBits,nerrors] = demodqam2(eqSig, constel_symb, constel_bits_mat, dataIndex);
    % DEINTERLEAVING 2:

    RxdeInterlv2 = deintrlv(detBits,blocAleatori2);

    % DECOD CONV:

    % descodifiquem convolucional
    % si utilitzem term i hard, ens dona igual tbdepth, pero hem afegit
    % una cua de (K-1)*k zeros a txSymb, la qual hem de treure a l'hora de
    % comparar
    % rxDesConv = vitdec(eqSig,trellis,tbdepth,'term','hard');
    rxDesConv = vitdec(RxdeInterlv2,trellis,tbdepth,'term','hard');

    % DEINTERLEAVING 1:

    % de pas treiem la cua de (K-1)*kconv zeros
    RxdeInterlv1 = deintrlv(rxDesConv(1:length(rxDesConv)-(K-1)*kconv),blocAleatori1);

    % DECODIFICACIO DE BLOC:

    % convertim el vector rebut en una matriu de nRands/kHam,kHam
    encodedDataOutHAM = reshape(RxdeInterlv1,[],nHam);

    % Decodifiquem les dades obtingudes
    decodedDataOutHAM = decode(encodedDataOutHAM,nHam,kHam,'hamming/binary');

    % ERROR CHECK:

    % Comprovem bits erronis afegim valors
    errorsTotals = biterr(txSymb,transpose(decodedDataOutHAM(:)));

    % errors per trama sumant tots els bits diferents enviats als rebuts
    totErr = totErr + errorsTotals;
    
    numBits = nRands + numBits;
    
end % End of loop

% Compute the BER.
ber = totErr/numBits;
