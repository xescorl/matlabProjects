 %% ex1 finestra cuadrada amb un Acos(2*pi*fo*t)
 clear all
f=0:0.1:3000;
A=1;T=0.02;f0=500;

X=T*(A/2)*sinc((f-f0)*T)+T*(A/2)*sinc((f+f0)*T);
Y=T*(A/2)*sinc((f-f0)*T);
 plot(f,abs(X),'r',f,abs(Y),'b')
%% ex1 finestra triangular amb un Acos(2*pi*fo*t)
clear all
f=0:0.1:3000;
A=1;T=0.02;f0=500;

X=(T/2)*(A/2)*sinc((f-f0)*(T/2)).*sinc((f-f0)*(T/2)) + (T/2)*(A/2)*sinc((f+f0)*(T/2)).*sinc((f+f0)*(T/2));
Y=(T/2)*(A/2)*sinc((f-f0)*(T/2)).*sinc((f-f0)*(T/2));
 plot(f,abs(X),'r',f,abs(Y),'b')
 %% ex2 finestra cuadrada amb un Acos(2*pi*fo*t)+Bcos(2*pi*f1*t)
 clear all
f=0:0.1:3000;
%%A=1;B=0.8;T=0.02;f0=500;f1=1500;

%%X=T*(A/2)*sinc((f-f0)*T)+T*(A/2)*sinc((f+f0)*T)+T*(B/2)*sinc((f-f1)*T)+T*(B/2)*sinc((f+f1)*T);
%%Y=T*(A/2)*sinc((f-f0)*T)+T*(B/2)*sinc((f-f1)*T);
T = 0.1; f0=1000;
X = 0.5*(T*sinc(T*(f-f0)).*exp(-j*pi*T*(f-f0))+T*sinc(T*(f+f0)).*exp(-j*pi*T*(f+f0)));
Y = 0.5*(T*sinc(T*(f-f0))+T*sinc(T*(f+f0)));
 plot(f,abs(X),'r',f,abs(Y),'b')
%% ex2 finestra triangular amb un Acos(2*pi*fo*t)+Bcos(2*pi*f1*t)
clear all
f=0:0.1:3000;
A=1;B=0.8;T=0.02;f0=500;f1=1500;

X=(T/2)*(A/2)*sinc((f-f0)*(T/2)).*sinc((f-f0)*(T/2)) + (T/2)*(A/2)*sinc((f+f0)*(T/2)).*sinc((f+f0)*(T/2))+(T/2)*(B/2)*sinc((f-f1)*(T/2)).*sinc((f-f1)*(T/2)) + (T/2)*(B/2)*sinc((f+f1)*(T/2)).*sinc((f+f1)*(T/2));
Y=(T/2)*(A/2)*sinc((f-f0)*(T/2)).*sinc((f-f0)*(T/2))+(T/2)*(B/2)*sinc((f-f1)*(T/2)).*sinc((f-f1)*(T/2));
 plot(f,abs(X),'r',f,abs(Y),'b')
  %% ex2 finestra cuadrada amb un Acos(2*pi*fo*t)+Bcos(2*pi*f1*t) pero f1 i f0 diferents
clear all
f=0:0.1:3000;
A=1;B=0.8;T=0.02;f0=500;f1=650;
%T=0.04;

X=T*(A/2)*sinc((f-f0)*T)+T*(A/2)*sinc((f+f0)*T)+T*(B/2)*sinc((f-f1)*T)+T*(B/2)*sinc((f+f1)*T);
Y=T*(A/2)*sinc((f-f0)*T)+T*(B/2)*sinc((f-f1)*T);
 plot(f,abs(X),'r',f,abs(Y),'b')
%% ex2 finestra triangular amb un Acos(2*pi*fo*t)+Bcos(2*pi*f1*t) pero f1 i f0 diferents
clear all
f=0:0.1:3000;
A=1;B=0.8;T=0.02;f0=500;f1=650;
%T=0.04;

X=(T/2)*(A/2)*sinc((f-f0)*(T/2)).*sinc((f-f0)*(T/2)) + (T/2)*(A/2)*sinc((f+f0)*(T/2)).*sinc((f+f0)*(T/2))+(T/2)*(B/2)*sinc((f-f1)*(T/2)).*sinc((f-f1)*(T/2)) + (T/2)*(B/2)*sinc((f+f1)*(T/2)).*sinc((f+f1)*(T/2));
Y=(T/2)*(A/2)*sinc((f-f0)*(T/2)).*sinc((f-f0)*(T/2))+(T/2)*(B/2)*sinc((f-f1)*(T/2)).*sinc((f-f1)*(T/2));
 plot(f,abs(X),'r',f,abs(Y),'b')