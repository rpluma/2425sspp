function [] = MarcarDigitos(img)
% A partir de la imagen de entrada, marca los d'igitos detectados asignando
% un color diferente a cada n'umero
    load('plantillas.mat');
    umbrales = [0.9 0.8 0.8 0.8 0.8 0.85 0.8 0.8 0.8 0.70];
    colores = hsv(10);
    figure
    imshow(img); hold on;
    for np = 1:10 % para cada dígito del 1 al 0
        imc = normxcorr2(plantillas(np).im, img);
        [x, y] = find(imc > umbrales(np));
        plot(y, x, '*', 'Color', colores(np, :));
    end
end