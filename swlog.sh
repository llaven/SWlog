#!/bin/bash
# SWlog - Es un sencillo programa en Bash para administrar a través de la terminal de linux una bitácora de Radio Escucha (SWL)
# Autor: Carlos Emilio Ruiz Llaven
# Site: www.emilio.com.mx
# Github: /llaven

# Archivo temporal de intercambio
TEMP=temp
# Editor
editor=${EDITOR-nano swlog.csv}


#
#	FUNCIONES
#


#
# Display: muestra información en pantalla en un msgbox
#
function display(){
  local h=${1-10}     # box height default 10
  local w=${2-41}     # box width default 41
  local t=${3-Output}   # box title 
  dialog --backtitle "SWlog" --title "${t}" --clear --msgbox "$(<$TEMP)" ${h} ${w}
}
#
# Calendario: muestra las fechas y días del mes actual
#
function calendario(){
  cal >$TEMP
  display 13 25 "[ Calendario ]"
}
#
# Nuevo: Agrega un registro al archivo swlog.csv (separado por comas)
#
function nuevo(){
utc=$(date -u +%T)
#date "+%A %d de %B de %Y"
fecha=$(date '+%d/%m/%Y')
dialog --backtitle "SWlog - nuevo registro" --title "Formato de registro" \
--form "Nuevo registro" 25 100 16 \
"Estación:" 1 1 "" 1 18 25 30 \
"Frecuencia (khz):" 2 1 "" 2 18 7 10 \
"Hora:" 3 1 "$utc utc" 3 18 8 30 \
"Fecha:" 4 1 "$fecha" 4 18 10 30 \
"SINPO:" 5 1 "" 5 18 6 5 \
"Modo:" 6 1 "A.M." 6 18 6 5 \
"GRID:" 7 1 "" 7 18 7 6 \
"Distancia (kms):" 8 1 "" 8 18 9 8 \
"Observaciones:" 9 1 "" 9  18 70 255 >"${TEMP}" \
 2>&1>/dev/tty
# Comienza a conseguir cada línea del archivo swlog.txt
input1=`sed -n 1p "${TEMP}"`
input2=`sed -n 2p "${TEMP}"`
input3=`sed -n 3p "${TEMP}"`
input4=`sed -n 4p "${TEMP}"`
input5=`sed -n 5p "${TEMP}"`
input6=`sed -n 6p "${TEMP}"`
input7=`sed -n 7p "${TEMP}"`
input8=`sed -n 8p "${TEMP}"`
input9=`sed -n 9p "${TEMP}"`
# Borramos el archivo temporal
rm -fr "$TEMP"
#Revisamos que las variables no esten vacías y si no es así escribimos el resultado en el archivo final
if [ "$input1" != "" ];
  then
	 echo $input1, $input2, $input3, $input4, $input5, $input6,$input7,$input8,$input9>>swlog.csv 
fi
}
#
# Consultar: Visualiza todo el archivo csv
#
function consultar(){
  # Formateamos el CSV original para obtener una vista agradable
  cat swlog.csv | sed -e 's/,,/, ,/g' | column -s, -t | less -#5 -N -S | head -n 1 >"${TEMP}"
  cat swlog.csv | sed -e 's/,,/, ,/g' | column -s, -t | less -#5 -N -S | tac >>"${TEMP}"
  dialog  --backtitle 'SWlog - todos los registros guardados' --no-mouse --scrollbar  --title '[ Registros ]'  --textbox "${TEMP}" 30 150
}
#
# Buscar: Realizar una consulta en el CSV
#
function buscar(){
dialog --backtitle "SWlog - Buscar en el log" --title "Formato de registro" \
--form "Buscar..." 8 50 0 \
"Término a buscar:" 1 1 "" 1 18 20 30 2>"${TEMP}" 
#Revisamos que las variables no esten vacías y si no es así escribimos ejecutamos la búsqueda
if [ $(<"${TEMP}") != "" ];
		then
		grep -w $(<"${TEMP}") swlog.csv >$TEMP
		display 10 195 "[ Resultado de búsqueda ]"
fi
}
#
# Reloj: muestra la hora utc local
#
function reloj(){
	listaUtc=' _______________________
| UTC   |NORMAL |VERANO |
|-------|-------|-------|
| 11:00 | 05:00 | 06:00 |
| 12:00 | 06:00 | 07:00 |
| 13:00 | 07:00 | 08:00 |
| 14:00 | 08:00 | 09:00 |
| 15:00 | 09:00 | 10:00 |
| 16:00 | 10:00 | 11:00 |
| 17:00 | 11:00 | 12:00 |
| 18:00 | 12:00 | 13:00 |
| 19:00 | 13:00 | 14:00 |
| 20:00 | 14:00 | 15:00 |
| 21:00 | 15:00 | 16:00 |
| 22:00 | 16:00 | 17:00 |
| 23:00 | 17:00 | 18:00 |
| 00:00 | 18:00 | 19:00 |
| 01:00 | 19:00 | 20:00 |
| 02:00 | 20:00 | 21:00 |
| 03:00 | 21:00 | 22:00 |
| 04:00 | 22:00 | 23:00 |
| 05:00 | 23:00 | 00:00 |
| 06:00 | 00:00 | 01:00 |
| 07:00 | 01:00 | 02:00 |
| 08:00 | 02:00 | 03:00 |
| 09:00 | 03:00 | 04:00 |
| 10:00 | 04:00 | 05:00 |
 -----------------------
'
utc= $(date -u +%T)
local= $(date +%T)

horario="
     UTC         LOCAL
  $utc     $local"
	echo -e "$horario" >$TEMP
	echo -e "$listaUtc" >>$TEMP
  dialog  --backtitle 'SWlog - utc' --no-mouse   --title '[ UTC ]'  --textbox "${TEMP}" 20 30
}
#
# SINPO: Muestra información sobre el código SINPO
#
function sinpo(){
	sinpo='
| S                          |  I           |  N             |  P**              |  O***         |
| -------------------------- | ------------ | -------------- | ----------------- | ------------- |
| 5 excelente más de 9+20 dB |  5 nulo      |  5 nulo        |  5 ninguna 0      |  5 excelente  |
| 4 buena de 9 a 9+20 dB     |  4 ligero    |  4 ligero      |  4 ligeras 5      |  4 buena      |
| 3 aceptable de 5 a 9 dB    |  3 moderado* |  3 moderado    |  3 moderada 5-10  |  3 aceptable  |
| 2 mala de 2 a 5 dB         |  2 intenso*  |  2 intenso     |  2 intensas 10-20 |  2 pobre      |
| 1 inaudible de 1 a 2 dB    |  1 extremo*  |  1 extrema +20 |  1 inservible +20 |  1 inservible |

* Reportar tipo de interferencia: estación, morse, tty, etc.
** Fluctuaciones por minuto
*** El Overall no puede ser mayor que la interferencia
'
	echo -e "$sinpo" >$TEMP
  dialog  --backtitle 'SWlog - Código SINPO' --no-mouse   --title '[ CÓDIGO SINPO ]'  --textbox "${TEMP}" 20 110
}
#
# GRID: Busca el Grid Locator de una localidad utilizando: http://www.levinecentral.com/ham/grid_square.php?Address=LUGAR
#
function grid(){
dialog --backtitle "SWlog - Buscar Grid Locator" --title "GRID" \
--form "Buscar..." 8 50 0 \
"Grid a buscar:" 1 1 "" 1 18 20 30 2>"${TEMP}" 
#Revisamos que las variables no esten vacías y si no es así escribimos ejecutamos la búsqueda
if [ $(<"${TEMP}") != "" ];
    then
 curl -s http://www.levinecentral.com/ham/grid_square.php?Address=$(<"${TEMP}") | grep 'Grid:' | grep -o -P '(?<=Grid: <font color="blue"><b>).*(?=</b>)' >>$TEMP
 display 8 25 "[ Resultado de búsqueda ]"
fi
}
#
# Menú principal
#
while true
do
utc=$(date -u +%T)
local=$(date +%T)
fecha=$(date '+%A %d de %B de %Y')
#date "+%A %d de %B de %Y"
dialog --backtitle "SWlog - $fecha - $utc UTC - $local LOCAL" --title "[ -= M E N Ú =- ]" --menu "Selecciones una opción..." 16 60 15 \
Nuevo "registro" \
Buscar "..." \
Consultar "todos los registros" \
Editar "log" \
Grid "locator" \
Reloj "Hora UTC" \
SINPO "Info" \
Calendario "Calendario" \
Salir "Salir" 2>"${TEMP}" \

menuitem=$(<"${TEMP}")

# Tomar una decisión 
case $menuitem in
  Nuevo) nuevo;;
  Buscar) buscar;;
  Consultar) consultar;;
  Editar) $editor;;
	Grid) grid;;
  Reloj) reloj;;
  SINPO) sinpo;;
  Calendario) calendario;;
  Salir) echo "73s"; break;;
esac

done

#Borrar archivos temporales
[ -f $TEMP ] && rm $TEMP



