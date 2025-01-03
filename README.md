# 2425sspp

## Entorno
```bash
cd /src/2425sspp

# conda install --channel https://conda.anaconda.org/menpo opencv3
conda install -n sspp numpy opencv jupyter matplotlib
conda update menuinst
conda install notebook
conda activate sspp
conda install urllib2
conda install -c conda-forge ffmpeg

conda install bokeh
conda list | find "matplotlib"
git ls-files -d (muestra ficheros borrados)

```

Enlaces:
- Librerías imágenes Python: https://neptune.ai/blog/image-processing-python-libraries-for-machine-learning
- Instalación fallida OpenCV: https://stackoverflow.com/questions/23119413/how-do-i-install-python-opencv-through-conda
- Dependencia opencv con python 3.7: https://github.com/conda/conda/issues/9664

## Tema 6 - Segmentación

1. Segmentación basada en frontera
	- Seguimiento de contornos: gradiente + dirección
		- Condiciones de similitud
			- Espacial: pixeles vecinos
			- Magnitud del gradiente
				- abs(G(x,y) - G(x',y')) < T
				- G(x,y) = sqrt(Gx(x,y)^2+Gy(x,y)^2) =aprox abs(Gx(x,y))+abs(Gy(x,y))
			- Dirección del gradiente
				- abs(Phi(x,y)-Phi(x',y')) < A
				- phi(x,y) = atan(Gy(x,y)/Gx(x,y))
	- Transformada de Hough
		- Rectas
		- Círculos
		- Generalizada
2. Segmentación basada en umbralización
3. Segmentación basada en regiones
4. Especificación de regiones de interés (ROIs)