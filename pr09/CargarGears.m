load Gears

f = figure, set(f,'Name','IMAGENES A CLASIFICAR');

for k = 1:8
    eval(['subplot(3,3,',num2str(k),'); imshow(g',num2str(k),');']);
    title(['g',num2str(k)]);
end
