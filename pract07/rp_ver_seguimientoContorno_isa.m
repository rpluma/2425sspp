function contorno = rp_ver_seguimientoContorno_isa(im)

    im = im (3:end-3,3:end-3); % Quitar extremos de la imagen
    contorno = [];                   % Objeto segmentado 

    %global coor;
    %global deltac;
    %global sentido;

    sentido = 1;    % Explorar en ambos senrtidos +-90º de la dirección 
                    % gradiente

    % Calculo del modulo y dirección del gradiente (operador sobel 3x3)
    m = [-1 -2 -1; 0 0 0; 1 2 1];
    imgx = conv2(double(im),double(m));       % Gradiente horizontal
    imgy = conv2(double(im),double(m'));      % Gradiente vertical
    imgm = (abs(imgx)+abs(imgy));           % Módulo gradiente
    imgm = imgm/(max(max(imgm)));             % Módulo gradiente normalizado
    imgd = atan2(imgy,imgx);                  % Dirección gradiente (radianes)

    figure, imshow(imgm,[]); % Mostrar imagen del modulo del gradiente
    hold on

    [y,x] = ginput(1); % Seleccionar primer punto

    f = round(x(1)); 
    c = round(y(1));
    origen = [f, c, imgm(f,c)] % fila, columna y gradiente del punto elegido

    % Seleccionar el punto de gradiente máximo en una ventana un entorno
    % de 41x41 respecto al punto elegido
    busqueda = imgm(f-20:f+20,c-20:c+20);
    [df,dc] = find(busqueda == max(max(busqueda)));
    f = f+df(1)-21; % Fila de punto de comienzo
    c = c+dc(1)-21; % Columna del punto de comienzo

    % Marcar punto inical
    plot(c,f,'*');
    plot(c,f,'o');

    % siguiente = 0;
    % fin = 0;

    % ob1f = f;          % Contendrá las filas del contorno segmentado 
    % ob1c = c;          % Contendrá las columnas del contorno segmentado
    % ob1n = imgm(f,c);   % Contendrá el gradiente del contorno segmentado

    sentidoAct = 1;  
    sentidoSig = 1; 

    % Coordenadas de vecinos con respecto al punto de seguimiento.
    coor  = [-1 0; -1 -1; 0 -1; 1 -1; 1 0; 1 1; 0 1; -1 1];

    while not(sentidoAct == 0)  % Mientras se añadan puntos al contorno
    
        % Detectar cambio de sentido de 1 a -1 (contorno no cerrado)
        if (sentidoAct == 1) && (sentidoSig == -1) 
            f = origen(1); % restablecer coordenadas
            c = origen(2);
            imgm(f, c) = origen(3); % restablecer gradiente
        end
        sentidoAct = sentidoSig;

        % Añade punto al contorno
        contorno = [contorno;f,c];
      
        niveles = imgm(f-1:f+1,c-1:c+1); % Gradiente de los 8 vecinos
        angulos = imgd(f-1:f+1,c-1:c+1); % Dirección gradiente de los 8 vecinos
        
        % Busca el mejor candidato si los hay, fin = 1 si no los hay
        [incFila, incColu, sentidoSig] = nuevopunto(niveles, angulos, sentidoAct);
        
        angulosn = mod(round(((angulos+pi)/(2*pi))*8),8); 
        dircont(1)  = angulosn(2,2);
        dircont(2)  = mod(((angulosn(2,2)-4)+8),8);
        
        imgm(f,c) = -1;  % Borra el gradiente del punto incorporado
        
        for k = 1:2     % Borra el gradiente de los puntos a +-90º 
                        % del punto incorporado.
            %incx = coor(dircont(k)+1,1);
            %incy = coor(dircont(k)+1,2);
            %imgm(f+incx,c+incy) = -1;       
            imgm(f+coor(dircont(k)+1,1),c+coor(dircont(k)+1,2)) = -1;
        end
    
        imc(f,c,:) = [0 1 0];  % Permite ver pixel en verde 
        
        % Punto incorporado al contorno
        f = f + incFila;
        c = c + incColu;
        % siguiente = imgm(f,c);

        plot(c,f,'g.');
        drawnow
    end

    function [incFila,incColu,sentidoSig] = nuevopunto(niveles,angulos, sentidoAct)

        %global coor;
        %global deltac;
        %global sentido;
        
        % Coordenadas de vecinos 
        %deltac = coor + 2; %
        deltac  = [-1 0; -1 -1; 0 -1; 1 -1; 1 0; 1 1; 0 1; -1 1] + 2;

        % Diferencia en gradiente y angulo en los 8 vecinos
        deltaGm = abs(niveles-niveles(2,2));
        deltaGa = abs(cos(angulos)-cos(angulos(2,2)));

        angulosn = mod(round(((angulos+pi)/(2*pi))*8),8);
        
        % Posibles cadidados
        d(1)  = mod(((angulosn(2,2)+2*sentidoAct)+8),8);
        d(2)  = mod(((d(1)-1)+8),8);
        d(3)  = mod(((d(1)+1)+8),8);

        for k = 1:3
            x = deltac(d(k)+1,1);
            y = deltac(d(k)+1,2);
            dgr(k) = deltaGm(x,y);
            gr(k) = niveles(x,y);
            dan(k) = deltaGa(x,y);
        end

    
        candidatos = find(dgr<0.5  &  dan < pi/4 & gr >= 0.01); %& dan < pi/10
        
        n = [];
        for k = 1:numel(candidatos)
          n(k) = niveles(deltac(d(candidatos(k))+1,1),deltac(d(candidatos(k))+1,2));
        end
        

        if isempty(n)
            incFila = 0;
            incColu = 0;
            if (sentidoAct == -1)
                sentidoSig = 0; % algoritmo acaba
            else % sentidoAct == 1
                sentidoSig = -1; % cambiamos al sentido contrario
            end
        else
            [m,in] = max(n);
            in = candidatos(in); 
            incFila = coor(d(in)+1,1);
            incColu = coor(d(in)+1,2);
            sentidoSig = sentidoAct; % seguimos en el mismo sentido
        end
    end
end