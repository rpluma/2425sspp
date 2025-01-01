% Esta función realiza una segmentación mediante crecimiento de regiones.
% La condición de simulitud se cumple cuando la direfencia de nivel del punto 
% a añadir con el valor medio de la región no supera el umbral de entrada 'umbral'
% La imagen de entrada 'im' debe estar entre 0 y 255 y la semilla se
% especifica por medio del ratón.
% Esta función va mostrando la evolución del crecimiento

function imr = vercre_isa(im,umbral)

[tamx, tamy] = size(im); % Calcula el tamaño de la imagen para establecer límites de crecimiento

im = double(im);

figure, imshow(im,[]); % Muestra la imagen de entrada

semilla = round(ginput(1)); % Pide la semilla por medio del ratón
xs      = semilla(2);       % Coordenada X de la semilla    
ys      = semilla(1);       % Coordenada Y de la semilla
nivel_semilla = im(xs,ys);  % Nivel de gris de la semilla
im (xs,ys) = -255;          % Marcar como -255 los puntos que deben crecer

nuevo = 1;                  % Indica si debe seguir creciendo (nuevo punto añadido
n = 1;                      % Indica el tamaño actual de la región en crecimiento
while (nuevo)               % Hacer mientras siga creciendo
   imshow((im+2),[0 1 0; gray(256)]);     % Mostrar progreso del crecimiento
   drawnow
   nuevo = 0;
   [px,py] = find (im==-255); % Localizar puntos a creecer
   for ind = 1:size (px,1)    % Para cada punto localizado
      for k1 = -1:1           % Expandir con sus 8 vecinos que cumplan condición de similitud
         for k2 = -1:1
            if px(ind)+k1 > 0 & py(ind)+k2 > 0 & ...
                  px(ind)+k1 <= tamx & py(ind)+k2<= tamy % Verificar límites de la imagen
              if (im(px(ind)+k1,py(ind)+k2) >= 0) & ...
                    abs(im(px(ind)+k1,py(ind)+k2)-nivel_semilla)<=umbral % Verificar similitud
                 nivel_semilla = (nivel_semilla*n+im(px(ind)+k1,py(ind)+k2))/(n+1); % Actualizar umbral
                 n = n + 1;
                 im (px(ind)+k1,py(ind)+k2) = -255; % Marcar para crecer en la proxima iteración
                 nuevo = 1;
              end 
              if (k1 == 0 & k2 == 0) 
                  im(px(ind),py(ind)) = -1; % No vuelve a crecer 
              end 
            end % Fin de comprobar limites
         end % Fin de vecinos en X
      end % Fin de vecinos en Y
   end % Fin de nuevos puntos a crecer
end 

imr = (im<0);  % Los negativos son los puntos resultantes del crecimiento  

figure, 
imshow (imr);  % Muestra el resultado en una nueva figura       
   
   
   