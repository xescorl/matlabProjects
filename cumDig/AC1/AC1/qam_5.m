function [ber, numBits] = qam_4(EbNo, maxNumErrs, maxNumBits)
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

% bits per simbol
k = 2;
Rb = 1000;
fs = Rb/k;
fo = fs/8;
tm = 1/Rb;


% simbols de la constelacio
constel_symb = [1,-1,1i,-1i];

% Quantitat de simbols
M = length(constel_symb);

% bits corresponents a cada simbol de la constelacio
constel_bits = ['00';'01';'10';'11'];

% quantitat de bits per trama
nbitsBloc =  1*10^4;

% longitud sequencia semi-aleatoria
xips = 16;
N = (xips^2) -1;
SI = -3;

% --- INSERT YOUR CODE HERE.
% generem sequencia semi aleatoria
PN = mls(N,'ExcitationLevel',0);
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

    % cadena de numeros entre 1 i M de "nbitsBloc"
    txSymb = randi([1 M],1,nbitsBloc);

    % CODIFICAR:

    % de nombres a simbols de constel·lació
    txBb = constel_symb(txSymb);


    
    % potencia soroll
    Pn = N*Ps/(EbNo*k);
    
    % eixamplem i generem senyal a enviar
    % Inicialitzem un vector de 0’s
    txSig = zeros(length(txBb)*N,1);
    % Cada N mostres posem un símbol
    txSig(1:N:end) = txBb; 
    % Cada símbol es multiplicarà per la seqüència PN
    txSig = filter(PN,1,txSig);
    txSig = transpose(txSig);
    
    % generem vector soroll gaussià
    Soroll = sqrt(Pn/2)*(randn(1,length(txSig))+1i*randn(1,length(txSig))); 
    mult = 1/Rb;
    t=(0:(length(txSig)-1))*mult;
        
    % amplitud de la interferencia
    A = 2*Ps/(10^(SI/10));

    % interferencia sinusoidal
    interferencia = A*sin(2*pi*fo*t);

    % sumem soroll i constel·lacio
    rxSig = txSig + Soroll + interferencia;
    
    %demodular receptor ds ss
    % detSym es la senyal rebuda, demodulada i decodificada
    demSig = filter(PN(end:-1:1)/N,1,rxSig);
    demSig = demSig(N:N:end);
    
    [detSym_idx,nerrors] = demodqam(demSig,constel_symb,constel_bits,txSymb);%demsig en comptes de rxSig

    % errors per trama sumant tots els bits diferents enviats als rebuts
    totErr = totErr + nerrors;
    
    numBits = nbitsBloc + numBits;
    
end % End of loop

% Compute the BER.
ber = totErr/numBits;
