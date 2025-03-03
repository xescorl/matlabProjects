

 F=linspace(-0.5,0.5,2001);
 X = DFT_mostra(x,n,F);
figure; subplot(221), plot(F, abs(X))
grid, title('|X(F)| programada')
 subplot(223), plot(F, angle(X))
 grid, title('fase de X(F) programada')
 Xt= cos(2*pi*F)+2*cos(pi*F)+3/2;
 subplot(222), plot(F, abs(Xt))
 grid, title('|X(F)| teòric')
 subplot(224), plot(F, angle(Xt))
 vgrid, title('fase teòrica de X(F)')
 subplot(223), plot(F, unwrap(angle(X)))