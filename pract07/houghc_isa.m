% Busca en la imagen de entrada 'im' los circulos de radio 'r' empleando 
% la transformada de Hough. El parámetro 'ubin' representa un umbral de 
% binarización para la imagen gradiente que determina cuantos puntos se 
% van a emplear en el proceso de votación.
% Muestra una figura con la imagen original con los círculos detectados,
% la imagen del módulo gradiente y los puntos que han pasado el umbral 
% de binarización.
% Devuelve un vector con los centros de los circulos detectados y la matriz
% de acumulación

function [centros,ac] = houghc_isa (im,ubin,r);

% MOSTRAR IMAGEN
figure
subplot (2,2,1),imshow(im,[]);

% APLICACIÓN DE SOBEL 
m= [-1 -2 -1; 0 0 0; 1 2 1];    %Definición de máscara
gx = conv2 (double(im),m,'same'); 
gy = conv2 (double(im),m','same');
gra = round(abs(gx) + abs(gy)); %Módulo del vector gradiente  
gra = gra/max(max(gra));        %Módulo normalizado
ang = atan2(gy,gx);             %Dirección del vector gradiente

% BINARIZAR MODULO IMAGEN GRADIENTE
imb = im2bw(gra,ubin);

% MOSTRAR MODULO GRADIENTE Y BINARIZACIÓN DE MODDULO GRADIENTE
subplot (2,2,2),imshow (gra,[]);
subplot (2,2,3),imshow (imb);

% SELECCIONAR PUNTOS DE LA IMAGEN GRADIENTE
[x,y] = find (imb > 0);

% INICIALIZAR MATRIZ DE ACUMULACIÓN (POSIBLES CENTROS)
ac = double(im*0);

[tx,ty] = size (im); % Tamaño de la imagen

numpun = length(x); % Número de puntos que votan

% VOTACIÓN TRANSFORMADA DE HOUGH PARA CIRCULOS DE RADIO 'r'
% solo votan en la dirección del vector gradiente
for punto = 1:numpun
     an = ang(x(punto),y(punto));                   % Dirección del posible centro
     xc1  = round((x(punto)+r*cos(an)));            % Coordenada X en dirección an
     yc1  = round((y(punto)+r*sin(an)));            % Coordenada Y en dirección an
     xc2  = round((x(punto)+r*cos(an+pi)));         % Coordenada X en dirección an+pi
     yc2  = round((y(punto)+r*sin(an+pi)));         % Coordenada Y en dirección an+pi
     if (xc1 > 0 & yc1 > 0 & xc1 <= tx & yc1 <= ty) % Verificar límites del centro
        ac (xc1,yc1) = ac (xc1,yc1) + 1;            % VOTACIÓN
     end
     if (xc2 > 0 & yc2 > 0 & xc2 <= tx & yc2 <= ty) % Verificar límites del centro
        ac (xc2,yc2) = ac (xc2,yc2) + 1;            % VOTACIÓN
     end
end

% BUSCAR MÁXIMOS LOCALES
 h2 = colfilt(ac,[5,5],'sliding',@sum);             % Suma votos en entornos de 5x5
 ac_m = (h2>(pi*r*0.9));                            % Valores que superan votos
 ac_l = bwlabel(ac_m);                              % Etiquetar para tomar máximo local
 
 subplot (2,2,4), imshow (h2,[])                    % Dibujar matriz de acumulación
 subplot (2,2,1),hold on, 
 centros = [];
 
  for k = 1:max(max(ac_l))                          % Para cada máximo local
     m     = (ac_l == k);                           % Seleccionar máximo
     [x,y] = find(m);                               % Buscar coordenadas
     cx    = round(mean(x));                        % Calcular centro
     cy    = round(mean(y));
     centros(k,:) = [cx,cy];
     e = imellipse(gca,[cy-r,cx-r,r*2,r*2]);        % Dibujar circulo
     setColor(e,'g');
 end
