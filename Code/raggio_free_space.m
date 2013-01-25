%%%%% funzione che calcola il raggio teorico di copertura nel caso di free space %%%%%

function [Rfs]=raggio_free_space(f,hu,Att_max)

%%%%% Ingressi %%%%%
% f         	frequenza 
% hu        	altezza utente
% Att_max   	attenuazione massima tollerata

%%%%% Uscite %%%%%
% Rfs  		raggio free space al variare dell'altezza

c=3*10^8;
he_fs=[10:10:400];
h_fs=he_fs-hu;
Att_lin=10^(Att_max/10);
dfs1=sqrt(Att_lin)*c/(4*pi*f);
Rfs=sqrt(dfs1.^2-h_fs.^2);