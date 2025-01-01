load Lcd

figure('Name','DISPLAYS A IDENTIFICAR');

for k = 1:numel(lcd)
    subplot(3,4,k), imshow(lcd(k).im)
    if k < 10 
        title(['LCD0',num2str(k)]);
    else
        title(['LCD',num2str(k)]);
    end
end
