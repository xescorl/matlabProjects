function [idx] = bin2dec2(data,constel_bits)
%[idx] = bin2dec2(data,k)
%   Retorna un vector amb els índex decimals corresponents al vector binari
%   d'entrada data llegit de k en k bits, considerant els mapats del vector
%   constel_bits (matriu de 2^k per k caràcters 1s o 0s amb la
%   corresponència entre el símbol n-essim i els bits constel_bits(n,:)).
%   data ha de tenir un número múltiple de k bits.
%
% J.C. Socoró - La Salle, Abril 2020

M = size(constel_bits,1);   % Número de símbols
k = log2(M);               % Número de bits per símbol

if (mod(length(data),k) ~= 0)
    error('data ha de ser un vector de longitud múltiple de k bits')
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

% Creem el vector de mapat d'índex de símbols segons constel_bits
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

