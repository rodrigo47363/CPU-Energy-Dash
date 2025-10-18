# CPU-Energy-Dash

Mini-dashboard de CPU en tiempo real para Linux con CPUs Intel que soportan RAPL.

## Descripción

**CPU-Energy-Dash** es un script en Bash que permite monitorear:

* Consumo de energía de la CPU (en watts)
* Uso total de CPU (%)
* Temperatura del procesador (°C)

Todo en un **dashboard en la terminal**, con **barras gráficas** y **colores**, ideal para mantener un control visual rápido del rendimiento energético de tu CPU.

---

## Características

* Visualización en tiempo real con actualización configurable.
* Barras gráficas proporcionales al consumo y uso de CPU.
* Indicador de temperatura con color de advertencia si se supera un umbral crítico.
* Compatible con CPUs Intel con soporte RAPL.
* Licencia MIT: libre de uso, modificación y distribución.

---

## Requisitos

* Linux con Bash >= 4.0
* CPU Intel con soporte RAPL
* `lm-sensors` instalado y configurado (`sensors`)
* Comando `top` disponible

---

## Instalación

1. Clona el repositorio:

```bash
git clone https://github.com/rodrigo47363/CPU-Energy-Dash.git
cd CPU-Energy-Dash
```

2. Dale permisos de ejecución al script:

```bash
chmod +x cpu_energy_dash.sh
```

3. Ejecuta el script con privilegios:

```bash
sudo ./cpu_energy_dash.sh
```

4. Para detener el monitor, presiona **Ctrl+C**.

---

## Configuración

Dentro del script puedes ajustar:

| Variable          | Descripción                                    | Valor por defecto |
| ----------------- | ---------------------------------------------- | ----------------- |
| `UPDATE_INTERVAL` | Segundos entre lecturas                        | 1                 |
| `BAR_LENGTH`      | Largo de las barras gráficas                   | 25                |
| `MAX_WATTS`       | Consumo máximo esperado de la CPU (para barra) | 100               |
| `TEMP_WARNING`    | Temperatura de advertencia (°C)                | 85                |

---

## Uso

```bash
sudo ./cpu_energy_dash.sh
```

El script muestra un dashboard en tiempo real similar a:

```
================ CPU-Energy-Dash =====================
Consumo CPU: 27 W [##########---------------]
Uso CPU:     15 % [####--------------------]
Temperatura: 72°C
======================================================
```

* Barras verdes para consumo y uso.
* Temperatura en rojo y fondo rojo si se supera el límite crítico.

---

## Autor

* **Rodrigo Vil** (Rodrigo47363)
* Correo: [rodrigovil@proton.me](mailto:rodrigovil@proton.me)
* GitHub: [https://github.com/rodrigo47363](https://github.com/rodrigo47363)

---

## Licencia

MIT License – libre de uso, modificación y distribución.


