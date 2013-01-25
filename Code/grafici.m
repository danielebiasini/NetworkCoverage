function grafici(he,scenario,nominale,attenuazione_fs_dB,attenuazione_suppl_dB,attenuazione_tot_dB,dim_pixel)

%%%%% Ingressi %%%%%
% he                     altezza dell'elicottero
% scenario               tipo di area
% attenuazione_fs_dB     matrice dell'attenuazione da spazio libero
% attenuazione_suppl_dB  matrice dell'attenuazione supplementare
% attenuazione_tot_dB    matrice dell'attenuazione totale
% nominale               variabile necessaria per la scelta del 'case'
% dim_pixel              dimensione del pixel


mas2=max(attenuazione_fs_dB);
massimo2=fix(max(mas2))+1;

figure;
mesh(attenuazione_fs_dB)
colorbar   		% inserisce la scala dei colori
ylabel(['PIXEL - 1pixel=' num2str(dim_pixel) 'm -']);
xlabel(['PIXEL - 1pixel=' num2str(dim_pixel) 'm -']);
zlabel('Loss [dB]');
switch (scenario+nominale)
    case 0
        title(['SCENARIO: AREA DI PROVA PERDITA SPAZIO LIBERO 3D altezza elicottero he=' num2str(he) 'm']);
    case 1 
        title(['SCENARIO: AREA CON OSTACOLI RANDOM  PERDITA SPAZIO LIBERO 3D altezza elicottero he=' num2str(he) 'm']);
    case 2
        title(['SCENARIO: MANHATTAN PERDITA SPAZIO LIBERO 3D altezza elicottero he=' num2str(he) 'm']);
    case 3    
        title(['SCENARIO: MAPPA PERDITA SPAZIO LIBERO 3D altezza elicottero he=' num2str(he) 'm']);
    case 4
        title(['SCENARIO: AREA DI PROVA PERDITA SPAZIO LIBERO 3D altezza elicottero he=' num2str(he) 'm e posizione NOMINALE']);
    case 5 
        title(['SCENARIO: AREA CON OSTACOLI RANDOM  PERDITA SPAZIO LIBERO 3D altezza elicottero he=' num2str(he) 'm e posizione NOMINALE']);
    case 6
        title(['SCENARIO: MANHATTAN PERDITA SPAZIO LIBERO 3D altezza elicottero he=' num2str(he) 'm e posizione NOMINALE']);
    case 7    
        title(['SCENARIO: MAPPA PERDITA SPAZIO LIBERO 3D altezza elicottero he=' num2str(he) 'm e posizione NOMINALE']);
end

    
    
figure;
image(attenuazione_fs_dB)
colormap(gca, flipud(hot(max(massimo2))))
colorbar   		% inserisce la scala dei colori
ylabel(['PIXEL - 1pixel=' num2str(dim_pixel) 'm -']);
xlabel(['PIXEL - 1pixel=' num2str(dim_pixel) 'm -']);
switch (scenario+nominale)
   case 0
     title(['SCENARIO: AREA DI PROVA PERDITA SPAZIO LIBERO 2D altezza elicottero he=' num2str(he) 'm']);
   case 1 
     title(['SCENARIO: AREA CON OSTACOLI RANDOM PERDITA SPAZIO LIBERO 2D altezza elicottero he=' num2str(he) 'm']);
   case 2
     title(['SCENARIO: MANHATTAN PERDITA SPAZIO LIBERO 2D altezza elicottero he=' num2str(he) 'm']);
   case 3    
      title(['SCENARIO: MAPPA PERDITA SPAZIO LIBERO 2D altezza elicottero he=' num2str(he) 'm']);
   case 4
      title(['SCENARIO: AREA DI PROVA PERDITA SPAZIO LIBERO 2D altezza elicottero he=' num2str(he) 'm e posizione NOMINALE']);
   case 5 
      title(['SCENARIO: AREA CON OSTACOLI RANDOM PERDITA SPAZIO LIBERO 2D altezza elicottero he=' num2str(he) 'm e posizione NOMINALE']);
   case 6
     title(['SCENARIO: MANHATTAN PERDITA SPAZIO LIBERO 2D altezza elicottero he=' num2str(he) 'm e posizione NOMINALE']);
   case 7    
        title(['SCENARIO: MAPPA PERDITA SPAZIO LIBERO 2D altezza elicottero he=' num2str(he) 'm e posizione NOMINALE']);   
