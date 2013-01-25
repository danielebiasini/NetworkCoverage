%%%%% funzione che calcola l'attenuazione massima tollerabile attraverso il link budget %%%%%

%function [Att_max]=link_budget(Pt,Gt,Gr,F,B_l,Mff)
%function [Att_max] = link_budget(TxPower);

%%%%% Ingressi %%%%%
% Pt     	[dBW]  potenza trasmessa dall'elicottero
% Gt       	[dB]   guadagno dell'antenna dell'elicottero
% Gr       	[dB]   guadagno dell'antenna dell'utente
% F        	[dB]   cifra di rumore del sistema ricevente
% B_l	 	[Hz]   banda di frequenza
% Mff     	[dB]   margine di radiocollegamento

%%%%% Uscite %%%%%
% Att_max   	attenuazione massima tollerabile

% %%%%% Valori Di Prova %%%%%
% Pt=-10;     	%% [dBW]  potenza trasmessa dall'elicottero
% Gt=3;       	%% [dB]   guadagno dell'antenna dell'elicottero
% Gr=0;       	%% [dB]   guadagno dell'antenna dell'utente
% F=6;        	%% [dB]   cifra di rumore del sistema ricevente
% B_l=6*10^6; 	%% [Hz]   banda di frequenza
% Mff=15;     	%% [dB]   margine di radiocollegamento
% 
% %%%%% Valori Utilizzati Nel Bilancio Di Radiocollegamento %%%%%
% SNR=10;                             %% [dB]  	rapporto segnale rumore, ottenuto da una sensitività S=10*N
% K=-228.6;                           %% [dBJ/K]  	costante di Boltzman (1.28*10^(-23)J/K)
% Ta=290;                             %% [K]   	temperatura d'antenna
% Ts=10*log10(Ta+Ta*(10^(F/10)-1));   %% [dBK]  	temperatura di sistema
% B=10*log10(B_l);               		%% [dBHz]  	banda di frequenza
% 
% Att_max=Pt+Gt+Gr-K-Ts-B-SNR-Mff;    %% attenuazione massima tollerabile

TxPower = 46;
TxGain = 18;
CableLoss = 2;
EIRP = TxPower + TxGain + CableLoss;

UENoiseFigure = 7;
ThermalNoise = -104.5;
RxNoiseFloor = UENoiseFigure + ThermalNoise;

SINR = -10;

RxSensitivity = RxNoiseFloor + SINR;
InterferenceMargin = 3;
ControlChannelOverhead = 1;
RxGain = 0;
BodyLoss = 0;

Att_max = EIRP - RxSensitivity - InterferenceMargin - ControlChannelOverhead + RxGain - BodyLoss;
disp(Att_max);





