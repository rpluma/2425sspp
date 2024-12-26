function VisualizarVideo(fichero)
% Muestra sobre una figura el video contenido en fichero especificado con
% entrada. Se muestra fra me a frame hasta completar el fichero o se emplee
% la rueda del ratón sobre la figura. Se puede pausar el video haciendo
% click sobre la figure, reanudansose al pulsar una tecla.

% Define las condiciones de finalización y pausa del programa, se invoca 
% a la función 'Terminar' o 'Pausar' por medio del ratón.

global fin
fin = 0;
f = figure;
f.ButtonDownFcn = @Pausar;
f.WindowScrollWheelFcn = @Terminar;
%--------------------------------------------------------------

v = VideoReader(fichero); % Abre el fichero y se posiciona sobre el 
                          % primer frame, el objeto video se define
                          % sobre la variable 'v'

% Se ejecuta hasta que se complete en video o se cancele la ejecución. 
imPrev = rgb2gray(readFrame(v)); %Lee el siguente frame del fichero.
while (not(fin) && hasFrame(v)) 
    im    = readFrame(v); %Lee el siguente frame del fichero.
    imshow (im);
    drawnow;
end
close % cierra la ventana
end

function Pausar(~,~)
   pause
end

function Terminar(~,~)
   global fin
   fin = 1;
end