end
 
   
mas=max(attenuazione_suppl_dB);
massimo=fix(max(mas))+1;

figure;
mesh(attenuazione_suppl_dB)
colorbar   %inserisce la scala dei colori
ylabel(['PIXEL - 1pixel=' num2str(dim_pixel) 'm -']);
xlabel(['PIXEL - 1pixel=' num2str(dim_pixel) 'm -']);
zlabel('Loss [dB]');
switch (scenario+nominale)
   case 0
      title(['SCENARIO: AREA DI PROVA PERDITA SUPPLEMENTARE 3D altezza elicottero he=' num2str(he) 'm']);
   case 1 
      title(['SCENARIO: AREA CON OSTACOLI RANDOM PERDITA SUPPLEMENTARE 3D altezza elicottero he=' num2str(he) 'm']);
   case 2
      title(['SCENARIO: MANHATTAN PERDITA SUPPLEMENTARE 3D altezza elicottero he=' num2str(he) 'm']);
   case 3    
      title(['SCENARIO: MAPPA PERDITA SUPPLEMENTARE 3D altezza elicottero he=' num2str(he) 'm']);
   case 4
      title(['SCENARIO: AREA DI PROVA PERDITA SUPPLEMENTARE 3D altezza elicottero he=' num2str(he) 'm e posizione NOMINALE']);
   case 5 
      title(['SCENARIO: AREA CON OSTACOLI RANDOM PERDITA SUPPLEMENTARE 3D altezza elicottero he=' num2str(he) 'm e posizione NOMINALE']);
   case 6
      title(['SCENARIO: MANHATTAN PERDITA SUPPLEMENTARE 3D altezza elicottero he=' num2str(he) 'm e posizione NOMINALE']);
   case 7    
     title(['SCENARIO: MAPPA PERDITA SUPPLEMENTARE 3D altezza elicottero he=' num2str(he) 'm e posizione NOMINALE']);   
end
    
    
figure;
image(attenuazione_suppl_dB)
colormap(gca, flipud(hot(max(massimo))))
colorbar   		% inserisce la scala dei colori
ylabel(['PIXEL - 1pixel=' num2str(dim_pixel) 'm -']);
xlabel(['PIXEL - 1pixel=' num2str(dim_pixel) 'm -']);
switch (scenario+nominale)
   case 0
      title(['SCENARIO: AREA DI PROVA PERDITA SUPPLEMENTARE 2D altezza elicottero he=' num2str(he) 'm']);
   case 1 
      title(['SCENARIO: AREA CON OSTACOLI RANDOM PERDITA SUPPLEMENTARE 2D altezza elicottero he=' num2str(he) 'm']);
   case 2
      title(['SCENARIO: MANHATTAN PERDITA SUPPLEMENTARE 2D altezza elicottero he=' num2str(he) 'm']);
   case 3    
      title(['SCENARIO: MAPPA PERDITA SUPPLEMENTARE 2D altezza elicottero he=' num2str(he) 'm']);
   case 4
      title(['SCENARIO: AREA DI PROVA PERDITA SUPPLEMENTARE 2D altezza elicottero he=' num2str(he) 'm e posizione NOMINALE']);
   case 5 
      title(['SCENARIO: AREA CON OSTACOLI RANDOM PERDITA SUPPLEMENTARE 2D altezza elicottero he=' num2str(he) 'm e posizione NOMINALE']);
   case 6
      title(['SCENARIO: MANHATTAN PERDITA SUPPLEMENTARE 2D altezza elicottero he=' num2str(he) 'm e posizione NOMINALE']);
   case 7    
       title(['SCENARIO: MAPPA PERDITA SUPPLEMENTARE 2D altezza elicottero he=' num2str(he) 'm e posizione NOMINALE']);
