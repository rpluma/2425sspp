% Busca en la imagen de entrada 'im' los circulos de radio 'r' empleando 
% la transformada de Hough. El par�metro 'ubin' representa un umbral de 
% binarizaci�n para la imagen gradiente que determina cuantos puntos se 
% van a emplear en el proceso de votaci�n.
% Muestra una figura con la imagen original con los c�rculos detectados,
% la imagen del m�dulo gradiente y los puntos que han pasado el umbral 
% de binarizaci�n.
% Devuelve un vector con los centros de los circulos detectados y la matriz
% de acumulaci�n

function [centros,ac] = houghc_isa (im,ubin,r);

% MOSTRAR IMAGEN
figure
subplot (2,2,1),imshow(im,[]);

% APLICACI�N DE SOBEL 
m= [-1 -2 -1; 0 0 0; 1 2 1];    %Definici�n de m�scara
gx = conv2 (double(im),m,'same'); 
gy = conv2 (double(im),m','same');
gra = round(abs(gx) + abs(gy)); %M�dulo del vector gradiente  
gra = gra/max(max(gra));        %M�dulo normalizado
ang = atan2(gy,gx);             %Direcci�n del vector gradiente

% BINARIZAR MODULO IMAGEN GRADIENTE
imb = im2bw(gra,ubin);

% MOSTRAR MODULO GRADIENTE Y BINARIZACI�N DE MODDULO GRADIENTE
subplot (2,2,2),imshow (gra,[]);
subplot (2,2,3),imshow (imb);

% SELECCIONAR PUNTOS DE LA IMAGEN GRADIENTE
[x,y] = find (imb > 0);

% INICIALIZAR MATRIZ DE ACUMULACI�N (POSIBLES CENTROS)
ac = double(im*0);

[tx,ty] = size (im); % Tama�o de la imagen

numpun = length(x); % N�mero de puntos que votan

% VOTACI�N TRANSFORMADA DE HOUGH PARA CIRCULOS DE RADIO 'r'
% solo votan en la direcci�n del vector gradiente
for punto = 1:numpun
     an = ang(x(punto),y(punto));                   % Direcci�n del posible centro
     xc1  = round((x(punto)+r*cos(an)));            % Coordenada X en direcci�n an
     yc1  = round((y(punto)+r*sin(an)));            % Coordenada Y en direcci�n an
     xc2  = round((x(punto)+r*cos(an+pi)));         % Coordenada X en direcci�n an+pi
     yc2  = round((y(punto)+r*sin(an+pi)));         % Coordenada Y en direcci�n an+pi
     if (xc1 > 0 & yc1 > 0 & xc1 <= tx & yc1 <= ty) % Verificar l�mites del centro
        ac (xc1,yc1) = ac (xc1,yc1) + 1;            % VOTACI�N
     end
     if (xc2 > 0 & yc2 > 0 & xc2 <= tx & yc2 <= ty) % Verificar l�mites del centro
        ac (xc2,yc2) = ac (xc2,yc2) + 1;            % VOTACI�N
     end
end

% BUSCAR M�XIMOS LOCALES
 h2 = colfilt(ac,[5,5],'sliding',@sum);             % Suma votos en entornos de 5x5
 ac_m = (h2>(pi*r*0.9));                            % Valores que superan votos
 ac_l = bwlabel(ac_m);                              % Etiquetar para tomar m�ximo local
 
 subplot (2,2,4), imshow (h2,[])                    % Dibujar matriz de acumulaci�n
 subplot (2,2,1),hold on, 
 centros = [];
 
  for k = 1:max(max(ac_l))                          % Para cada m�ximo local
     m     = (ac_l == k);                           % Seleccionar m�ximo
     [x,y] = find(m);                               % Buscar coordenadas
     cx    = round(mean(x));                        % Calcular centro
     cy    = round(mean(y));
     centros(k,:) = [cx,cy];
     e = imellipse(gca,[cy-r,cx-r,r*2,r*2]);        % Dibujar circulo
     setColor(e,'g');
 end
