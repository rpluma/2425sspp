function [] = inspeccion_medicamentos(img)
    % contador de cápsulas
    capsulas = 0;
    res = img(:,:, 1)==256;

    % calcular imágenes S y H
    imghsv = rgb2hsv(img);
    H = imghsv(:, :, 1);
    S = imghsv(:, :, 2);
    
    imgb = (S>0.3).*((H>0.5)&(H<0.6)); % Binarmizar por matiz y color    
    imgm = bwmorph(imgb, 'erode', 1); % Mejora morfológica (una erosión)
    imgm = bwmorph(imgm, 'dilate', 4); % Mejora morfológica (4 dilat.)
    imgl = bwlabel(imgm); % resgiones conectadas
    num_reg = max(max(imgl)); % regiones sin analizar?
    for iRegion=1:num_reg        
        imgb = imgl==iRegion; % segmentar una nueva región       
        area = bwarea(imgb); % calcular el área        
        if (area > 200)  % si el área es mayor que 200
            capsulas = capsulas + 1; % incrementar el número de cápsulas
            res = res | imgb; % añadir región a imagen resultado
        end % area > 200
    end % for
    % Si cápsulas = 15

    if capsulas == 15
        titulo = "CORRECTO";
    else
        titulo = sprintf("INCORRECTO -%d",15-capsulas);
    end
    res = uint8(res);
    img_r = img(:,:,1).*res;
    
    img_g = img(:,:,2).*res;
    img_b = img(:,:,3).*res;
    img_rgb = cat(3, img_r, img_g, img_b);
    figure
    subplot(131); imshow(img); title(titulo);
    subplot(132); imshow(res, []);
    subplot(133); imshow(img_rgb, []);
end