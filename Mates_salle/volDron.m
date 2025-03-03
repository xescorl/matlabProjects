function VolDron(x_inicial,y_inicial,z_inicial,boca,alfa)
format long
imax = input('Iteracions màximes: ')
tol = input('Tolerància gradient: ')
pos = [];
mes = [];
MAX = 51;
posX = x_inicial;
posY = y_inicial;
posZ = z_inicial;
if (2 <= x_inicial && x_inicial<=MAX-1) || (2 <= y_inicial && y_inicial <= MAX-1) || (2 <= z_inicial && z_inicial <= MAX-1)
    auxX = x_inicial;
    auxY = y_inicial;
    auxZ = z_inicial;
   else
    disp('els valors han destar entre 2 i 50')
  end        
 Gradient = [];
 j = 0;
 posFin = [];
 for i = 1:imax
   infoGas = mesura_gasos(posX,posY,posZ,boca);
   x1 = infoGas(1);
   x2 = infoGas(2);
   y1 = infoGas(3);
   y2 = infoGas(4);
   z1 = infoGas(5);
   z2 = infoGas(6);
    Gradx = (x2 - x1)/2;
    Grady = (y2 - y1)/2;
    Gradz = (z2 - z1)/2;
     auxX = auxX + alfa*Gradx;
     auxY = auxY + alfa*Grady;
     auxZ = auxZ + alfa*Gradz;
     posX = round(auxX + alfa*Gradx);
     posY = round(auxY + alfa*Grady);
     posZ = round(auxZ + alfa*Gradz);
       if (2 <= auxX && auxX <= MAX-1) || (2 <= auxY && auxY <= MAX-1) || (2 <= auxZ && auxZ <= MAX-1)
       else
       disp('els valors han destar entre 2 i 50')
       break;
       end     
       if j > 10
           if (abs(pos(1,j) - pos(1,j-1)) + abs(pos(2,j) - pos(2,j-1)) + abs(pos(2,j) - pos(2,j-1))) < tol 
               disp(['El dron ha arribat a la boca ',num2str(boca)])
             break;
           end
       end
         Gradient = [Gradient,[Gradx;Grady;Gradz]];
         pos = [pos, [auxX;auxY;auxZ]];
         mes = [mes,[(infoGas(1) + infoGas(2) + infoGas(3) + infoGas(4) + infoGas(5) + infoGas(6))/6]];
         j = j + 1;
 end
  max = mes(j);
  min = mes(1);
  n = [];
  hold on
  view(3)
  for w = 2:j-1
     n = (mes(w) + 0.000001-min)./(max-min);
      plot3(pos(1,w),pos(2,w),pos(3,w),'-bo','MarkerEdgeColor','g','MarkerFaceColor','yellow','MarkerSize',8.*n)
  end
  box on
  grid on

  plot3(pos(1,1),pos(2,1),pos(3,1),'-bo','MarkerEdgeColor','g','MarkerFaceColor','yellow','MarkerSize',8.*n(1))
  text(x_inicial,y_inicial,z_inicial,['    ', num2str(mes(1))])

  plot3(pos(1,end),pos(2,end),pos(3,end),'-bo','MarkerEdgeColor','g','MarkerFaceColor','yellow','MarkerSize',8)
  text(auxX,auxY,auxZ,['     ', num2str(mes(j))])

  posFin = [auxX;auxY;auxZ];
  concentracio_gassos = (infoGas(1)+infoGas(2)+infoGas(3)+infoGas(4)+infoGas(5)+infoGas(6))/6;

  disp('--------------- RESULTATS -----------------')
  disp(['Iteracions: ',num2str(j)])
  disp(['Posicio de la boca ',num2str(boca), ' es:'])
  disp(pos(:,end))
  disp(['Concentracio de gasos en la boca ',num2str(boca),' es ', num2str(concentracio_gassos)])
 
  if boca == 1
      gasmaxreal = mesura_gasos(30,38,25,1);
      gasmaxdron = (infoGas(1) + infoGas(2) + infoGas(3) + infoGas(4) + infoGas(5) + infoGas(6))/6;
      err = abs((gasmaxreal-gasmaxdron)/gasmaxreal)*100;
      disp(['El error daproximacio es ',num2str(err),' %'])
  else
      gasmaxreal = mesura_gasos(29,37,24,2);
      gasmaxdron = (infoGas(1) + infoGas(2) + infoGas(3) + infoGas(4) + infoGas(5) + infoGas(6))/6;
      err = abs((gasmaxreal - gasmaxdron)/gasmaxreal)*100;
      disp(['El error daproximacio es ',num2str(err),' %'])
  end
     
  save('mesures')
  save('posicions')
 
end