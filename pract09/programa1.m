function [] = programa1(img)
    img1 = imbinarize(img);
    img2 = bwmorph(bwmorph(bwmorph(img1,'open'), 'dilate', 5), 'erode', 5);

    % Descriptores de región regionprops(...,'all')
    pro = regionprops (img2,'all');

    figure;
    imshow(img); hold on;

    % ¿Regiones sin analizar?
    for i=1:numel(pro)
        E = pro(i).EulerNumber;
        cx = pro(i).Centroid(1);
        cy = pro(i).Centroid(2);
        if (E==0)
            tipo = "EJE";
        elseif (E==-6)
            tipo = "POLEA";
        elseif (E==-4)
            tipo = "ENGRANAJE";
            dif = pro(i).FilledImage-pro(i).ConvexImage;
            dif2 = bwmorph(dif, 'erode', 3);
            dif3 = bwlabel(dif2);
            N = max(max(dif3));
            if (N==24)
                tipo = sprintf("ENGRANAJE \nCORRECTO");
            else
                tipo = sprintf("ENGRANAJE \nDEFECTUOSO \n(N=%d)", N);
            end
        else
            tipo = "NO IDENTIFICADO"
        end
        text(cx, cy, tipo, Color='r');
    end
end