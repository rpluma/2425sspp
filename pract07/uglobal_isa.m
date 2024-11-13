function T = uglobal(im)

im = double(im);
h = imhist(im/255);                     % Calculo del histograma de la imagen 
T = mean2(im);                          % Establece umbral inicial como nivel de gris medio
T0 = 0.01;                              % Condicion de fin de iteracion

imb = double(im2bw(im/255,T/255));      % Binariza la imagen
im1 = (imb).*im;                        % Seleccionar pixeles que superan el umbral
im2 = (~imb).*im;                       % Seleccionar pixeles que no superan el umbral
s1 = find(imb);
m1 = sum(sum(im1))/length(s1);          % Nivel medio de pixeles que superan el umbral
s2 = find(~imb);
m2 = sum(sum(im2))/length(s2);          % Nivel medio de pixeles que no superan el umbral
NuevoT = (m1+m2)/2;                     % Actualizacion del umbral 

while (abs(NuevoT-T) > T0)
    T = NuevoT;
    imb = double(im2bw(im/255,T/255));      % Binariza la imagen
    im1 = (imb).*im;                        % Seleccionar pixeles que superan el umbral
    im2 = (~imb).*im;                       % Seleccionar pixeles que no superan el umbral
    s1 = find(imb);
    m1 = sum(sum(im1))/length(s1);          % Nivel medio de pixeles que superan el umbral
    s2 = find(~imb);
    m2 = sum(sum(im2))/length(s2);          % Nivel medio de pixeles que no superan el umbral
    NuevoT = (m1+m2)/2;                     % Actualizacion del umbral
end

T = round(T);