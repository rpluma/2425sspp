function [im_sudo, celdas] = BuscarCeldasSudoku(im,ver);
%Este función realiza la busqueda de las celdas de un sudoku en una imagen
% Entradas: im  -- imagen a procesar
%           ver -- valor boolenano que indica si se deben visualizar resultados intermedios.
% Salidas:  im_sudoku -- recorte de la imagen original que solo continen el sudoku.
%           celdas    -- estructura de todos que contiene 81 elementos,
%           correspondientes a cada una de las casillas del sudoku,
%              celdas.im   -- contiene la imagen recortada de una celda.
%              celdas.xcen -- coordenada x del centroide de la celda en im_sudoku.
%              caldas.ycen -- coordenada y del centroide de la celda enim_sudoku.
%              celdas.ocu  -- booleano que indica si la celda contiene un número. 
%         

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SEGMENTAR SUDOKU DE LA IMAGEN COMPLETA
%   Se corresponde con al mayor región contectada de la imagen binarizada
%   negada  con umbral adaptativo.

    img       = rgb2gray(im);
    imb       = not(imbinarize(img,'adaptive','sensitivity',0.9));
    pro_imb   = regionprops(imb,'Area','BoundingBox');
    m         = max([pro_imb.Area]);
    reg_sudo  = pro_imb(find([pro_imb.Area] == m));
    im_sudo   = imcrop(img,reg_sudo.BoundingBox);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SEGMENTAR CELDAS

im_sudob  = imbinarize(im_sudo,'adaptive','sensitivity',0.6);
im_sudob  = bwmorph(im_sudob,'open');

area_celda = bwarea(im_sudob)/81; % Área aproximada de una celda vacía

pro_sudo   = regionprops(im_sudob,'Area',...
                                  'ConvexArea',  ...
                                  'BoundingBOx', ...
                                  'Centroid',    ...
                                  'Eccentricity' );

 % Condiciones que debe cumplir una región para ser una celda.
 reg_celdas = find([pro_sudo.ConvexArea]   > area_celda*0.6 ... 
                 & [pro_sudo.ConvexArea]   < area_celda*1.4 ...
                 & [pro_sudo.Eccentricity] < 0.7);

% Selección de las regiones que contienen una celda.
im_celdas = pro_sudo(reg_celdas);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GENERAR LA ESTRUCTURA DE DATOS PARA CONTENER LOS DATOS DE CADA CELDA

for k = 1:numel(im_celdas)
    pos           = round(im_celdas(k).BoundingBox);
    celda         = imcrop(im_sudo,[im_celdas(k).BoundingBox]+[2 2 -4 -4]); 
    celdas(k).im  = celda;
    celdas(k).xcen = im_celdas(k).Centroid(1);
    celdas(k).ycen = im_celdas(k).Centroid(2);
    celdas(k).ocu = im_celdas(k).Area < im_celdas(k).ConvexArea*0.9;
end

if (ver)
  figure, 
  subplot(2,3,1), imshow(im),          title('Imagen original')
  subplot(2,3,2), imshow(img),         title('Imagen en niveles de gris');
  subplot(2,3,3), imshow(imb),         title('Imagen binarizada');
  subplot(2,3,4), imshow(im_sudo),     title('Sudoku segmentado');
  subplot(2,3,5), imshow(im_sudob),    title('Sudoku binarizado');
  subplot(2,3,6), imshow(im_sudo),     title('Celdas detectadas');
  hold on
  plot([celdas.xcen],[celdas.ycen],'*');
  ind_ocu  = find([celdas.ocu]);
  plot([celdas(ind_ocu).xcen],[celdas(ind_ocu).ycen],'r*');
  xlabel(['Celdas = ',num2str(numel(celdas)),' Ocupadas = ', num2str(numel(ind_ocu))]);
end