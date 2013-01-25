%%%%% funzione che calcola l'attenuazione totale dei pixel dell'area presa in considerazione %%%%%

function [attenuazione_suppl_dB,attenuazione_fs_dB,attenuazione_tot_dB]=calcolo_attenuazione(area,he,hu,f,dim_pixel,xe,ye)  

%%%%% Ingressi %%%%%
% area       			area in esame
% he         			altezza dell'elicottero
% hu         			altezza dell'utente
% f          			frequenza utilizzata
% dim_pixel  			dimensione dei pixel
% xe ye      			coordinate posizione elicottero 
% ostacoli              matrice ostacoli

%%%%% Uscite %%%%%
% attenuazione_suppl_dB   	matrice che tiene conto dell'attenuzione supplementare da diffrazione nei vari pixel dell'area
% attenuazione_fs_dB      	matrice che tiene conto dell'attenuzione da spazio libero nei vari pixel dell'area
% attenuazione_tot_dB     	matrice che tiene conto dell'attenuzione totale (fs e suppl) nei vari pixel dell'area

disp(['posizione elicottero xe=' num2str(xe) '  ye=' num2str(ye)]);
dim_area=size(area);            %% dimensione matrice area
%disp(['ostacoli=' ostacoli]);
%dim_ostacoli=size(ostacoli);   	%% dimensione matrice ostacoli
c=3*10^8;                       %% velocita' della luce

%% preallocazione delle matrici
attenuazione_fs_dB=zeros(dim_area(1),dim_area(2));        %locale
attenuazione_suppl_dB=zeros(dim_area(1),dim_area(2));     %locale
attenuazione_tot_dB=zeros(dim_area(1),dim_area(2));       %locale

hr=he-hu;       %altezza relativa tra utente e elicottero

