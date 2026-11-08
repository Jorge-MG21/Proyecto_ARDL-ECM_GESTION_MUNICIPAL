# Incidencia de la deuda predial pendiente de cobro sobre la ejecución de la inversión pública

**Municipalidad Distrital de José Leonardo Ortiz (MDJLO), 2018–2025**

Análisis econométrico mediante modelos **ARDL** (Autoregressive Distributed Lag) y **MCE** (Modelo de Corrección de Errores) para evaluar el impacto de la deuda predial y la morosidad sobre la ejecución de la inversión pública municipal.

**Autores:** Cajo Facho Mary · Pérez Flores Fiorella · Mera Gonzales Jorge  
**Institución:** Facultad de Ciencias Económicas, Universidad de San Martín de Porres – Filial Norte

---

## Estructura del repositorio

```
├── README.md
├── data/                          # Datos de entrada
│   ├── Nueva_dta.csv              # Serie mensual principal (2015–2025)
│   └── proyectos.csv              # Inventario de proyectos de inversión
├── scripts/
│   └── script_ardl_mce.R          # Script principal de estimación ARDL + MCE
├── results/
│   ├── resultados_ARDL_MCE.xlsx   # Tablas de resultados (ADF, Bounds, coeficientes, diagnósticos)
│   └── Resultados_consola.txt     # Salida completa de la consola de R
└── docs/
    └── informe_latex/             # Informe técnico en LaTeX
        ├── main.tex
        └── figuras/               # Gráficos del modelo
            ├── fig1_series.png
            ├── fig2_ardl_ajustado.png
            ├── fig3_mce_ajustado.png
            ├── fig4_pvalores_diagnostico.png
            ├── fig5_residuos_mce.png
            ├── fig6_acf_residuos.png
            ├── fig7_histograma.png
            ├── fig8_diagnostico_mce.png
            └── fig9_cusum.png
```

---

## Resumen de resultados principales

### Orden de integración (ADF)

| Variable          | p-valor nivel | p-valor 1ª dif. | Orden |
|-------------------|---------------|-----------------|-------|
| ln_devengado      | 0.01          | 0.01            | I(0)  |
| ln_deuda          | 0.2401        | 0.01            | I(1)  |
| ln_recaudacion    | 0.01          | 0.01            | I(0)  |
| ln_foncomun       | 0.0449        | 0.01            | I(0)  |
| ln_pim            | 0.2607        | 0.01            | I(1)  |
| ln_monto_viable   | 0.0248        | 0.01            | I(0)  |
| Morosidad         | 0.01          | 0.01            | I(0)  |

### Prueba de límites (Bounds test)

| Prueba | Estadístico | p-valor   |
|--------|-------------|-----------|
| F      | 32.90       | < 0.000001|
| t      | −13.61      | < 0.000001|

**Conclusión:** Existe cointegración (relación de largo plazo).

### Velocidad de ajuste (ECT)

- Coeficiente: **−1.161** (p < 0.001)
- Significativo y negativo → corrección hacia el equilibrio de largo plazo.

### Diagnósticos del modelo

| Prueba            | Estadístico | p-valor | Conclusión (5%)      |
|-------------------|-------------|---------|----------------------|
| BG orden 1        | 0.455       | 0.500   | No se rechaza H₀ (OK)|
| BG orden 4        | 1.905       | 0.753   | No se rechaza H₀ (OK)|
| BG orden 12       | 7.138       | 0.848   | No se rechaza H₀ (OK)|
| Jarque-Bera       | 0.478       | 0.788   | No se rechaza H₀ (OK)|
| Breusch-Pagan     | 8.737       | 0.365   | No se rechaza H₀ (OK)|

El modelo cumple los supuestos de no autocorrelación, normalidad y homocedasticidad de los residuos.

---

## Cómo reproducir el análisis

1. Clonar el repositorio.
2. Instalar las librerías de R necesarias:
   ```r
   install.packages(c("readxl", "writexl", "tseries", "ARDL", "lmtest",
                      "sandwich", "strucchange", "car"))
   ```
3. Ejecutar:
   ```bash
   Rscript scripts/script_ardl_mce.R data/Nueva_dta.xlsx results/salida_ARDL
   ```
   (Nota: el script espera un archivo Excel con hoja “Hoja1”. Convertir el CSV si es necesario.)

---

## Informe completo

El documento técnico completo se encuentra en `docs/informe_latex/main.tex`.  
Puede compilarse con pdfLaTeX, XeLaTeX o LuaLaTeX (compatible con Overleaf).

---

## Licencia y uso

Proyecto académico. Uso libre con debida citación de los autores.
