function [ber, numBits] = simula_AC3_b(EbNo, maxNumErrs, maxNumBits)
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

% frequencia de transmissio (bitrate)
Rb = 180*10^3;

% frequencia de canvi 
dopplerFreq = 50;

% profunditat de la descodificacio
tbdepth = 5000;

% bits per simbol QAM; per cada kQAM bits d'entrada traiem nQAM simbols, per
% lo tant redueix la freqüencia de simbol
kQAM = 3;
nQAM = 1;

% nº d'etapes de K bits del registre del codificador convolucional
% codis optims on k son bits d'entrada al codificador i n son els de sortida:
% [k/n,K]= [1/2,3][1/2,4][1/2,5][1/2,6][1/2,7]...
% [k/n,K]= [1/3,3][1/3,4][1/3,5][1/3,6][1/3,7]
K = 3;
kconv = 1;
nconv = 3;

% estructura del diagrama de trellis, entra un bit de 
% poly2trellis(memoria o retards,[suma bits]);
trellis = poly2trellis(K,[7 6 6]);

% frequencia de simbol
fs = Rb*(nQAM/kQAM)*(nconv/kconv);

% simbols de la constelacio
Vu = sqrt(2)/2;
constel_symb = [2,Vu+1i*Vu,-Vu+1i*Vu,2i,Vu-1i*Vu,-2i,-2,-Vu-1i*Vu];
% Quantitat de simbols
M = length(constel_symb);

% bits corresponents a cada simbol de la constelacio
constel_bits_str = ['000';'001';'010';'011';'100';'101';'110';'111'];
constel_bits_mat = [0 0 0;0 0 1;0 1 0;0 1 1;1 0 0;1 0 1;1 1 0;1 1 1];

% quantitat de bits per trama ideals
nbitsBloc =  1*10^4;

% Com fem una codificació on n nombres passen a ser n*M*(n/k) nombres per la QAM
% si volem simular nbitsBloc cada cop, hem de dividir el nombre de nombres
% aleatoris que fem entre M*(n/k), ja que despés els multiplicarem per M*(n/k) al
% codificar, sabent que en aquest codi (n/k) = 3/1
nRands = fix(nbitsBloc/(kQAM*kconv))*kQAM*kconv;

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

    % cadena de numeros entre 1 i M de "nRands"
    txSymb = randi([0 1],1,nRands*(kconv/nconv)*(kQAM/nQAM));
    
    % CODIFICAR:
    
    % CODI CONVOLUCIONAL
       
    % codifiquem la trama de bits a enviar txSymb ha de tindre una
    % llargària múltiple de el nombre de bits per trama (kConv o kQAM)
    % a l'entrada afegim el codi mes (K-1)*k zeros
    txConv = convenc([txSymb zeros(1,(K-1)*kconv)], trellis);

    % QAM:

    % De binari (cada 3 bits) a índex de la constelacio
    dataIndex = bin2dec2(txConv,constel_bits_str);

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

    % detSym es la senyal rebuda, demodulada i decodificada
    % retorna els bits detectats (detBits)
    [detSym_idx,detBits,nerrors] = demodqam2(eqSig, constel_symb, constel_bits_mat, dataIndex);

    % descodifiquem convolucional
    % si utilitzem term i hard, ens dona igual tbdepth, pero hem afegit
    % una cua de (K-1)*k zeros a txSymb, la qual hem de treure a l'hora de
    % comparar
    % rxDesConv = vitdec(eqSig,trellis,tbdepth,'term','hard');
    rxDesConv = vitdec(detBits,trellis,tbdepth,'term','hard');

    % comparem la trama d'entrada amb la de sortida:
    nerrors = biterr(txSymb,rxDesConv(1:length(rxDesConv)-(K-1)*kconv));

    % errors per trama sumant tots els bits diferents enviats als rebuts
    totErr = totErr + nerrors;
    
    numBits = nRands*(kconv/nconv)*(kQAM/nQAM) + numBits;
    
end % End of loop

% Compute the BER.
ber = totErr/numBits;
