load muestracontrolada

figure
subplot (2,3,1), imshow(cuadrados/255);
subplot (2,3,2), imshow(circulos/255);
subplot (2,3,3), imshow(triangulos/255);

pcu = descriptores(cuadrados);
ptr = descriptores(triangulos);
pci = descriptores(circulos);

subplot (2,1,2),plot (ptr(:,1),ptr(:,2),'v',...
                      pci(:,1),pci(:,2),'ro',...
                      pcu(:,1),pcu(:,2),'gs');

 xlabel ('Media de la signatura normalizada');
 ylabel ('Std de la signatura normalizada');