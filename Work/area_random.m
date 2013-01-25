function [area,xe,ye,scenario]=area_random(N,hmax,odim,J)

% %funzione che crea un'area con ostacoli disposti in modo random
% 
% %        INGRESSI                                        
% % N     grandezza dell'area (lato)                  
% % hmax  altezza massima dell'ostacolo               
% % odim  dimensione massima del lato dell'ostacolo   
% % J     percentuale di ostacolo nell'area           
% 
% %         USCITE
% % area  area con ostacoli disposti in modo random
% % xe    coordinata x dell'elicottero
% % ye    coordinata y dell'elicottero
% % scenario   tipo di scenario utilizzato
% %
% 
% %%%%%%%%% VARIABILI DI PROVA  %%%%%%%%%%%%%%%%%
N=200;     %grandezza area (lato)
hmax=18;   %altezza massima ostacolo
odim=15;   %dimensione max lato ostacoli
J=25;      %percentuale di ostacoli nell'area
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
scenario=1;
K=round((N^2)*J/(100*odim^2));   %n� di ostacoli nell'area (arrotondato al valore intero pi� vicino)
     
area=zeros(N,N);  %creo una matrice area di tutti zero
x=fix(rand(1,K)*N)+1;  %indice colonna della matrice area ottenuto in modo random per posizionare gli ostacoli
y=fix(rand(1,K)*N)+1;  %indice riga della matrice area ottenuto in modo random per posizionare gli ostacoli
h=round(rand(1,K)*(hmax-3))+3;   %altezze degli ostacoli generate in modo random

x_dim=fix(rand(1,K)*odim/2)+1;   %semidimensioni su l'asse x degli ostacoli generate in modo random
y_dim=fix(rand(1,K)*odim/2)+1;   %semidimensioni su l'asse y degli ostacoli generate in modo random

x_min=x-x_dim;      
xmin=max(x_min,1);  %coordinata x di inizio ostacolo

y_min=y-y_dim;     
ymin=max(y_min,1);  %coordinata y di inizio ostacolo

x_max=x+x_dim;      
xmax=min(x_max,N);  %coordinata x di fine ostacolo

y_max=y+y_dim;      
ymax=min(y_max,N);  %coordinata y di fine ostacolo


area1=area;    %variabile per vedere dove sono centrati i singoli ostacoli
for I=1:K    %ciclo per posizionare gli ostacoli con le rispettive altezze e dimensioni nella matrice area
    area1(y(I),x(I))=h(I);
    area(ymin(I):1:ymax(I),xmin(I):1:xmax(I))=h(I);
end
dim_area=size(area);
xe=round(dim_area(2)/2);  %coordinate dell elicottero, valori arrotondati all intero pi� vicino
ye=round(dim_area(1)/2);

figure
mesh(area)
colormap(gca, jet(max(hmax)))
colorbar   %inserisce la scala dei colori
ylabel(['PIXEL - 1pixel=' num2str(dim_pixel) 'm -']);
xlabel(['PIXEL - 1pixel=' num2str(dim_pixel) 'm -']);
zlabel('Altezza [m]');
switch scenario
    case 0
        title('SCENARIO: AREA DI PROVA 3D');
    case 1 
        title('SCENARIO: AREA CON OSTACOLI RANDOM 3D');
    case 2
        title('SCENARIO: MANHATTAN 3D');
    case 3    
        title('SCENARIO: MAPPA 3D');
end

figure
image(area)
colormap(gca, jet(max(hmax)))
colorbar   %inserisce la scala dei colori
ylabel(['PIXEL - 1pixel=' num2str(dim_pixel) 'm -']);
xlabel(['PIXEL - 1pixel=' num2str(dim_pixel) 'm -']);
switch scenario
    case 0
        title('SCENARIO: AREA DI PROVA 2D');
    case 1 
        title('SCENARIO: AREA CON OSTACOLI RANDOM 2D');
    case 2
        title('SCENARIO: MANHATTAN 2D');
    case 3    
        title('SCENARIO: MAPPA 2D');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%