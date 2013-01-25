%function [d1,d2,d,h,z,v]=calcolo_v(xu,yu,xo,yo,xe,ye,hu,ho,he,f,dim_pixel)
function v = calcolo_v(xu,yu,xo,yo,xe,ye,hu,ho,he,f,dim_pixel)
%funzione che calcola l'attenuazione dovuta alla diffrazione

%           INGRESSI:                                     
% xu,yu      coordinate dell'utente             
% xo,yo      coordinate dell'ostacolo           
% xe,ye      coordinate dell'elicottero         
% hu         altezza dell'utente                
% ho         altezza dell'ostacolo          
% he         altezza dell'elicottero            
% f          frequenza utilizzata               
% dim_pixel  dimensione pixel                   

%           USCITE
% d1    distanza tra utente e ostacolo 
% d2    distanza tra ostacolo e elicottero
% d     distanza tra utente e elicottero
% h     valore del franco
% z     altezza da terra della congiungente tra utente e elicttero in 
%        corrispondenza dell'ostacolo
% v     visibilit� normalizzata


c=3*10^8;     %velocità della luce

d1=dim_pixel*sqrt((xo-xu)^2+(yo-yu)^2);    %distanza a terra tra l'utente e l'ostacolo 
d2=dim_pixel*sqrt((xe-xo)^2+(ye-yo)^2);    %distanza a terra tra l'elicottero e l'ostacolo
d=dim_pixel*sqrt((xe-xu)^2+(ye-yu)^2);     %distanza a terra tra l'utente e l'elicottero
z=hu+(d1*(he-hu)/d);      %altezza da terra della congiungente tra utente e elicttero in corrispondenza dell'ostacolo
h=ho-z;        %valore del franco
v=h*sqrt(2*(d1+d2)*f/(c*d1*d2));

% disp(['d1=' num2str(d1)]);
% disp(['d2=' num2str(d2)]);
% disp(['d=' num2str(d)]);
% disp(['h=' num2str(h)]);
% disp(['v=' num2str(v)]);