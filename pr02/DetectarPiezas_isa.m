function DetectarPiezas_isa(fichero)

global fin;
global dif;
fin = 0;
f = figure;
f.ButtonDownFcn = @Pausar;
f.WindowScrollWheelFcn = @Terminar;

v = VideoReader(fichero);

umbral1 = 0.1;
umbral2 = 20;

im = readFrame(v); %Toma imagen de referencia

imHSV      = rgb2hsv(im); %Comvierte a HSV
%referencia = imHSV(100,80:380,1);  % Guarda linea de control (cinta vacia) 
%referencia = imHSV(100,80:380,2);  % Guarda linea de control (cinta vacia) 
referencia = imHSV(100,80:380,3);  % Guarda linea de control (cinta vacia) 
                                   % Selecciona componente V
estado = 0; % autómata para parar el vídeo sólo al inicio de la detección

while not(fin) && hasFrame(v)
    im    = readFrame(v);          %Tomar nueva imagen
    imHSV = rgb2hsv(im);           %Convertir a HSV
    %nueva = imHSV(100,80:380,1);   %Seleccionar linea de control 
    %nueva = imHSV(100,80:380,2);   %Seleccionar linea de control 
    nueva = imHSV(100,80:380,3);   %Seleccionar linea de control 
    dif   = abs(referencia-nueva); %Calcula las direncias en la linea de control
    
    haypieza=sum(dif>umbral1)>umbral2;

    subplot(2,1,1),
    imshow(im);                    %Muestra la imagen RGB
    hold on
    if haypieza
        plot([80 380],[100 100],'-r'); %Dibuja encima la linea de control (rojo)
        if estado == 0
            estado = 1;
            pause;
        end
    else
        plot([80 380],[100 100],'-g'); %Dibuja encima la linea de control (verde)
        estado = 0;
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
    global dif;
    dif
    pause;
end

function Terminar(~,~)
   global fin
   fin = 1;
end