%% calcolo attenuazione nei pixel
for xu=1:dim_area(2)         	%% ciclo per far spostare l utente
    for yu=1:dim_area(1)   	%% ciclo per far spostare l utente
        
        %calcolo attenuazione spazio libero
        %disp('calcolo attenuazione spazio libero ');
        
        d3=dim_pixel*sqrt((xe-xu)^2+(ye-(-yu))^2);     	%% proiezione a terra della distanza tra utente e elicottero 
        
        dfs=sqrt(d3^2+hr^2);         			%% distanza tra utente e elicottero
        Afs_lin=((4*pi*dfs*f)/c)^2;  			%% attenuazione spazio libero lineare
        Afs=10*log10(Afs_lin);       			%% attenuazione spazio libero in dB
        attenuazione_fs_dB(yu,xu)=Afs;     		%% attenuazione spazio libero
              
        % disp(['iterazione ' num2str(xu) ' su ' num2str(yu)]);
        
        % procedura per determinare quali ostacoli si trovano tra l'utente e l'elicottero (si determinano le coordinate delgli ostacoli) 
        if(area(yu,xu)==0)   %posizione consentita
            
            attenuazione_tot_dB(yu,xu)=Afs;    		%attenuazione totale nella posizione dell'utente presa in considerazione
            
            %operazioni per determinare la presenza di ostacoli
            if (xe==xu)
                yo=min((-yu),ye):max((-yu),ye);     
                xo=ones(1,length(yo))*xu;
            else
                coeff_ang=((-yu)-ye)/(xu-xe);  		%coefficiente angolare della retta passante per i punti delle posizioni dell'elicottero e dell'utente
                %alfa=atand(coeff_ang);     		%angolo che forma la retta
                %campionamento=0.9/(tand(alfa))
                campionamento=0.9/coeff_ang; 		%valore massimo di campionamento affinché si possano controllare tutti i pixel su cui passa la retta
                passo=min(abs(campionamento),0.24);
                x=min(xu,xe):passo:max(xu,xe);  	%si determinano le coordinate x e y
                y=((x-xe)/(xu-xe))*(-yu-ye)+ye;
                xo=round(x);    			%coordinata x arrotondata all'intero più vicino
                yo=round(y);    			%coordinata y arrotondata all'intero più vicino 
            end
            
            yoc=-yo;        				%coordinata y cambiata di segno per lavorare con le matrici
                
            index_linear=yoc+(xo-1)*dim_area(1);       	%indicizzazione della matrice, altro metodo : index_linear=sub2ind(size(area),yoc,xo);
            ost_in=area(index_linear);             	%manda in uscita i valori degli elementi di area in corrispondenza delle coordinate xo e yoc

            [RI,CO,AM]=find(ost_in);     		%trovo i valori differenti da zero in 'ost_in, e ottengo informazioni riguradanti la riga, colonna e valore dell'elemento
            xu1=ones(length(RI),1)*xu;           	%creo i vettori xu1, yu1 i quali portano l'informazione della coordinata dell'utente da inserire poi nella matrice ost
            yu1=ones(length(RI),1)*(-yu);
            xo1=xo(CO);       				%xo1, yo1, vettori che contengono le coordinate dell'ostacolo
            yo1=yo(CO);
            
            ost=[xu1,yu1,AM',xo1',yo1'];   		%matrice che contiene la posizione dell' utente in esame, dei rispettivi ostacoli e l'ampiezza,ripetuti pi� volte (provvisoria)
            
            if(xu>xe || (xu==xe && (-yu)>ye))   	%serve per far poi calcolare l'attenuazione sempre dall'utente verso l'elicottero
                ost=flipud(ost);
            end
            %ost
            
            if(ost~=0)   				%sono presenti ostacoli
                           
               %eliminazione righe doppie matrice ost
               ost_=[0,0,0,0,0;ost];  			%creo la matrice da sottrarre ad ost per eliminare le righe doppie
               ost_(end,:)=[];      			%si elimina l'ultima riga che � di troppo
               sottr=ost-ost_;       			%si effettua la sottrazione
               [righe,~,~]=find(sottr);   		%si memorizzano le righe nelle quali c'� almeno un numero diverso da zero
               righe=unique(righe);    			%si eliminano gli indici doppi
               ost2=ost(righe,:);     			%si crea la matrice con gli ostacoli
                       
               %ost2
               dim_ost2=size(ost2);     		%dimensione della matrice ost2
               ostfin2=ost(1,:);        		%inizializzazione matrice ostfin2, conterr� la posizione degli ostacoli, se gli ostacoli occupano pi� pixel si avr� la media
                       
               o=1;    					%variabili di controllo
               g=1;
               for m=2:dim_ost2(1)
                   if ((ost2(m,3)==ost2((m-1),3)) && ((ost2(m,4)==(ost2((m-1),4)+1)) ||(ost2(m,4)==(ost2((m-1),4)-1)) || (ost2(m,5)==(ost2((m-1),5)+1)) || (ost2(m,5)==(ost2((m-1),5)-1))))     %%condizione che controlla se l'ampiezza dell'ostacolo � la stessa del precedente e se fanno parte dello stesso ostacolo
                       o=o+1;     			%contatore di controllo
                       xcf=ost2(m,4);     		%coordinate finali dell'ostacolo necessaria per calcolare la posizione media 
                       ycf=ost2(m,5);
                       if(m==dim_ost2(1))
                          xci=ostfin2((end),4);      	%coordinate di inizio ostacolo per calcolare la posizione media
                          yci=ostfin2((end),5);
                          ostfin2((end),4)=(xcf+xci)/2; %si calcola la posizione media dell'ostacolo e si inserisce nella matrice
                          ostfin2((end),5)=(ycf+yci)/2;
                       end
                   else    
                       ostfin2=[ostfin2;ost2(m,:)];     %si inseriscono nella matrice ostfin2 i parametri relativi al nuovo ostacolo
                       g=0;     			%variabile di controllo che indica che � stato individuato un nuovo ostacolo
                   end
                   if (g==0 && o>1)
                       xci=ostfin2((end-1),4);      	%coordinate di inizio ostacolo per calcolare la posizione media
                       yci=ostfin2((end-1),5);
                       ostfin2((end-1),4)=(xcf+xci)/2;  %si calcola la posizione media dell'ostacolo e si inserisce nella matrice
                       ostfin2((end-1),5)=(ycf+yci)/2;
                       o=1;    				%reset dei contatore
                   end
                   g=1;     				%reset dei contatore
               end
             
               %ostfin2
               dim_ostfin2=size(ostfin2); 		%dimensione della matrice ostfin2, il # di righe indicano quanti sono gli ostacoli
               %disp(['dim ostfin' dim_ostfin2]);
               
               %procedura per selezionare solo gli ostacoli pi� fastidiosi,
               %si calcola il fattore v nel caso che l'ostacolo sia l'unico
               %e si valuta quanto posa la sua attenuazione
               v_selez=zeros(1,dim_ostfin2(1));              %preallocazione delle variabili
               ostfin5=zeros(dim_ostfin2(1),dim_ostfin2(2));
              
               for N=1:dim_ostfin2(1)       %calcolo dei fattori v
                   [~,~,~,~,~,v]=calcolo_v(xu,(-yu),ostfin2(N,4),ostfin2(N,5),xe,ye,hu,ostfin2(N,3),he,f,dim_pixel);
                   v_selez(1,N)=v;
               end
                           
               v_selez4=flipud(v_selez');  %si inverte l'ordine di v e degli ostacoli per una questione di calcolo
               ostfin4=flipud(ostfin2);
               m=1;   % variabile di controllo
               b=0;   % contatore per selezionare alla fine gli ostacolo giusti
               for M=1:dim_ostfin2(1) 
                   if (v_selez4(M)<-20 && m==1) % si selezionano gli ostacoli che hanno v>-20 e tutti quelli anche con v pi� bassi che si trovano tra di essi
                       b=M;
                   else
                       m=2;
                   end
               end
               if b~=dim_ostfin2(1) % serve per non avere errori
                  ostfin5=ostfin4(b+1:end,:); % si crea il vettore degli ostacoli significativi ma invertiti di ordine
               end
               
               ostfin2=flipud(ostfin5);    %memorizzo gli ostacoli finali
                   
               dim_ostfin2=size(ostfin2); %dimensione della matrice ostfin2
               
               %calcolo dell'attenuazione supplementare da diffrazione
               if(ostfin2~=0)   %sono presenti ostacoli significativi
                  %calcolo attenuazione supplementare da diffrazione 
                  v_vett=zeros(1,dim_ostfin2(1));
                  
                  %disp('calcolo attenuazione supplementare da diffrazione ');
                  if(dim_ostfin2(1)==1)    %caso di singolo ostacolo (approssimato ad una lama di coltello)
                     %disp('caso di singolo ostacolo approssimato ad una lama di coltello ');
                     xua=ostfin2(1,1);      %coordinate utente 
                     yua=ostfin2(1,2);
                     xoa=ostfin2(1,4);      %coordinate ostacolo lama di coltello
                     yoa=ostfin2(1,5);
                     hoa=ostfin2(1,3);     %altezza dell'ostacolo
                   
                     [~,~,~,~,~,v]=calcolo_v(xua,yua,xoa,yoa,xe,ye,hu,hoa,he,f,dim_pixel);
                     v_vett=v;
                  
                  else    %caso di ostacolo multiplo, calcolo del parametro v con il metodo epstein-peterson
                     %disp('caso di ostacolo multiplo, calcolo dell attenuazione con il metodo epstein-peterson');
                     %disp(['ostacolo n�1 su ' num2str(dim_ostfin2(1))]);
                                 
                     xua=ostfin2(1,1);      %coordinate utente
                     yua=ostfin2(1,2);
                     xoa=ostfin2(1,4);      %coordinate ostacolo lama di coltello
                     yoa=ostfin2(1,5);
                     hoa=ostfin2(1,3);      %altezza dell'ostacolo
                     xea=ostfin2(2,4);      %coordinate elicottero teorico
                     yea=ostfin2(2,5);   
                     hea=ostfin2(2,3);      %altezza dell'elicottero teorico
               
                     [~,~,~,~,~,v]=calcolo_v(xua,yua,xoa,yoa,xea,yea,hu,hoa,hea,f,dim_pixel);
                     v_vett(1)=v;
                  
                     for p=2:dim_ostfin2(1)
                         if(p==dim_ostfin2(1))
                            %disp(['ultimo ostacolo (n�' num2str(p) ')']);
                            xua=ostfin2((p-1),4);   %coordinate dell'utente teorico
                            yua=ostfin2((p-1),5);
                            hua=ostfin2((p-1),3);  %altezza dell'utente teorico
                            xoa=ostfin2(p,4);      %coordinate ostacolo lama di coltello
                            yoa=ostfin2(p,5);
                            hoa=ostfin2(p,3);      %altezza dell'ostacolo
                      
                            [~,~,~,~,~,v]=calcolo_v(xua,yua,xoa,yoa,xe,ye,hua,hoa,he,f,dim_pixel);
                            v_vett(p)=v;
                         
                         else
                            %disp(['ostacolo n�' num2str(p) ' su ' num2str(dim_ostfin2(1))]);
                            xua=ostfin2((p-1),4);   %coordinate dell'utente teorico
                            yua=ostfin2((p-1),5);
                            hua=ostfin2((p-1),3); %altezza dell'utente teorico
                            xoa=ostfin2(p,4);      %coordinate ostacolo lama di coltello
                            yoa=ostfin2(p,5);
                            hoa=ostfin2(p,3);      %altezza dell'ostacolo
                            xea=ostfin2((p+1),4);      %coordinate elicottero teorico
                            yea=ostfin2((p+1),5);   
                            hea=ostfin2((p+1),3);      %altezza dell'elicottero teorico
                 
                            [~,~,~,~,~,v]=calcolo_v(xua,yua,xoa,yoa,xea,yea,hua,hoa,hea,f,dim_pixel);
                            v_vett(p)=v;
                          
                         end
                     end
                  end
                  [att_tot]=calcolo_fresnel(v_vett);   %calcolo attenuazione supplementare
                  attenuazione_suppl_dB(yu,xu)=attenuazione_suppl_dB(yu,xu)+att_tot;  %attenuazione supplementare nella posizione dell'utente presa in considerazione
                  attenuazione_tot_dB(yu,xu)=attenuazione_tot_dB(yu,xu)+att_tot;   %attenuazione spazio libero e attenuazione supplementare posizionata nella posizione dell'utente presa in considerazione
                     
               else
                   %disp('posizione con zero attenuazione supplementare');
               end
            end
        else
            %disp('posizione dell utente non valida');
        end
        
   end
end


