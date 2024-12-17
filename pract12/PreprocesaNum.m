function ims = PreprocesaNum(im,tam,h,inv)
% Funci�n que procesa una imagen de entrada para adaptarla a las empleadas
% en el proceso de entrenamiento de la red neuronal.
% Entrada: im  -- imagen a preprocesar
%          tam -- dimensi�n de la imagen de salida
%          h   -- histograma especificado
%          inv -- indica si la imagen se debe invertir
% Las im�genes empleados en el entrenamiento son de 28x28x1 con un histograma
% medio contenido en el fichero 'histograma_celda.mat' e invertidas

if (ndims(im) == 3)    % Si es RGB la convierte en niveles de grises
    im = rgb2gray(im); 
end

ims = imresize(im,tam);
if (inv) 
    ims = 255 - ims;
end

ims = histeq(ims,h);



