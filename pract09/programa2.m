function [n] = programa2(img)
    % Obtención del esqueleto (práctica anterior)
    im1 = histeq(img); 
    im2 = im2bw(im1, 0.25); 
    im3 = not(im2); 
    im4 = bwmorph(im3, 'erode', 1); 
    im5 = bwmorph(im4, 'dilate', 4); 
    im6 = bwmorph(im5, 'thin', inf); 
    
    % Subimagen ROI > im _esq(50: 30:260)
    roi = im6(50:140, 30:260);

    % Etiquetado de regiones conectadas (bwlabel)
    iml = bwlabel(roi);

    n = [0 0 0 0];
    
    for k=1:4
        % Seleccionar región K
        dig = (iml==k);
    
        % Calcular vector de descriptores v
        pro = regionprops (dig,'EulerNumber','ConvexArea', 'Centroid'); 

        % end points
        skel = bwskel(dig,'minbranchlength',20);    
        endp = bwmorph(skel,'endpoints');
        nend = sum(sum(endp));

        % posición relativa
        [ex, ey] = min(find(endp));
        if (ey < pro.Centroid(2) - 1) % por arriba
            posrel = 1;
        elseif (ey > pro.Centroid(2) + 1) % por abajo
            posrel = -1;
        else
            posrel = 0;
        end

        v = [pro.EulerNumber, nend, pro.ConvexArea, posrel];
    
        % Procesar vector para obtener el número n(K)
        if (v(1) == -1) % dos huecos => 8
            n(k) = 8;
        elseif (v(1) == 0) % un hueco => 0, 6, 9
            if (v(2) == 0) % separa 0 de 6,9
                n(k) = 0;            
            elseif(v(4) == 1) % separa el 6 del 9
                n(k) = 9;
            else
                n(k) = 6;
            end
        else % cero huecos: 1, 2, 3, 4, 5, 7
            if (v(2) == 2) % dos puntos finales 1,2,5,7
                if (v(3) < 500) % separa el 1 por área
                    n(k) = 1;
                elseif (v(3) < 1300) % separa el 7 por área
                    n(k) = 7;
                else % v(3) > 1300, 2 o 5
                    if (v(4)==1) 
                        n(k) = 5;
                    else
                        n(k) = 2;
                    end
                end
            else % tres puntos finales
                if (v(3) < 1300) % separa el 3 y el 4 por área
                    n(k) = 4;
                else
                    n(k) = 3;
                end
            end
        end  
    end % for
  
    figure;
    imshow(img); hold on;
    res = sprintf("%d %d %d %d",n(1),n(2),n(3),n(4))
    text(0,10,res, Color='r', BackgroundColor='g', FontSize=15);
end