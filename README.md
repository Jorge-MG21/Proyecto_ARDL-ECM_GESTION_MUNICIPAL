# Incidencia de la deuda predial pendiente de cobro sobre la ejecución de la inversión pública

**Municipalidad Distrital de José Leonardo Ortiz (MDJLO) · 2018–2025**

Análisis econométrico con modelos **ARDL** (Autoregressive Distributed Lag) y **MCE** (Modelo de Corrección de Errores).

**Autores:** Cajo Facho Mary · Pérez Flores Fiorella · Mera Gonzales Jorge  
**Institución:** Facultad de Ciencias Económicas – Universidad de San Martín de Porres (Filial Norte)

---

## Resultados principales (resumen)

| Aspecto                        | Resultado                                      |
|--------------------------------|------------------------------------------------|
| Cointegración (Bounds F / t)   | **Sí** (F = 32.90 · t = −13.61 · p < 0.000001) |
| Velocidad de ajuste (ECT)      | **−1.161** (p < 0.001)                         |
| Dummy diciembre (corto plazo)  | **+0.975** (muy significativo)                 |
| Diagnósticos (BG, JB, BP)      | Todos OK (no se rechaza H₀ al 5 %)             |

📄 **Ver resultados completos con tablas detalladas →** [`results/RESULTADOS_ARDL_MCE.md`](results/RESULTADOS_ARDL_MCE.md)

---

## Estructura del repositorio

```
├── README.md
├── data/                          # Datos de entrada
│   ├── Nueva_dta.csv
│   ├── proyectos.csv
│   └── README.md
├── scripts/
│   └── script_ardl_mce.R          # Script principal (limpio)
├── results/
│   ├── RESULTADOS_ARDL_MCE.md     # Tablas e interpretación
│   ├── Resultados_consola.txt
│   ├── resultados_ARDL_MCE.xlsx   # (subir Excel aquí)
│   └── README.md
└── docs/
    └── informe_latex/             # Informe técnico
        ├── main.tex               # (subir desde el zip)
        ├── figuras/               # Gráficos del modelo
        │   ├── fig1_series.png
        │   ├── fig2_ardl_ajustado.png
        │   ├── ...
        │   └── fig9_cusum.png
        └── README.md
```

---

## Cómo reproducir

```r
install.packages(c("readxl", "writexl", "tseries", "ARDL",
                   "lmtest", "sandwich", "strucchange", "car"))
```

```bash
Rscript scripts/script_ardl_mce.R data/Nueva_dta.xlsx results/salida_ARDL
```

---

## Informe LaTeX

El documento completo está en `docs/informe_latex/main.tex` (compilar con pdfLaTeX / Overleaf).  
Las figuras generadas por el modelo se encuentran en `docs/informe_latex/figuras/`.

---

## Licencia

Proyecto académico. Uso libre con debida citación de los autores.
