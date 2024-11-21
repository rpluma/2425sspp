function esq = veradel (im)

% Calcula el esqueleto de una imagen binaria mediante el algoritmo de Zang y Suen 
% mostrando sobre una imagen la progresión del resultado.

mx = size (im,1);               %Calcula el tamaño de la imagen
my = size (im,2);           

im(:,1)   = 0;                  %Evita procesar los extremos de la imagen
im(:,end) = 0;
im(1,:)   = 0;
im(end,:) = 0;

figure
imshow (im,[])
drawnow;
im = (im > 0); % imagen binaria 0-1 

borrado = 1;
while (borrado) % mientras se borren puntos
   borrado = 0;
   [x,y] = find (im > 0); % seleccionar puntos del objeto FASE 1
   imb = im;
   for k = 1:size(x,1) % para los puntos del objeto
      u = x(k);
      v = y(k);
      p = [im(u,v),im(u,v-1),im(u+1,v-1),im(u+1,v),im(u+1,v+1),...
            im(u,v+1),im(u-1,v+1),im(u-1,v),im(u-1,v-1)];
      n = sum(p(2:9));
      s = sum((diff([p(2:9),p(2)])==1));
      c = p(2)*p(4)*p(6);
      d = p(4)*p(6)*p(8);
      if ((n>=2) & (n<=6) & (s==1) & (c==0) & (d==0))
         borrado = 1;
         imb (x(k),y(k)) = 0;
      end
   end
   im = im.*imb;          % borrar puntos FASE 1
   imshow (im*255,[]);
   
   [x,y] = find (im > 0); % seleccionar puntos del objeto FASE 2
   imb = im;
   drawnow;
   for k = 1:size(x,1) % para los puntos del objeto
      u = x(k);
      v = y(k);
      p = [im(u,v),im(u,v-1),im(u+1,v-1),im(u+1,v),im(u+1,v+1),...
           im(u,v+1),im(u-1,v+1),im(u-1,v),im(u-1,v-1)];
      n = sum(p(2:9));
      s = sum((diff([p(2:9),p(2)])==1));
      c = p(2)*p(6)*p(8);
      d = p(2)*p(4)*p(8);
      if ((n>=2) & (n<=6) & (s==1) & (c==0) & (d==0))
         borrado = 1;
         imb (x(k),y(k)) = 0;
      end
   end
   im = im.*imb;
   imshow (im*255,[]);     % borrar puntos FASE 2
   drawnow;
end

esq = im;


