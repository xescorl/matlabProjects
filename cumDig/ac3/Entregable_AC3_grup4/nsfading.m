function [y,w] = nsfading(x,fs,dopplerFreq,noisePower)
%[y,w] = nsfading(x,fs,dopplerFreq,noisePower)
%   Aquesta funci� simula un canal amb esva�ments no selectius en
%   freq��ncia amb una cert ample de banda Doppler (dopplerFreq en Hz) i
%   suposant que el senyal discret d'entrada (x) est� mostrejat a fs
%   mostres per segon. Tamb� afegeix soroll blanc i Gaussi� incorrelat en
%   components I i Q, amb una pot�ncia de soroll d'entrada noisePower.
%   genera a la seva sortida el senyal y de la mateixa longitud que el
%   transm�s x. La funci� retorna tamb� els coeficients d'esva�ment
%   aplicats sobre el senyal en el vector w.
transp_flag = false;
if size(x,1)>size(x,2)
    transp_flag = true;
    x = transpose(x);
end
Lx = length(x);
Lf = ceil(Lx*(dopplerFreq/(fs/2)));
wI = resample((randn(1,Lf) + j*randn(1,Lf)),fs/2,dopplerFreq);
wI = wI(1:Lx);
wI = wI/sqrt(mean(abs(wI).^2));
wQ = resample((randn(1,Lf) + j*randn(1,Lf)),fs/2,dopplerFreq);
wQ = wQ(1:Lx);
wI = wQ/sqrt(mean(abs(wQ).^2));
w = wI + j*wQ;
w = w/sqrt(mean(abs(w).^2));
y = x.*w + sqrt(noisePower/2)*(randn(size(x)) + j*randn(size(x)));
if transp_flag
    y = transpose(y);
    w = transpose(w);
end
end

