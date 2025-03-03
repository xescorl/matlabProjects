% PREGUNTA 2:

[SOS_LP,G_LP,SOS_BP,G_BP,SOS_HP,G_HP] = retrieveSOS("filtersSOS.mat");

tiledlayout('horizontal')

nexttile
[z_LP,p_LP,k_LP] = sos2zp(SOS_LP*prod(G_LP));
zplane(z_LP,p_LP);
ylim([-1.5 1.5]);
xlim([-1.5 1.5]);
grid on

nexttile
[z_BP,p_BP,k_BP] = sos2zp(SOS_BP*prod(G_BP));
zplane(z_BP,p_BP);
ylim([-1.5 1.5]);
xlim([-1.5 1.5]);
grid on

nexttile
[z_LP,p_LP,k_LP] = sos2zp(SOS_HP*prod(G_HP));
zplane(z_LP,p_LP);
ylim([-1.5 1.5]);
xlim([-1.5 1.5]);
grid on