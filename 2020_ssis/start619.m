function start619

% Versió 4 de 1R2011a, 2013
%******
% És pel cas en que es posi en un mateix directori el programa start619 i
% la carpeta Lab619. D'aquesta manera no ens hem de preocupar de cap canvi
% de path. Simplement ens hem de posar a MATLAB en el directori que conté
% start619 (i Lab619) i executar start619.

path_619=cd;

%if ispc, ba='\'; else ba='/'; end
ba=filesep;
path(path,path_619);
path(path,[path_619,ba,'Lab619',ba,'dades']);
path(path,[path_619,ba,'Lab619',ba,'dades',ba,'usuari']);
path(path,[path_619,ba,'Lab619',ba,'pracnou']);
path(path,[path_619,ba,'Lab619',ba,'pracajud']);
path(path,[path_619,ba,'Lab619',ba,'prac1nou']);
path(path,[path_619,ba,'Lab619',ba,'prac2nou']);
path(path,[path_619,ba,'Lab619',ba,'prac3nou']);
path(path,[path_619,ba,'Lab619',ba,'prac4nou']);
path(path,[path_619,ba,'Lab619',ba,'prac5nou']);
path(path,[path_619,ba,'Lab619',ba,'prac6nou']);
path(path,[path_619,ba,'Lab619',ba,'sis']);

cd([path_619,ba,'Lab619',ba,'pracajud'])
%******

set(0,'DefaultUiControlFontName','arial','DefaultUiControlFontSize',8,'DefaultUiControlFontWeight','bold')

figfills=get(0,'children');
hies=0;
for i=1:length(figfills),
    nom=get(figfills(i),'name');
    if strcmp(nom,'619:  Simulacions Digitals de Senyals i Sistemes Analògics')||strcmp(nom,'619:  Simulaciones Digitales de Señales y Sistemas Analógicos')||strcmp(nom,'619:  Digital Simulations of Analog Signals and Systems')
    hies=figfills(i); break
    end
end
if hies
    set(hies,'visible','on')
else
    close all
    [f,a,b,m]=funobrir('fig0sis1v2'); 
    set(m(2),'callback',['close,clear all,cd(''',path_619,''')'])
    set(f,'currentaxes',a(1)),text(0.005,0.05,'Grup de processament del senyal. Dept. TSC - UPC');
    set(b,'backgroundcolor',get(0,'defaultuicontrolbackgroundcolor'))
    maxposicio(f)
    if exist('idiomaxdefecte.mat','file')==2
        load idiomaxdefecte
        idifig0v2(idioma)
        hmE=findobj('label','&English');
        set(hmE,'userdata','')
        set(get(hmE,'parent'),'userdata',idioma)
    end
    set(f,'visible','on','keypress','gcf;','delete',['clear all,cd(''',path_619,''')']);
end

