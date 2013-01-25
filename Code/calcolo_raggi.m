%%%%% funzione che calcola il raggio medio e il valore del raggio al variare dell'angolo %%%%%

function [Raggio_medio,Raggio_percentile,Raggi_40k]=calcolo_raggi(attenuazione_tot_dB,Att_max,dim_pixel,xe,ye)

%%%%% Ingressi %%%%%
% attenuazione_tot_dB  	area con attenuazione totale
% Att_max              	attenuazione massima tollerabile
% dim_pixel            	dimensione pixel
% xe, ye               	coordinate dell'elicottero
% he                   	altezza dell'elicottero

%%%%% Variabili di prova %%%%%
% attenuazione_tot_dB=[0,0,0,0,1,1,0,0,0,0;
% 0,0,0,1,1,1,1,0,0,0;
% 0,0,1,1,1,1,1,1,0,0;
% 0,1,1,1,1,1,1,1,1,0;
% 1,1,1,1,1,1,1,1,1,1;
% 0,1,1,1,1,1,1,1,1,0;
% 0,0,1,1,1,1,1,1,0,0;
% 0,0,0,1,1,1,1,0,0,0;
% 0,0,0,0,1,1,0,0,0,0;
% 0,0,0,0,0,0,0,0,0,0];
% Att_max=0.5;
% dim_pixel=3;
% xe=5;
% ye=5;
% he=10;

%%%%% Uscite %%%%%
% Raggio_360_medio   	raggio medio di copertura
% Raggi_360          	matrice che contiene i raggi al variare dell'angolo

%% metodo border %%
% dim_attenuazione = size(attenuazione_tot_dB);
% macchia = zeros(dim_attenuazione(1), dim_attenuazione(2));
% macchia = (attenuazione_tot_dB < Att_max) & (attenuazione_tot_dB > 0);
% disp('macchia');
% disp(macchia);
% A=logical(macchia);                             % matrice logica che rappresenta la zona coperta dal segnale nell'area
% border=getborder(A,'inside');                   % matrice contenente solo il bordo di quella di sopra
% disp('border');
% disp(border);
% 
% [row,col]=find(border);
% elements=zeros(2,size(row));
% for i=1:size(row),
%     elements(1,i)=row(i);                       % elementi di bordo
%     elements(2,i)=col(i);                       % elementi di bordo
%     disp([num2str(elements(1,i)),',', num2str(elements(2,i))]);
% end
% 
% Raggi_360=zeros(size(row));
% 
% for i = 1:size(row)
%     Raggi_360(i) = dim_pixel*sqrt((elements(1,i)-xe)^2+(elements(2,i)-ye)^2);
% end
% 
% 
% Raggio_360_medio=mean(Raggi_360);
% disp(Raggio_360_medio);

%% ogni elemento %%

Raggi_40k = zeros(200,200);
for i = 1:200
    for j = 1:200
        if attenuazione_tot_dB(i,j) > 0 && attenuazione_tot_dB(i,j) < Att_max
            Raggi_40k(i,j) = dim_pixel*sqrt((i-xe)^2+(j-ye)^2);
        end
    end
end

disp('Raggi_40k');
disp(Raggi_40k);

[~,~,medio] = find(Raggi_40k);
Raggio_medio = mean(medio);

disp('Raggio_medio');
disp(Raggio_medio);

[~,~,percentile] = find(Raggi_40k);
Raggio_percentile = prctile(percentile,80);

disp('Raggio_percentile');
disp(Raggio_percentile);