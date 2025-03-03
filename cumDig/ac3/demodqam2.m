function [detSym_idx,detBits,nerrors] = demodqam2(rxSig,constel_symb,constel_bits,txSymb)
% [detSym_idx,nerrors] = demodqam(rxSig,constel_symb,constel_bits,txSymb)
% 
% Demodulació QAM del vector de mostres rebut rxSig (complex) usant la
% constel·lació definida pel vector constel_symb i les combinacions de bits
% definides a la matriu constel_bits. constel_symb és un vector de longitud
% M (ordre de la modulació), mentre que constel_bits és una matriu de
% caràcters de M files i k = log2(M) columnes, a on per la i-esima fila es
% defineix la combinació de bits associada al símbol
% constel_symb(i).
%
% detSym_idx és un vector amb els índex dels símbols detectats de la
% mateixa longitud N que rxSig, mentre que detBits és un vector de longitud
% N*k amb els bits dels símbols detectats.
%
% Si es passa l'argument txSymb aquest ha de ser un vector de la mateixa 
% longitud que rxSig amb els índex dels símbols transmesos (entre 1 i M),
% de forma que la funció també retorna a l'argument nerrors el número total
% de bits erronis de la trama de símbols rebuts.
%
% J.C. Socoró - La Salle, Abril 2020

% Fem que rxSig sigui un vector fila
if size(rxSig,1)>size(rxSig,2)
    rxSig = transpose(rxSig);
end
% Fem que constel_symb sigui un vector columna
if size(constel_symb,1)<size(constel_symb,2)
    constel_symb = transpose(constel_symb);
end

M = length(constel_symb);
nSymbolsBloc = length(txSymb);
distances = abs(ones(M,1)*rxSig - constel_symb*ones(1,nSymbolsBloc));
[~,detSym_idx] = min(distances,[],1);

if (nargin > 3)
    nerrors = 0;
    for i = 1:nSymbolsBloc
        nerrors = nerrors + sum(abs(constel_bits(txSymb(i),:)-constel_bits(detSym_idx(i),:)));
    end
end


ks = log2(M);  % Número de bits per símbol
detBits = zeros(1,length(detSym_idx)*ks);
for n = 1:length(detSym_idx)
    for k = 1:ks
        detBits((n-1)*ks+k) = constel_bits(detSym_idx(n),k);
    end
end

