function [detSym_idx,nerrors] = demodqam(rxSig,constel_symb,constel_bits,txSymb)
% [detSym_idx,nerrors] = demodqam(rxSig,constel_symb,constel_bits,txSymb)
% 
% Demodulaci� QAM del vector de mostres rebut rxSig (complex) usant la
% constel�laci� definida pel vector constel_symb i les combinacions de bits
% definides a la matriu constel_bits. constel_symb �s un vector de longitud
% M (ordre de la modulaci�), mentre que constel_bits �s una matriu de
% car�cters de M files i k = log2(M) columnes, a on per la i-esima fila es
% defineix la combinaci� de bits associada al s�mbol constel_symb(i).
%
% Si es passa l'argument txSymb aquest ha de ser un vector de ma mateixa 
% longitud que rxSig amb els �ndex dels s�mbols transmesos (entre 1 i M),
% de forma que la funci� tamb� retorna a l'argument nerrors el n�mero total
% de bits erronis de la trama de s�mbols rebuts.
%
% J.C. Socor� - La Salle, Febrer 2020

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
end

