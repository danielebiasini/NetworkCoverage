
clc

tic;
profile off

%%% Area Mappa %%%
[mappa,mask_ost] = area_mappa;
dim_area=size(mappa);

xe=round(dim_area(2)/2);  	% coordinate dell elicottero, valori arrotondati all intero piu' vicino
ye=round(dim_area(1)/2);

disp(['coordinate: xe=' num2str(xe) ' ye=' num2str(ye)]);

% %%%%% Link Budget %%%%%
% Pt=46;       			% [dBW] potenza trasmessa dall'elicottero
% Gt=18;       			% [dB]  guadagno dell'antenna dell'elicottero
% Gr=0;       			% [dB]  guadagno dell'antenna dell'utente
% F=7;        			% [dB]  cifra di rumore del sistema ricevente
% B_l=9*10^6; 			% [Hz]  banda di frequenza
% Mff=8.67;     			% [dB]  margine di radiocollegamento

%%% 20 (femto), 24 (pico), 46 cella
TxPower = 46;
% [Att_max]=link_budget(TxPower);
Att_max = 117.5 + TxPower;

f=1.8*10^9;   			% frequenza utilizzata
hu=1;       			% altezza utente

dim_pixel=5;   			% dimensione pixel
c=3*10^8;     			% [m/s] velocita' della luce

% Raggio_40k_medio_exp=zeros{40};
% Raggi_40k_exp=zeros{40};
% attenuazione_fs_dB_exp=zeros{40};
% attenuazione_suppl_dB_exp=zeros{40};
% attenuazione_tot_dB_exp=zeros{40};

%HE=(100:10:400);
HE=50:25:125;
cnt=1;

for he=HE,
    disp(['altezza dell elicottero: he=' num2str(he)]);
    
    %%%%% calcolo dell'attenuazione %%%%%
    [attenuazione_suppl_dB,attenuazione_fs_dB,attenuazione_tot_dB]=prova_attenuazione(mappa,mask_ost,he,f,dim_pixel,xe,ye);
    
    disp(he);
    disp('attenuazione_tot_dB');
    disp(attenuazione_tot_dB);
    disp('Att_max');
    disp(Att_max);
    
    [Raggio_medio,Raggio_percentile,Raggi_40k]=calcolo_raggi(attenuazione_tot_dB,Att_max,dim_pixel,xe,ye);
    
    % memorizzazione variabili
    Raggio_40k_medio_exp{cnt}=Raggio_medio;
    Raggi_40k_exp{cnt}=Raggi_40k;
    attenuazione_fs_dB_exp{cnt}=attenuazione_fs_dB;
    attenuazione_suppl_dB_exp{cnt}=attenuazione_suppl_dB;
    attenuazione_tot_dB_exp{cnt}=attenuazione_tot_dB;
    
    cnt=cnt+1;
    
end

% calcolo raggio teorico di copertura nel caso di free space
[Rfs]=raggio_free_space(f,hu,Att_max);

time=toc;
disp(['Time = ',num2str(time)]);

%%%%% Fine elaborazione dati %%%%%