load spray
figure
for k = 1:12
    subplot(4,3,k),
    eval(['imshow(sp',num2str(k),')']);
    roi  = imline(gca,[30 500],[100 100]);
    setColor(roi,'g');
end