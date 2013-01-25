%%%%% funzione che calcola il raggio medio e il valore del raggio al variare dell'angolo %%%%%

function [Raggio_360_medio,Raggi_360]=calcolo_raggi(attenuazione_tot_dB,Att_max,dim_pixel,xe,ye,he)

%%%%% Ingressi %%%%%
% attenuazione_tot_dB  	area con attenuazione totale
% Att_max              	attenuazione massima tollerabile
% dim_pixel            	dimensione pixel
% xe, ye               	coordinate dell'elicottero
% he                   	altezza dell'elicottero

%%%%% Uscite %%%%%
% Raggio_360_medio   	raggio medio di copertura
% Raggi_360          	matrice che contiene i raggi al variare dell'angolo


g=0;     							% contatore matrice Raggi_360
Raggi_360=zeros(360,4); 					% inizializzazione matrice

%%%%% Variabili Di Prova %%%%%
% beta=38;
% attenuazione_tot_dB=[0.7413    0.6878    0.2703    0.3774    0.8620    0.7900    0.1476    0.0005    0.5747    0.8908;
%                      0.5201    0.3592    0.1971    0.2160    0.9899    0.3185    0.0550    0.8654    0.8452    0.9823;
%                      0.3477    0.7363    0.8217    0.7904    0.5144    0.5341    0.8507    0.6126    0.7386    0.7690;
%                      0.1500    0.3947    0.4299    0.9493    0.8843    0.0900    0.5606    0.9900    0.5860    0.5814;
%                      0.5861    0.6834    0.8878    0.3276    0.5880    0.1117    0.9296    0.5277    0.2467    0.9283;
%                      0.2621    0.7040    0.3912    0.6713    0.1548    0.1363    0.6967    0.4795    0.6664    0.5801;
%                      0.0445    0.4423    0.7691    0.4386    0.1999    0.6787    0.5828    0.8013    0.0835    0.0170;
%                      0.7549    0.0196    0.3968    0.8335    0.4070    0.4952    0.8154    0.2278    0.6260    0.1209;
%                      0.2428    0.3309    0.8085    0.7689    0.7487    0.1897    0.8790    0.4981    0.6609    0.8627;
%                      0.4424    0.4243    0.7551    0.1673    0.8256    0.4950    0.9889    0.9009    0.7298    0.4843];
% Att_max=0.5;
% dim_pixel=3;
% dim_area=size(attenuazione_tot_dB);
% xe=round(dim_area(2)/2);
% ye=round(dim_area(1)/2);
% he=10;
% disp(['coordinate: xe=' num2str(xe) ' ye=' num2str(ye)]);

