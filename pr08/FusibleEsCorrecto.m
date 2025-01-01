function [EsCorrecto] = FusibleEsCorrecto(img)
    
    % región de interés
    ROI = [10.51 65.51 405.98 290.98];
    imgc = imcrop(img, ROI); % c=crop

    % filtrado de frecuencia
    dinf = 70; 
    dsup =120;
    [tamx,tamy] = size(imgc); % Tamaño de la imagen
    [xx,yy] = meshgrid(1:tamx,1:tamy);
    d = sqrt((xx-tamx/2).^2+(yy-tamy/2).^2); % Distancia al centro
    ILPF = ((d < dinf)|(d>dsup))';
    imgf = real(ifft2(fft2(imgc) .* fftshift(ILPF))/255); % f=filtrada
    % imshow(ILPF.*(30*log10(1+abs(fftshift(fft2(imgc))))/255));

    % binarización
    imgb = 1-imbinarize(imgf,'adaptive', Sensitivity=0.70); % b=binarizada

    % mejora con operadores morfológicos
    imgm = bwmorph(imgb, 'dilate', 5); % m=mejorada
    imgm = bwmorph(imgm, 'erode', 5);

    % etiquetado de regiones conectadas
    imge = bwlabel((1-imgm)); % e=etiquetada
    %imshow(label2rgb(imge));

    % extracción de descriptores
    pro = regionprops (imge,'Area');
    N = sum([pro.Area]>700);

    % mostrar resultado
    figure
    subplot(231); imshow(imgc); title("ROI");
    subplot(232); imshow(imgf); title("sin ruido freq");
    subplot(233); imshow(imgb); title("binarizada");
    subplot(234); imshow(imgm); title("mejorada");
    subplot(235); imshow(label2rgb(imge)); title("etiquetada");
    subplot(236); imshow(img); title("original");
    EsCorrecto = (N==4);
    if (EsCorrecto)
        title("Fusible sin defectos", color='g');
    else
        title(sprintf("Fusible defectuoso n=%d",N), color='r');
    end
end
