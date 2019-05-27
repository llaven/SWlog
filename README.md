# SWlog
Sencilla bitácora para el registro de estaciones de radio (hertzianas) SWL desde la terminal de Linux (Bash Script).

Requerimientos:

1. Tener instalado dialog `apt install dialog`
2. Además tener los siguientes comandos (casi todas las distrubiciones lo tienen): cal, sed, date, nano, grep


Instrucciones:

1. Descargue el archivo swlog.sh y agregue permisos de ejecución: `chmod +x swlog.sh`
2. Ejecute `./swlog.sh` y selecciones alguna opción.
3. El registro de las estaciones captadas se guardan en un archivo de texto simple en formato CSV.

Datos
------

**Estación**
Dependiendo de la frecuencia y horario busco el nombre de la estación en: http://www.shortwaveschedule.com/index.php?freq=9420 quizá posteriormente con CURL pueda hacer una selección automática de este metadato.

**Frecuencia**
Se obtiene de la lectura del radio receptor y se ingresa en kilohertz.

**Hora**
Generado por el programa en UTC.

**Fecha**
Generado por el programa en formato DD/MM/YYYY.

**SINPO**
Para no perder la tradición de la SWL este dato es una calificación subjetiva que provee el escucha para mayor referencia lea la opción SINPO Info

**GRID**
La radioafición ha distribuído el mundo en cuadrículas rectangulares llamadas GRID, ayudan a ubicar de forma aproximada (no exacta) la zona donde se encuentra el transmisor o receptor de una señal radioeléctrica, a partir de ello se puede calcular la distancia en kilómetros entre transmisor y receptor o viceversa.

Para obtener esta información ingrese a la opción Grid locator del menú principal.

* Para conocer el GRID de algún punto geográfico: http://www.levinecentral.com/ham/grid_square.php
* Para obtener la distancia entre transmisor y receptor: https://www.chris.org/cgi-bin/finddis Posteriormente crearé la función para calcular la distancia entre dos grids (dos puntos geográficos).



¡Qué viva la Radio!

73's
