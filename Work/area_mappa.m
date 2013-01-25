%
function [mappa,mask_ost] = area_mappa

%%%%% Uscite %%%%%
% mappa         matrice con le altezze degli ostacoli

%%% colle oppio %%%
ksam= imread('/home/daniele/Dropbox/Tesi/MioMappa/dati/ColleOppio/mask.png');          % matrice maschera degli ostacoli
%ksam= imread('C:\Users\Daniele\Dropbox\Tesi\MioMappa\dati\ColleOppio\mask.png');      % matrice maschera degli ostacoli
temp = ksam(:,:,1);                                                                                                                            % prendo un colore tra r g b (è indifferente perché gli ostacoli sono colorati in nero quindi i valori sono 0 o 255)
mask = flipud(temp);                                                                                                                        % ribalto la matrice perché i programmi precedenti la stampano in modo errato
mask_ost = mask < 1;                                                                                                                                   % la converto in matrice logica
med = load('/home/daniele/Dropbox/Tesi/MioMappa/dati/ColleOppio/elevation.txt');       % matrice di elevazione del terreno
%med = load('C:\Users\Daniele\Dropbox\Tesi\MioMappa\dati\ColleOppio\elevation.txt');   % matrice di elevazione del terreno
dem = flipud(med);
% rand_h=randi([80 120]);                                                                % altezza casuale dell'ostacolo
%%%%%%%%%%%%%%%%%%

%%% pantheon %%%
% ksam= imread('/home/daniele/Dropbox/Tesi/MioMappa/dati/Pantheon/mask.png');              % matrice maschera degli ostacoli
% %ksam= imread('C:\Users\Daniele\Dropbox\Tesi\MioMappa\dati\Pantheon\mask.png');          % matrice maschera degli ostacoli
% temp = ksam(:,:,1);                                                                                                                            % prendo un colore tra r g b (è indifferente perché gli ostacoli sono colorati in nero quindi i valori sono 0 o 255)
% mask = flipud(temp);                                                                                                                        % ribalto la matrice perché i programmi precedenti la stampano in modo errato
% mask_ost = mask < 1;                                                                                                                                   % la converto in matrice logica
% med = load('/home/daniele/Dropbox/Tesi/MioMappa/dati/Pantheon/elevation.txt');           % matrice di elevazione del terreno
% %med = load('C:\Users\Daniele\Dropbox\Tesi\MioMappa\dati\Pantheon\elevation.txt');       % matrice di elevazione del terreno
% dem = flipud(med);
% %rand_h=randi([40 70]);                                                                   % altezza casuale dell'ostacolo
%%%%%%%%%%%%%%%%%%


%%% olimpico %%%
% ksam= imread('/home/daniele/Dropbox/Tesi/MioMappa/dati/StadioOlimpico/mask.png');         % matrice maschera degli ostacoli
% %ksam= imread('C:\Users\Daniele\Dropbox\Tesi\MioMappa\dati\StadioOlimpico\mask.png');     % matrice maschera degli ostacoli
% temp = ksam(:,:,1);                                                                                                                            % prendo un colore tra r g b (è indifferente perché gli ostacoli sono colorati in nero quindi i valori sono 0 o 255)
% mask = flipud(temp);                                                                                                                        % ribalto la matrice perché i programmi precedenti la stampano in modo errato
% mask_ost = mask < 1;                                                                                                                                   % la converto in matrice logica
% med = load('/home/daniele/Dropbox/Tesi/MioMappa/dati/StadioOlimpico/elevation.txt');      % matrice di elevazione del terreno
% %med = load('C:\Users\Daniele\Dropbox\Tesi\MioMappa\dati\StadioOlimpico\elevation.txt');  % matrice di elevazione del terreno
% dem = flipud(med);
% %rand_h=randi([30 90]);                                                                     % altezza casuale dell'ostacolo
%%%%%%%%%%%%%%%%%%

%%% tor vergata ingegneria %%%
ksam= imread('/home/daniele/Dropbox/Tesi/MioMappa/dati/TorVergataIng/mask.png');          % matrice maschera degli ostacoli
%ksam= imread('C:\Users\Daniele\Dropbox\Tesi\MioMappa\dati\TorVergataIng\mask.png');      % matrice maschera degli ostacoli
temp = ksam(:,:,1);                                                                                                                            % prendo un colore tra r g b (è indifferente perché gli ostacoli sono colorati in nero quindi i valori sono 0 o 255)
mask = flipud(temp);                                                                                                                        % ribalto la matrice perché i programmi precedenti la stampano in modo errato
mask_ost = mask < 1;                                                                                                                                   % la converto in matrice logica
med = load('/home/daniele/Dropbox/Tesi/MioMappa/dati/TorVergataIng/elevation.txt');       % matrice di elevazione del terreno
%med = load('C:\Users\Daniele\Dropbox\Tesi\MioMappa\dati\TorVergataIng\elevation.txt');   % matrice di elevazione del terreno
dem = flipud(med);
% rand_h=randi([80 100]);                                                                % altezza casuale dell'ostacolo
%%%%%%%%%%%%%%%%%%


N=200;                                                          % lato matrice
mappa=zeros(N,N);                                               % preallocazione matrice
palazzi=zeros(N,N);                                             
for i=1:randi([10 20]):N                                        % mi muovo a passi casuali per formare la lunghezza dell'ostacolo tra 10 e 20
    for j=1:randi([10 20]):N                                    % mi muovo a passi casuali per formare la larghezza dell'ostacolo tra 10 e 20
        rand_h=randi([80 100]);    
        for h=1:(N-i)                                           % interrompo il ciclo a N-i per non andare oltre i limiti della matrice
            for k=1:(N-j)                                       % interrompo il ciclo a N-j per non andare oltre i limiti della matrice
                palazzi(i+h,j+k) = rand_h*mask_ost(i+h,j+k);    
            end
        end
    end
end

mappa_bucata=zeros(N,N);                                        
for i=1:N                                                       % 
     for j=1:N                               
        mappa_bucata(i,j) = dem(i,j)*(1 - mask_ost(i,j));
        mappa(i,j)=palazzi(i,j)+mappa_bucata(i,j);
     end
end

 mesh(mappa);
 axis equal;