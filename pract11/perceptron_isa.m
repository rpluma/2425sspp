function w = perceptron (patrones1,patrones2,c);

cambio = 1;                             % Variable de control de finilizacion
w = zeros(size(patrones1,2)+1,1);       % Inicializar vector de pesos a cero
p1 = size (patrones1,1);                % Numero de patrones de la clase 1 
p2 = size (patrones2,1);                % Numero de patrones de la clase 2
while (cambio == 1)                     % Recorrer muestra completa mientras haya cambio en los pesos
    cambio = 0;
    for k = 1:p1                        % Comprobar clasificacion de los patrones de la clase 1
        p = [patrones1(k,:),1];
        if (w'*p' <= 0)                 % Si mal clasificado modificar pesos 
            w = w + c*p';
            cambio = 1;
        end
    end
    for k = 1:p2                        % Comprobar clasificacion de lo patrones de la clase 2
        p = [patrones2(k,:),1];         
        if (w'*p' >= 0)                 % Si mal clasificado modificar pesos
            w = w - c*p';
            cambio = 1;
        end
    end
end

figure,
hold on
plot (patrones1(:,1),patrones1(:,2),'ro');
plot (patrones2(:,1),patrones2(:,2),'*');
axis image
axis manual
x = -0.11:0.01:1;
y = -(w(1)*x+w(3))/w(2);
plot (x,y,'k');
w = w';