# Resultados del modelo ARDL-MCE

## Archivos

| Archivo | Descripción |
|---------|-------------|
| `resultados_ARDL_MCE.xlsx` | Hojas: ADF, Bounds, Velocidad_ajuste, Corto_plazo, Largo_plazo, Diagnosticos, ARDL_coef |
| `Resultados_consola.txt` | Salida completa de la ejecución del script en R |

## Cómo agregar el Excel de resultados

Subir el archivo `resultados_ARDL_MCE.xlsx` (proporcionado en la conversación) a esta carpeta `results/` mediante la interfaz de GitHub (**Add file → Upload files**).

## Interpretación rápida

- **Bounds F y t**: cointegración confirmada (p < 0.000001).
- **ECT = −1.161**: ajuste muy rápido y significativo hacia el equilibrio de largo plazo.
- **Diagnósticos**: todos los tests (BG, JB, BP) no rechazan H₀ al 5 % → modelo bien especificado.
