#!/bin/bash
# ===================================================
# CPU-Energy-Dash - Mini-dashboard de CPU en tiempo real
#
# Descripción:
#   Script en Bash para monitorear el consumo de energía,
#   uso de CPU y temperatura en sistemas Linux con CPUs Intel
#   que soportan RAPL. Muestra un mini-dashboard con barras
#   gráficas y colores en la terminal.
#
# Autor:
#   Rodrigo Vil (Rodrigo47363)
#   Correo: rodrigovil@proton.me
#
# Repositorio GitHub:
#   https://github.com/rodrigo47363/
#
# Licencia:
#   MIT License
#
# Requisitos:
#   - Linux con Bash >= 4.0
#   - CPU Intel con soporte RAPL
#   - lm-sensors instalado (`sensors`)
#   - Comando `top` disponible
#
# Uso:
#   sudo ./cpu_energy_dash.sh
#   - Ctrl+C para detener el script de forma limpia
#
# Última actualización: 17-Oct-2025
# ===================================================

# ================= Configuración ===================
RAPL_PATH="/sys/class/powercap/intel-rapl/intel-rapl:0/energy_uj"
UPDATE_INTERVAL=1       # Segundos entre lecturas
BAR_LENGTH=25           # Largo de las barras gráficas
MAX_WATTS=100           # Consumo máximo esperado de la CPU
TEMP_WARNING=85         # Temperatura de advertencia (°C)
# ===================================================

# Verifica si RAPL existe
if [ ! -f "$RAPL_PATH" ]; then
    echo -e "\e[31mRAPL no encontrado. Este script solo funciona en CPUs Intel con RAPL.\e[0m"
    exit 1
fi

# Captura Ctrl+C
trap "echo -e '\n\e[33mMonitor detenido\e[0m'; exit" SIGINT

# Función para barras gráficas (porcentaje)
bar() {
    local PERC=$(printf "%.0f" "$1")  # redondea a entero
    [ "$PERC" -gt 100 ] && PERC=100
    [ "$PERC" -lt 0 ] && PERC=0
    local FILLED=$(( PERC * BAR_LENGTH / 100 ))
    local EMPTY=$(( BAR_LENGTH - FILLED ))
    local FILLED_BAR=$(printf "%${FILLED}s" | tr ' ' '#')
    local EMPTY_BAR=$(printf "%${EMPTY}s" | tr ' ' '-')
    echo -e "[\e[32m$FILLED_BAR\e[0m\e[37m$EMPTY_BAR\e[0m]"
}

# Función para barra de watts proporcional al máximo
bar_watts() {
    local WATTS=$(printf "%.0f" "$1")
    local PERC=$(( WATTS * 100 / MAX_WATTS ))
    [ $PERC -gt 100 ] && PERC=100
    echo "$(bar $PERC)"
}

# Función para mostrar temperatura con color de advertencia
color_temp() {
    local T="$1"
    local T_INT=${T%.*}
    if [ "$T_INT" -ge "$TEMP_WARNING" ]; then
        echo -e "\e[1;41m$T\e[0m"  # Fondo rojo si está caliente
    else
        echo -e "\e[31m$T\e[0m"     # Rojo normal
    fi
}

# =================== Loop principal ===================
while true; do
    ENERGY1=$(cat "$RAPL_PATH")
    TIME1=$(date +%s)

    CPU_USAGE=$(top -bn2 | grep "Cpu(s)" | tail -n1 | awk '{print 100-$8}')
    TEMP=$(sensors | grep "Package id 0:" | awk '{print $4}')

    sleep "$UPDATE_INTERVAL"

    ENERGY2=$(cat "$RAPL_PATH")
    TIME2=$(date +%s)

    DELTA_J=$(( (ENERGY2 - ENERGY1) / 1000000 ))
    DELTA_T=$(( TIME2 - TIME1 ))
    WATTS=$(echo "scale=2; $DELTA_J / $DELTA_T" | bc)

    WATTS_INT=$(printf "%.0f" "$WATTS")
    CPU_INT=$(printf "%.0f" "$CPU_USAGE")

   
  # =================== Dashboard ===================
clear
echo -e "\e[1;34m================ CPU-Energy-Dash =====================\e[0m"
echo -e "Consumo CPU: $WATTS W $(bar_watts $WATTS_INT)"
echo -e "Uso CPU:     $CPU_USAGE % $(bar $CPU_INT)"
echo -e "Temperatura: $(color_temp $TEMP)"
echo -e "\e[1;34m======================================================\e[0m"

    
    sleep 0.5
done
