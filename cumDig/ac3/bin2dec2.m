function [idx] = bin2dec2(data,constel_bits)
%[idx] = bin2dec2(data,k)
%   Retorna un vector amb els �ndex decimals corresponents al vector binari
%   d'entrada data llegit de k en k bits, considerant els mapats del vector
%   constel_bits (matriu de 2^k per k car�cters 1s o 0s amb la
%   correspon�ncia entre el s�mbol n-essim i els bits constel_bits(n,:)).
%   data ha de tenir un n�mero m�ltiple de k bits.
%
% J.C. Socor� - La Salle, Abril 2020

M = size(constel_bits,1);   % N�mero de s�mbols
k = log2(M);               % N�mero de bits per s�mbol

if (mod(length(data),k) ~= 0)
    error('data ha de ser un vector de longitud m�ltiple de k bits')
end
bits = unique(data);
if (length(bits) == 1)
    if (bits(1) ~= 0)&(bits(1) ~= 1)
        error('data ha de ser un vector de 0''s i 1''s')
    end
elseif (length(bits) == 2)
    if ((bits(1) ~= 0)&(bits(1) ~= 1))|((bits(2) ~= 0)&(bits(2) ~= 1))
        error('data ha de ser un vector de 0''s i 1''s')
    end
elseif (length(bits) >2)
    error('data ha de ser un vector de 0''s i 1''s')
end

% Creem el vector de mapat d'�ndex de s�mbols segons constel_bits
map_sym = zeros(1,M);
for n = 1:M
    for m = 1:k
        map_sym(n) =  map_sym(n) + str2num(constel_bits(n,m))*2^(m-1);
    end
end
% Creem el vector de mapat invers
inv_map = zeros(1,M);
for n = 1:M
    inv_map(n) = find(map_sym == n-1);
end


idx = zeros(1,length(data)/k);
for n = 1:(length(data)/k)
    idx(n) = inv_map(sum(data(((n-1)*k+1):((n-1)*k+k)).*(2.^(0:(k-1))))+1);
end

