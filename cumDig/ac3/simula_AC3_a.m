function [ber, numBits] = simula_AC3_a(EbNo, maxNumErrs, maxNumBits)
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
% ha de ser divisible pels bits per simbol (k) per a poder calcular el
% baudrate
Rb = 180*10^3;

% frequencia de canvi 
dopplerFreq = 50;

% bits per simbol
k = 3;

% frequencia de simbol
fs = Rb/k;

% simbols de la constelacio
Vu = sqrt(2)/2;
constel_symb = [2,Vu+1i*Vu,-Vu+1i*Vu,2i,Vu-1i*Vu,-2i,-2,-Vu-1i*Vu];
% Quantitat de simbols
M = length(constel_symb);

% bits corresponents a cada simbol de la constelacio
constel_bits = ['000';'001';'010';'011';'100';'101';'110';'111'];

% quantitat de bits per trama ideals
nbitsBloc =  1*10^4;

% Com fem una codificació on n nombres passen a ser n*k nombres per la QAM
% si volem simular nbitsBloc cada cop, hem de dividir el nombre de nombres
% aleatoris que fem entre k, ja que despés els multiplicarem per k al
% codificar
nRands = fix(nbitsBloc/k)*k;


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

    % cadena de numeros de nRands
    data = randi([0 1],1,nRands);

    % CODIFICAR:

    % De binari (cada 3 bits) a índex de la constelacio
    dataIndex = bin2dec2(data,constel_bits);

    % de nombres a simbols de constel·lació (real + imaginari)
    txBb = constel_symb(dataIndex);

    % generem senyal a enviar
    txSig = txBb;
    
    % potencia soroll
    noisePower = Ps/(EbNo*k);
    
    % passem el senyal a enviar per un canal no selectiu en frequencia on 
    % txSig es el senyal transmès en banda base, fs la frequencia de
    % mostratge= simbols/segon, noisePower es la potencia del soroll blanc
    % gaussià
    % fs depèn de la velocitat de bit despres d'afegir redundancia i els
    % bit per simbol (k) de la QAM de torn (3 si 8QAM)
    % wf son els coeficients de fading, es un vector de complexos, el modul
    % daquests afecta a l'amplitud i largument a la fase.
    [rxSig,wf] = nsfading(txSig, fs, dopplerFreq, noisePower);
    
    % compensem el fading en el canal (equalitzem). Assumint que el fading
    % es txSig*wf, aquesta compensació provoca que el soroll s'accentui de
    % senyal i mes errors de desmodulacio en periodes amb fading
    eqSig = rxSig./wf;
    
    % detSym es la senyal rebuda, demodulada i decodificada
    % retorna els bits detectats (detBits)

    [detSym_idx,detBits,nerrors] = demodqam2(eqSig, constel_symb, constel_bits, dataIndex);
    % errors per trama sumant tots els bits diferents enviats als rebuts
    totErr = totErr + nerrors;
    
    numBits = nRands + numBits;
    
end % End of loop

% Compute the BER.
ber = totErr/numBits;
