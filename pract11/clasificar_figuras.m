function [imgb, pro] = clasificar_figuras(img, dcitr, dcuci, dtrcu)
    figure
    imshow(img, []);
    hold on;
    %CargarMuestra
    %dcitr = perceptron_isa(pci, ptr, 1);
    %dcuci = perceptron_isa(pcu, pci, 1);
    %dtrcu = perceptron_isa(ptr, pcu, 1);
    imgb = imbinarize(img);
    pro = regionprops(imgb, 'Image','Centroid');
    
    for i=1:numel(pro)
        cx = pro(i).Centroid(1);
        cy = pro(i).Centroid(2);
        imgs = signatura_isa(pro(i).Image);
        imgd = [mean(imgs(:,2)), std(imgs(:,2)), 1];
        citr = dcitr*imgd';
        trci = -citr;
        cuci = dcuci*imgd';
        cicu = -cuci;
        trcu = dtrcu*imgd';
        cutr = -trcu;
        ci = citr > 0 & cicu > 0;
        cu = cuci > 0 & cutr > 0;
        tr = trcu > 0 & trci > 0;
        if ci
            text(cx, cy, 'círculo', color='r');
        elseif cu
            text(cx, cy, 'cuadrado', color='r');
        elseif tr
            text(cx, cy, 'triángulo', color='r');
        else
            text(cx, cy, 'no clasif', color='r');
        end
    end
end