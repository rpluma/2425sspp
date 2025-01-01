function pat = descriptores (im)

t = graythresh(im/255);
 
imb = not(double(im2bw(im/255,t-0.1)));  % Segmentacion mediante umbralizacion la imagen

iml = bwlabel(imb);                      % Etiquetado de regiones conectadas
ims = edge(imb);                         %

n = max(max(iml));

for k = 1:n                              % Para todas las regiones conectadas
    imt = iml==k;                        % Extraer region
    if (sum(sum(imt))>100)               % Si el tamaño de la region supera un umbral
        s = signatura_isa (imt);          % Calcular signatura de la region 
        pat(k,1) = mean(s(:,2));         % Calcular media y desviación tipica y añadir patron
        pat(k,2) = std(s(:,2));
    end
end
disp('hol');