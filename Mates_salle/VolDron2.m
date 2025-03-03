function VolDron2(x_inici,y_inici,z_inici,boca,alfa)
format long
in1 = 'Iteracions màximes: ';
in2 = 'Tolerància gradient: ';
imax = input(in1)
tol = input(in2)
pos=[];
mes=[];
MAX_x=51;
MAX_y=51;
MAX_z=51;
posX=x_inici;
posY=y_inici;
posZ=z_inici;
if 2<=x_inici && x_inici<=MAX_x-1
    x_c=x_inici;
   else
    disp('els valors han destar entre 2 i 50')
 end
 if 2<=y_inici && y_inici<=MAX_y-1
     y_c=y_inici;
   else
    disp('els valors han destar entre 2 i 50')
 end
 
  if 2<=z_inici && z_inici<=MAX_z-1
      z_c=z_inici;
    else
    disp('ERROR, fora de rang')
  end        
 Grad =[];
 j=0;
 posicion_final=[];
 for i = 1:imax
   a = mesura_gasos(posX,posY,posZ,boca);
   x_1= a(1);
   x_2= a(2);
   y_1= a(3);
   y_2= a(4);
   z_1= a(5);
   z_2= a(6);
    Gradx = (x_2 - x_1)/2;
    Grady = (y_2 - y_1)/2;
    Gradz = (z_2 - z_1)/2;
%%% condicion de max pendiente
     x_c = x_c + alfa*Gradx;
     y_c = y_c + alfa*Grady;
     z_c = z_c + alfa*Gradz;
     posX = round(x_c + alfa*Gradx);
     posY = round(y_c + alfa*Grady);
     posZ = round(z_c + alfa*Gradz);
       if 2<=x_c && x_c<=MAX_x-1
       else
       disp('Fora de Rang');
        break;
       end
       if 2<= y_c && y_c<=MAX_y-1
       else
        disp('Fora de Rang')
         break;
       end
       if 2<=z_c && z_c<=MAX_z-1
       else
        disp('Fora de Rang')
        break;
       end
       if j>10
           if (abs(pos(1,j)-pos(1,j-1))+abs(pos(2,j)-pos(2,j-1))+abs(pos(2,j)-pos(2,j-1)))<tol
             text0=['Hemos llegado a la boca numero ',num2str(boca)];
             disp('----------------------------------------------------')
             disp(text0)
             disp('----------------------------------------------------')
             break;
           end
       end
         Grad = [Grad,[Gradx;Grady;Gradz]];
         pos = [pos, [x_c;y_c;z_c]];
         mes=[mes,[(a(1)+a(2)+a(3)+a(4)+a(5)+a(6))/6]];
         j=j+1;
 end
  Amax=mes(j);
  Amin=mes(1);
  n=[];
  hold on
  view(3)
  for w=2:j-1
     n=(mes(w)+0.000001-Amin)./(Amax-Amin);
      plot3(pos(1,w),pos(2,w),pos(3,w),'-bo','MarkerEdgeColor','r','MarkerFaceColor','blue','MarkerSize',8.*n)
  end
  box on
  grid on
  plot3(pos(1,1),pos(2,1),pos(3,1),'-bo','MarkerEdgeColor','r','MarkerFaceColor','blue','MarkerSize',8.*n(1))
  primero=['    ', num2str(mes(1))];
  txt = primero;
  text(x_inici,x_inici,z_inici,txt)
  plot3(pos(1,end),pos(2,end),pos(3,end),'-bo','MarkerEdgeColor','r','MarkerFaceColor','blue','MarkerSize',8)
  ultimo=['     ', num2str(mes(j))];
  txt = ultimo;
  text(x_c,y_c,z_c,txt)
  posicio_final=[x_c;y_c;z_c];
  concentracio_gassos=(a(1)+a(2)+a(3)+a(4)+a(5)+a(6))/6;
  text2=['El numero de iteraciones realizadas es ',num2str(j)];
  text3=['La posicion final de la boca ',num2str(boca), ' es:'];
  text4=['La concentracion de gases en la boca ',num2str(boca),' es ', num2str(concentracio_gassos)];
  disp('----------------------------------------------------')
  disp('--------- RESULTADOS DEL VUELO DEL DRON ------------')
  disp('----------------------------------------------------')
  disp(text2)
  disp('----------------------------------------------------')
  disp(text3)
  disp(pos(:,end))
  disp('----------------------------------------------------')
  disp(text4)
  disp('----------------------------------------------------')
  disp('----------------------------------------------------')
 
  if boca==1
      gasmaxreal=mesura_gasos(30,38,25,1);
      gasmaxdron=(a(1)+a(2)+a(3)+a(4)+a(5)+a(6))/6;
      error1=abs((gasmaxreal-gasmaxdron)/gasmaxreal)*100;
      text5=['El error de aproximación al valor real es del ',num2str(error1),' %'];
      disp(text5)
  else
      gasmaxreal=mesura_gasos(29,37,24,2);
      gasmaxdron=(a(1)+a(2)+a(3)+a(4)+a(5)+a(6))/6;
      error2=abs((gasmaxreal-gasmaxdron)/gasmaxreal)*100;
      text6=['El error de aproximación al valor real es del ',num2str(error2),' %'];
      disp(text6)
  end
     
  save('mesures')
  save('posicions')
 
end