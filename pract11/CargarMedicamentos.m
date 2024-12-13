load Capsulas

figure
for k = 1:15
    if k < 10 
        var = ['cap0',num2str(k)];
    else
        var = ['cap',num2str(k)];
    end
    eval(['im = ',var,';']);
    subplot(3,5,k);
    imshow(im)
    title(var);
end