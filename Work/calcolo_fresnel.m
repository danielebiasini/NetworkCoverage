function[att_tot]=calcolo_fresnel(v)


%      INGRESSI
% v     visibilit� normalizzata

%     USCITE
% att_tot   valore di attenuazione totale dovuto ai vari contributi degli
%            ostacoli

C=mfun('FresnelC',v);
S=mfun('FresnelS',v);
I=(C-S.*1i);      %integrale complesso di Fresnel
          
Fd=sqrt(2)/2*abs(0.5.*(1-1i)-I);     %fattore di diffrazione  
%disp('Loss dei singoli ostacoli'); 
att=-20*log10(Fd);        %attenuazione in dB dovuta alla diffrazione per i singoli ostacoli

att_tot=sum(att);   %attenuazione totale
%disp(['Loss totale=' num2str(att_tot)]);