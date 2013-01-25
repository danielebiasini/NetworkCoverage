%%%%% funzione che calcola l'attenuazione totale dei pixel dell'area presa in considerazione %%%%%

function [attenuazione_suppl_dB,attenuazione_fs_dB,attenuazione_tot_dB]=prova_attenuazione(area,mask_ost,he,f,dim_pixel,xe,ye)

%%%%% Ingressi %%%%%
% area       			area in esame
% mask_ost           maschera degli ostacoli
% he         			altezza dell'elicottero
% f          			frequenza utilizzata
% dim_pixel  			dimensione dei pixel
% xe ye      			coordinate posizione elicottero

%%%%% Uscite %%%%%
% attenuazione_suppl_dB   	matrice che tiene conto dell'attenuzione supplementare da diffrazione nei vari pixel dell'area
% attenuazione_fs_dB      	matrice che tiene conto dell'attenuzione da spazio libero nei vari pixel dell'area
% attenuazione_tot_dB     	matrice che tiene conto dell'attenuzione totale (fs e suppl) nei vari pixel dell'area

%%% Variabili di prova %%%
% ksam= imread('/home/daniele/Scrivania/MioMappa/dati/ColleOppio/mask.png');          						% matrice maschera degli ostacoli
% temp = ksam(:,:,1);                                                                                                             % prendo un colore tra r g b (è indifferente perché gli ostacoli sono colorati in nero quindi i valori sono 0 o 255)
% mask = flipud(temp);                                                                                                            % ribalto la matrice perché i programmi precedenti la stampano in modo errato
% ost = mask < 1;                                                                                                                 % la converto in matrice logica
% dem = load('/home/daniele/Scrivania/MioMappa/dati/ColleOppio/elevation.txt');           					% matrice di elevazione del terreno
%
% N = 200;                                                                                                                          % lato matrice
% area = zeros(N,N);                                                                                                                % preallocazione matrice
% xe = 100;
% ye = 100;
% dim_pixel = 5;
% f = 2.4*10^9;
% he = 100;

%
% for i = 1:randi([10 20]):N                                                                                                        % mi muovo a passi casuali per formare la lunghezza dell'ostacolo tra 10 e 20
%     for j = 1:randi([10 20]):N                                                                                                    % mi muovo a passi casuali per formare la larghezza dell'ostacolo tra 10 e 20
%         rand_h = randi([10 50]);                                                                                                  % altezza casuale dell'ostacolo
%         for h = 1:(N-i)                                                                                                           % interrompo il ciclo a N-i per non andare oltre i limiti della matrice
%             for k = 1:(N-j)                                                                                                       % interrompo il ciclo a N-j per non andare oltre i limiti della matrice
%                 area(i+h,j+k) = dem(i+h,j+k) + rand_h * ost(i+h,j+k);                                                      	% sommo la maschera con altezze random al dem
%             end
%         end
%     end
% end

attenuazione_fs_dB=zeros(200,200);        %locale
attenuazione_suppl_dB=zeros(200,200);     %locale
attenuazione_tot_dB=zeros(200,200);       %locale


c = 3*10^8;

