function [] = porcero(iml, u)
    % algoritmo
    iml = iml/max(max(iml)); % imagen laplaciana
    [tamx,tamy] = size(iml);
    imt1 = (iml(1:tamx-1,1:tamy-1));
    imt2 = (iml(2:tamx,1:tamy-1));
    imt3 = (iml(1:tamx-1,2:tamy));
    imt4 = (iml(2:tamx,2:tamy));
    impc = (imt1.*imt2) < -u|(imt1.*imt3) < -u|(imt1.*imt4) < -u;
    
    % salida
    %figure
    imshow(impc)
end