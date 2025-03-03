function [ber, numBits] = qam_3(EbNo, maxNumErrs, maxNumBits)
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

% bit rate  o  frequencia de bit
Rb = 1000;

% freqüencia de simbol
fs = Rb/k;

% temps de bit
tm=1/Rb;

% simbols de la constelacio
constel_symb = [1,-1,1i,-1i];

% Quantitat de simbols
M = length(constel_symb);

% bits corresponents a cada simbol de la constelacio
constel_bits = ['00';'01';'10';'11'];

% quantitat de bits per trama
nbitsBloc =  1*10^4;

% relacio senyal-interferencia en dB: -3dB
SI = -3;

% frequencia central de la interferencia sinusoidal
fo = fs/8;

% --- INSERT YOUR CODE HERE.

% potencia de constel·lació
Ps = mean(abs(constel_symb).^2);

% temps de la sinusoidal
t=(0:(nbitsBloc-1))*tm;

% amplitud de la interferencia
A = sqrt(2*Ps/(10^(-SI/10)));



% interferencia sinusoidal
interferencia = A*sin(2*pi*fo*t);

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

    txSig = txBb;
    
    % potencia soroll
    Pn = Ps/(EbNo*k);
    
    % generem vector soroll gaussià
    Soroll = sqrt(Pn/2)*(randn(1,nbitsBloc)+1i*randn(1,nbitsBloc)); 
    
    % sumem soroll, interferencia i senyal per enviar
    rxSig = Soroll + interferencia + txSig;

    % detSym es la senyal rebuda, demodulada i decodificada
    [detSym_idx,nerrors] = demodqam(rxSig,constel_symb,constel_bits,txSymb);

    % errors per trama sumant tots els bits diferents enviats als rebuts
    totErr = totErr + nerrors;
    
    numBits = nbitsBloc + numBits;
    
end % End of loop

% Compute the BER.
ber = totErr/numBits;