for xu = 1:200
    for yu = 1:200
        
        if mask_ost(xu,yu) > 0   													% se c'è un ostacolo passo ad una nuova coordinata
            %attenuazione_fs_dB(xu,yu)=NaN;        
            %attenuazione_suppl_dB(xu,yu)=NaN;     
            %attenuazione_tot_dB(xu,yu)=NaN;       
            continue
        end
        
        ostacoli=zeros(3,300);
        k=2;
               
        %%% metodo a intervallini %%%
        passo = 0.2;                                                        % intervallo con il quale cerco gli ostacoli
        coeff = (ye-yu)/(xe-xu);                                   % coefficiente angolare della retta
        if coeff > -1 && coeff < +1
            if xe > xu
                x = xe:-passo:xu;
            end
            if xe < xu;
                x = xe:passo:xu;
            end
            y = yu + coeff*(x - xu);                                          % valori della y
        else
            if ye > yu
                y = ye:-passo:yu;
            end
            if ye < yu;
                y = ye:passo:yu;
            end
            x = xu + (1/coeff)*(y - yu);
        end
       
        
        temp = nan(2,500);                                          % inizializzo la matrice contenente la lista dei punti dove passa la retta
        for i = 1:length(x)
            temp(1,i) = fix(x(i));                                      % parte intera di x
            temp(2,i) = fix(y(i));                                      % parte intera di y
        end
        
        for nan_index=1:length(temp)
            if isnan(temp(1,nan_index))
                break;
            end
        end
        temp(:,nan_index:length(temp))=[];              % elimino i NaN restanti dalla matrice inizializzata
        
        [punti,~,~] = unique(temp','rows');                         % elimino i doppioni dalla matrice inizializzata
        
        punti_ordinati=flipud(punti);
        
        for i = 1:length(punti_ordinati)
            if i == 1
                ostacoli(:,i)=[xe, ye, he];
            end
            x0 = punti_ordinati(i,1);
            y0 = punti_ordinati(i,2);
            if mask_ost(x0,y0) == true
                
                % queste due equazioni sono state ricavate a mano, data una retta passante per due punti e un punto esterno,
                % permettono di ottenere le coordinate (x_pr, y_pr) della proiezione del punto sulla retta in funzione delle coordinate dei tre punti
                x_pr = ((y0-ye)*(yu-ye)*(xu-xe)+x0*(xu-xe)^2+xe*(yu-ye)^2)/((yu-ye)^2+(xu-xe)^2);
                y_pr = ye + (yu-ye)*((y0-ye)*(yu-ye)+(x0-xe)*(xu-xe))/( (yu-ye)^2+(xu-xe)^2);
                % memorizzo le coordinate dell'ostacolo proiettato sulla retta in una matrice [3 x #ostacoli]
                ostacoli(1,k) = x_pr;
                ostacoli(2,k) = y_pr;
                ostacoli(3,k) = area(x0,y0);
                k = k+1;
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        hu=area(xu,yu);
        
        %%% dimunisco il vettore ostacoli per non avere ostacoli doppi %%%
        ostacoli_lame=ostacoli(:,logical(diff(ostacoli(3,:))));
        utente=[xu,yu,hu];
        ostacoli_final = [ostacoli_lame utente'];
        
        vett_v=zeros(1,length(ostacoli_final)-2);
        
        hr=he-hu;       													% altezza relativa tra utente e elicottero
        d3=dim_pixel*sqrt((xe-xu)^2+(ye-(-yu))^2);     										% proiezione a terra della distanza tra utente e elicottero
        
        dfs=sqrt(d3^2+hr^2);         												% distanza tra utente e elicottero
        Afs_lin=((4*pi*dfs*f)/c)^2;  												% attenuazione spazio libero lineare
        Afs=10*log10(Afs_lin);       												% attenuazione spazio libero in dB
        attenuazione_fs_dB(xu,yu)=Afs;    											% attenuazione spazio libero
        attenuazione_tot_dB(xu,yu)=Afs; 											% attenuazione totale nella posizione dell'utente presa in considerazione
        dim_ostacoli_final = size(ostacoli_final);
        
        if dim_ostacoli_final(2) <= 2
            continue
        else
        
            for i = 2:length(ostacoli_final)-1
            
                %%%calcolo_v(xu,yu,xo,yo,xe,ye,hu,ho,he,f,dim_pixel)
                v = calcolo_v(ostacoli(1,i+1),ostacoli(2,i+1),ostacoli(1,i),ostacoli(2,i),ostacoli(1,i-1),ostacoli(2,i-1),ostacoli(3,i+1),ostacoli(3,i),ostacoli(3,i-1),f,dim_pixel);
                vett_v(i)=v;
            
            end
        
            [att_tot]=calcolo_fresnel(vett_v);   											% calcolo attenuazione supplementare
            %attenuazione_suppl_dB(yu,xu)=attenuazione_suppl_dB(yu,xu)+att_tot;  							% attenuazione supplementare nella posizione dell'utente presa in considerazione
            attenuazione_suppl_dB(xu,yu)=att_tot;
            attenuazione_tot_dB(xu,yu)=Afs+att_tot;   							% attenuazione spazio libero e attenuazione supplementare posizionata nella posizione dell'utente presa in considerazione
        end
        disp (['ciclo ' num2str(xu) ' ' num2str(yu) ' ok!']);
    end
end

disp (attenuazione_tot_dB);
mesh (attenuazione_tot_dB);
axis equal;