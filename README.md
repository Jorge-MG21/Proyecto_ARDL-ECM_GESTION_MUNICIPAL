# Análisis de la incidencia de la deuda predial pendiente de cobro y la morosidad sobre la ejecución de la inversión pública de la Municipalidad Distrital de José Leonardo Ortiz

**Periodo de análisis:** 2018–2025 (96 observaciones mensuales)  
**Modelo:** ARDL + Modelo de Corrección de Errores (MCE)  
**Autores:** Cajo Facho Mary · Pérez Flores Fiorella · Mera Gonzales Jorge  
**Institución:** Facultad de Ciencias Económicas – Universidad de San Martín de Porres (Filial Norte)

---

## Archivos

| Archivo | Descripción |
|---------|-------------|
| [`scripts/script_ardl_mce.R`](scripts/script_ardl_mce.R) | Script ARDL + MCE (especificación principal) |
| [Datos mensuales 2015–2025](https://usmppe-my.sharepoint.com/:x:/g/personal/jorge_mera_usmp_pe/cQp6h3Aqx54cQbc15RxBmovKEgUC05TUepadvfu6FdXX7PPXow) | Serie principal del modelo (Excel) |
| [`data/proyectos.csv`](data/proyectos.csv) | Inventario de proyectos de inversión (CUI, montos, avance) |
| [`results/RESULTADOS_ARDL_MCE.md`](results/RESULTADOS_ARDL_MCE.md) | Informe completo de resultados, tablas e interpretación |
| [`results/Resultados_consola.txt`](results/Resultados_consola.txt) | Salida completa de la estimación en R |
| `results/resultados_ARDL_MCE.xlsx` | Tablas exportadas (ADF, Bounds, coeficientes, diagnósticos) |
| `docs/informe_latex/` | Informe técnico en LaTeX + figuras del modelo |

---

## Especificación de variables

| Variable (código) | Descripción | Unidad / escala | Rol en el modelo |
|-------------------|-------------|-----------------|------------------|
| **ln_devengado** | Logaritmo del gasto de inversión devengado | log(S/) | Variable dependiente |
| **ln_deuda** | Logaritmo de la deuda predial pendiente de cobro | log(S/) | Regresor de largo plazo |
| **ln_recaudacion** | Logaritmo de la recaudación de ingresos propios | log(S/) | Regresor de largo plazo |
| **ln_foncomun** | Logaritmo de las transferencias del FONCOMUN | log(S/) | Regresor de largo plazo |
| **ln_pim** | Logaritmo del Presupuesto Institucional Modificado (inversión) | log(S/) | Regresor de largo plazo |
| **ln_monto_viable** | Logaritmo del monto de proyectos viables (log1p) | log(1 + S/) | Regresor de largo plazo |
| **Morosidad** | Tasa de morosidad del impuesto predial | % | Control exógeno |
| **n_proyectos_viab** | Número de proyectos viabilizados en el mes | enteros | Control exógeno |
| **DUMMIE_COVID** | Dummy del periodo de pandemia (COVID-19) | 0 / 1 | Control exógeno |
| **DUMMIE_Est** | Dummy de estacionalidad fiscal (cierre / inicio de ejercicio) | 0 / 1 | Control exógeno |
| **D_dic** | Dummy de diciembre (cierre de año presupuestal) | 0 / 1 | Control exógeno |

**Fórmula del modelo ARDL:**

```
ln_devengado ~ ln_deuda + ln_recaudacion + ln_foncomun + ln_pim + ln_monto_viable
              | Morosidad + DUMMIE_COVID + DUMMIE_Est + n_proyectos_viab + D_dic
```

Orden seleccionado por **BIC**: (1, 0, 2, 0, 0, 0)

---

## Procedencia de los datos

| Fuente | Contenido | Periodo |
|--------|-----------|--------|
| **Municipalidad Distrital de José Leonardo Ortiz** (área de Rentas / Tributación) | Deuda predial pendiente de cobro, recaudación de ingresos propios y tasa de morosidad | 2018–2025 |
| **Sistema de Administración Financiera (SIAF) / MEF** | Devengado de inversión pública, Presupuesto Institucional Modificado (PIM) y transferencias del FONCOMUN | 2018–2025 |
| **Sistema de seguimiento de inversiones (SSI) – MEF** | Proyectos de inversión: fecha de viabilidad, monto viable, costo total, avance financiero y liquidación | 2018–2025 |

- **Unidad de observación:** mes  
- **Periodo utilizado en el modelo:** enero 2018 – diciembre 2025 (96 observaciones)  
- **Transformaciones:** todas las variables monetarias se expresan en logaritmos naturales; `monto_viable` usa `log(1 + x)` por la presencia de ceros.

---

## Resultados principales

| Aspecto | Resultado |
|---------|-----------|
| Cointegración (Bounds F / t) | **Sí** (F = 32.90 · t = −13.61 · p < 0.000001) |
| Velocidad de ajuste (ECT) | **−1.161** (p < 0.001) |
| Dummy diciembre (corto plazo) | **+0.975** (muy significativo) |
| Diagnósticos (BG, JB, BP) | Todos OK (no se rechaza H₀ al 5 %) |

📄 **Ver tablas completas e interpretación →** [`results/RESULTADOS_ARDL_MCE.md`](results/RESULTADOS_ARDL_MCE.md)

---

## Estructura del repositorio

```
├── README.md
├── data/
│   ├── Nueva_dta.csv              # Serie mensual principal
│   ├── proyectos.csv              # Inventario de proyectos
│   └── README.md
├── scripts/
│   └── script_ardl_mce.R          # Script de estimación (versión de trabajo)
├── results/
│   ├── RESULTADOS_ARDL_MCE.md     # Tablas e interpretación
│   ├── Resultados_consola.txt
│   └── resultados_ARDL_MCE.xlsx
└── docs/
    └── informe_latex/
        ├── main.tex
        └── figuras/               # Gráficos del modelo
```

---

## Cómo reproducir

Instalar las librerías necesarias (una por una):

```r
install.packages("readxl")
install.packages("writexl")
install.packages("tseries")
install.packages("ARDL")
install.packages("lmtest")
install.packages("sandwich")
install.packages("strucchange")
install.packages("car")
```

Ejecutar el script:

```bash
Rscript scripts/script_ardl_mce.R
```

> El script utiliza rutas locales. Ajuste las variables `ruta` y `carpeta` al inicio del archivo según su entorno.

---

## Licencia

Proyecto académico. Uso libre con debida citación de los autores.