end
    
    
mas1=max(attenuazione_tot_dB);
massimo1=fix(max(mas1))+1;

figure;
mesh(attenuazione_tot_dB)
colorbar   %inserisce la scala dei colori
ylabel(['PIXEL - 1pixel=' num2str(dim_pixel) 'm -']);
xlabel(['PIXEL - 1pixel=' num2str(dim_pixel) 'm -']);
zlabel('Loss [dB]');
switch (scenario+nominale)
   case 0
      title(['SCENARIO: AREA DI PROVA PERDITA TOTALE 3D altezza elicottero he=' num2str(he) 'm']);
   case 1 
      title(['SCENARIO: AREA CON OSTACOLI RANDOM PERDITA TOTALE 3D altezza elicottero he=' num2str(he) 'm']);
   case 2
      title(['SCENARIO: MANHATTAN PERDITA TOTALE 3D altezza elicottero he=' num2str(he) 'm']);
   case 3    
      title(['SCENARIO: MAPPA PERDITA TOTALE 3D altezza elicottero he=' num2str(he) 'm']);
   case 4
      title(['SCENARIO: AREA DI PROVA PERDITA TOTALE 3D altezza elicottero he=' num2str(he) 'm e posizione NOMINALE']);
   case 5 
      title(['SCENARIO: AREA CON OSTACOLI RANDOM PERDITA TOTALE 3D altezza elicottero he=' num2str(he) 'm e posizione NOMINALE']);
   case 6
      title(['SCENARIO: MANHATTAN PERDITA TOTALE 3D altezza elicottero he=' num2str(he) 'm e posizione NOMINALE']);
   case 7    
      title(['SCENARIO: MAPPA PERDITA TOTALE 3D altezza elicottero he=' num2str(he) 'm e posizione NOMINALE']);   
end
    
figure;
image(attenuazione_tot_dB)
colormap(gca, flipud(hot(max(massimo1))))
colorbar   %inserisce la scala dei colori
ylabel(['PIXEL - 1pixel=' num2str(dim_pixel) 'm -']);
xlabel(['PIXEL - 1pixel=' num2str(dim_pixel) 'm -']);
switch (scenario + nominale)
   case 0
      title(['SCENARIO: AREA DI PROVA PERDITA TOTALE 2D altezza elicottero he=' num2str(he) 'm']);
   case 1 
      title(['SCENARIO: AREA CON OSTACOLI RANDOM PERDITA TOTALE 2D altezza elicottero he=' num2str(he) 'm']);
   case 2
      title(['SCENARIO: MANHATTAN PERDITA TOTALE 2D altezza elicottero he=' num2str(he) 'm']);
   case 3    
      title(['SCENARIO: MAPPA PERDITA TOTALE 2D altezza elicottero he=' num2str(he) 'm']);
   case 4
      title(['SCENARIO: AREA DI PROVA PERDITA TOTALE 2D altezza elicottero he=' num2str(he) 'm e posizione NOMINALE']);
   case 5 
      title(['SCENARIO: AREA CON OSTACOLI RANDOM PERDITA TOTALE 2D altezza elicottero he=' num2str(he) 'm e posizione NOMINALE']);
   case 6
      title(['SCENARIO: MANHATTAN PERDITA TOTALE 2D altezza elicottero he=' num2str(he) 'm e posizione NOMINALE']);
   case 7    
      title(['SCENARIO: MAPPA PERDITA TOTALE 2D altezza elicottero he=' num2str(he) 'm e posizione NOMINALE']);
end
          
     