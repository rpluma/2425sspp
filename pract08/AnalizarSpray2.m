function AnalizarSpray2(im)
    figure
    imshow(im); % Muestra imagen de entrada
    roi = imline(gca,[30 500],[100 100]); % Crea región de interés tipo línea
    m = createMask(roi); % Crea máscara binaria
    imb = edge(im); % Discontinuidades binarias de la imagen completa
    imbm = imb.*m; % Discontinuidades detectadas en la máscara
    iml = bwlabel(imbm); % Etiquetado de discontinuidades detectadas
    numr = max(max(iml)); % Número de discontinuidades detectadas
    text (30,70,sprintf("Discontinuidades=%d",numr),'Color','b');
    if (numr == 6) % DISPENSADOR CORRECTO
        text (30,20,'DISPENSADOR CORRECTO','Color','g');
        text (30,50,'TAPÓN PRESENTE','Color','g');
    elseif (numr == 2)
        text (30,20,'DISPENSADOR CORRECTO','Color','g');
        text (30,50,'TAPÓN AUSENTE','Color','r');
    elseif (numr == 4)
        text (30,20,'DISPENSADOR INCORRECTO','Color','r');
        text (30,50,'TAPÓN PRESENTE','Color','g');
    else
        text (30,20,'DISPENSADOR INCORRECTO','Color','r');
        text (30,50,'TAPÓN AUSENTE','Color','r');
    end
end