for beta=0:359
    if beta==90 
       yo=ye:(-1);     
       xo=ones(1,length(yo))*xe; 
       %disp('beta=90');
    elseif beta==270
           yo=(-(size(attenuazione_tot_dB,1))):ye;     
           xo=ones(1,length(yo))*xe;
           %disp('beta=270');
    else   
       m=tand(beta);
       campionamento=0.9/m; 					% valore massimo di campionamento affinch� si possano controllare tutti i pixel su cui passa la retta
       passo=min(abs(campionamento),0.24);
              
       if (beta>=315 || beta<=45)
            %disp('beta>=315 o beta<=45')
            x=xe:passo:size(attenuazione_tot_dB,1);  		% si determinano le coordinate x e y
            y=m*(x-xe)+ye;
       elseif (beta>45 && beta<=135)
           %disp('45<beta<=135')
            y=ye:passo:-1;
            x=(y-ye)/m+xe;
       elseif (beta>135 && beta<=225)
           % disp('135<beta<=225')
            x=1:passo:xe;
            y=m*(x-xe)+ye;
       elseif (beta>225 && beta<=315)
           % disp('225<beta<=315')
            y=(-size(attenuazione_tot_dB,1)):passo:ye;
            x=(y-ye)/m+xe;
       end
       xo=round(x);    						% coordinata x arrotondata all'intero pi� vicino
       yo=round(y);    						% coordinata y arrotondata all'intero pi� vicino  
    end
    
    if(beta>270 || beta<=90)   					% serve per posizionare gli ostacoli sempre in ordine dall'utente verso l'elicottero
        xpr=flipud(xo');
        ypr=flipud(yo');
        xo=xpr';
        yo=ypr';
    end
    yoc=-yo;        						% coordinata y cambiata di segno per lavorare con le matrici
                
    index_linear=yoc+(xo-1)*size(attenuazione_tot_dB,1);  	% indicizzazione della matrice, altro metodo : index_linear=sub2ind(size(area),yoc,xo);
    attenua=attenuazione_tot_dB(index_linear);             	% manda in uscita i valori degli elementi di attenuazione_tot_dB in corrispondenza delle coordinate xo e yoc

    [~,CO,AM]=find(attenua);    				% trovo i valori differenti da zero in 'attenua', e ottengo informazioni riguradanti la riga, colonna e valore dell'elemento
   
    xa=xo(CO);       						% xo1, yo1, vettori che contengono le coordinate del pixel con attenuazione
    ya=yo(CO);
    attenua_prov=[xa',ya',AM']; 				% matrice che contiene il raggio, l'ampiezza e le coordinate dei pixel con attenuazione,ripetuti pi� volte (provvisoria)

    [riga,~]=find(attenua_prov(:,3)<=Att_max);  		% si selezionano solo i pixel che hanno attenuazione minore o uguale a Att_max
    attenua_prov1=attenua_prov(riga,:);    
    d=dim_pixel*sqrt((xe-attenua_prov1(:,1)).^2+(ye-attenua_prov1(:,2)).^2);
    
    attenua_prov2=[d,attenua_prov1];   				% matrice che contiene il raggio, l'ampiezza e le coordinate dei pixel con attenuazione,ripetuti pi� volte (provvisoria)
    
    %eliminazione righe doppie matrice attenua_prov
    attenuazione_=[0,0,0,0;attenua_prov2];  			% creo la matrice da sottrarre ad attenua_prov per eliminare le righe doppie
    attenuazione_(end,:)=[];      				% si elimina l'ultima riga che � di troppo
    sottr=attenua_prov2-attenuazione_;       			% si effettua la sottrazione
    [righe,~,~]=find(sottr);   					% si memorizzano le righe nelle quali c'� almeno un numero diverso da zero
    righe=unique(righe);    					% si eliminano gli indici doppi
    raggi_attenuazione=attenua_prov2(righe,:);  		% si crea la matrice con i pixel di attenuazione
    
    dim_raggi_attenuazione=size(raggi_attenuazione);
    %si determina il pixel con attenuazione maggiore (tra quelli con
    %attenuazione minore di Att_max) e si memorizza il raggio relativo
     if(dim_raggi_attenuazione(1)~=0)
        
       [riga23,~]=find(raggi_attenuazione(:,4)>(Att_max-0.5));  % si memorizzano le righe della matrice corrispondenti ai pixel con attenuazione maggiore di Att_max-0.5
       piu_raggi=raggi_attenuazione(riga23,:);  		% si memorizzano le righe
       dim_piu_raggi=size(piu_raggi);   			% dimensione della matrice piu_raggi
       if(dim_piu_raggi~=0)
           if(dim_piu_raggi(1)~=1)  				% se ci sono pi� di un pixel nella matrice per i quali l'attenuazione � compresa tra Att_max e Att_max-0.5 si fa la media
              piu_raggi_medio=sum(piu_raggi)/dim_piu_raggi(1); 	% media tra i raggi
              g=g+1;   						% incremento il contatore della matrice Raggi_360 necessaria a memorizzare tutti i pixel per il 360�
              Raggi_360(g,:)=piu_raggi_medio;  			% matrice che memorizza tutti i raggi corrispondenti alle attenuazioni massime per tutti i 360�
           else
              g=g+1;   						% incremento il contatore della matrice Raggi_360 necessaria a memorizzare tutti i pixel per il 360�
              Raggi_360(g,:)=piu_raggi;  			% matrice che memorizza tutti i raggi corrispondenti alle attenuazioni massime per tutti i 360�
           end
       else
           att_massima=max(raggi_attenuazione(:,4));  		% determino il pixel con attenuazione massima
           [RIGA,~]=find(raggi_attenuazione(:,4)==att_massima); % determino il numero della riga in cui � memorizzato il pixel con attenuazione massima
           raggio_att=raggi_attenuazione(RIGA,:);    		% memorizzo le caratteristiche del pixel
           g=g+1;   						% incremento il contatore della matrice Raggi_360 necessaria a memorizzare tutti i pixel per il 360�
           Raggi_360(g,:)=raggio_att;  				% matrice che memorizza tutti i raggi corrispondenti alle attenuazioni massime per tutti i 360�
          % disp(['per beta=' num2str(beta) ' il raggio � ' num2str(raggio_att(1)) 'm']);   
       end   
     else 
       g=g+1;   						% incremento il contatore della matrice Raggi_360 necessaria a memorizzare tutti i pixel per il 360�
       Raggi_360(g,:)=[0,0,0,0];  				% matrice che memorizza tutti i raggi corrispondenti alle attenuazioni massime per tutti i 360�
       % disp(['per beta=' num2str(beta) ' non ci sono pixel con attenuazione minore a ' num2str(Att_max)]);
    end
end

Raggi_tot=Raggi_360;   						% definisco la matrice Raggi_tot
righe_zero=find(Raggi_tot(:,1)==0);  				% trovo le righe nelle qualsi si ha raggio pari a zero
Raggi_tot(righe_zero,:)=[];   					% vengono eliminate le righe nelle quali il raggio � pari a zero
     
%eliminazione righe doppie matrice Raggi_tot
Raggi_=[0,0,0,0;Raggi_tot];  					% creo la matrice da sottrarre ad Raggi_360_1 per eliminare le righe doppie 
Raggi_(end,:)=[];      						% si elimina l'ultima riga che � di troppo
sottr1=Raggi_tot-Raggi_;       					% si effettua la sottrazione
[righe1,~,~]=find(sottr1);   					% si memorizzano le righe nelle quali c'� almeno un numero diverso da zero
righe1=unique(righe1);    					% si eliminano gli indici doppi
Raggi_360_1=Raggi_tot(righe1,:);     				% si crea la matrice dei raggi
   
if(size(righe_zero,1)~=0)   					% si hanno righe con raggi uguali a zero
   Raggi_360_1=[Raggi_360_1;Raggi_360(righe_zero,:)];    	% si inseriscono nuovamente le righe con raggio pari a zero per poi fare la media
   Raggio_360_medio=[he,(sum(Raggi_360_1(:,1))/size(Raggi_360_1,1))];
   disp(['il raggio medio � ' num2str(Raggio_360_medio(2))]);
elseif(size(righe_zero,1)==360)  				% tutti i raggi sono pari a zero
   Raggio_360_medio=[he,0];    					% il raggio medio � posto a zero
   disp(['il raggio medio � ' num2str(Raggio_360_medio(2))]);
else
   Raggio_360_medio=[he,(sum(Raggi_360_1(:,1))/size(Raggi_360_1,1))];
   disp(['il raggio medio � ' num2str(Raggio_360_medio(2))]);
end
