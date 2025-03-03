function [XF] = DFT_mostra(x,n,F)
%  x i n són vectors AMB LA MATEIXA DIMENSIÓ
%  F pot ser tant escalar com vector. Si F és vector, XF serà vector
XF = 0;
for i = 1:length(n)
    XF = XF + x(i)*exp(-1i*2*pi*F*n(i));
end

end