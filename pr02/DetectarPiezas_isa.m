function DetectarPiezas_isa(fichero, hsv, pausar)

global fin;
fin = 0;
f = figure;
f.ButtonDownFcn = @Pausar;
f.WindowScrollWheelFcn = @Terminar;

v = VideoReader(fichero);

im = readFrame(v); %Toma imagen de referencia

imHSV      = rgb2hsv(im); %Comvierte a HSV
if ~exist('hsv','var'), hsv=3; end
referencia = imHSV(100,80:380,hsv);  % Guarda linea de control (cinta vacia) 
                                   % Selecciona componente V
umbral1 = 0.5;
umbral2 = 20;

if ~exist('pausar','var'), pausar=false; end
dentro = 0;
while not(fin) && hasFrame(v)
    im    = readFrame(v);          %Tomar nueva imagen
    imHSV = rgb2hsv(im);           %Convertir a HSV
    nueva = imHSV(100,80:380,hsv);   %Seleccionar linea de control 
    dif   = abs(referencia-nueva); %Calcula las direncias en la linea de control
    
    subplot(2,1,1),
    imshow(im);                    %Muestra la imagen RGB
    hold on
    if (sum(dif>umbral1)>umbral2)
        plot([80 380],[100 100],'-r');
        if pausar && not(dentro)
            dentro = 1;
            pause;
        end
    else
        plot([80 380],[100 100],'-g');
        if pausar && dentro
            dentro = 0;
        end
    end
    
    hold off
    %---------------------------
    subplot(2,1,2),
    plot(dif);                       %Muestra las diferencias
    axis ([1 300, 0 1]); grid on
    drawnow
end
close(f)
end

function Pausar(~,~)
    pause;
end

function Terminar(~,~)
       global fin
   fin = 1;
end
