# Resultados del modelo ARDL–MCE

**Incidencia de la deuda predial pendiente de cobro sobre la ejecución de la inversión pública**  
Municipalidad Distrital de José Leonardo Ortiz, 2018–2025

---

## 1. Pruebas de raíz unitaria (ADF)

| Variable          | p-valor (nivel) | p-valor (1ª diferencia) | Orden de integración |
|-------------------|-----------------|--------------------------|----------------------|
| ln_devengado      | 0.0100          | 0.01                     | **I(0)**             |
| ln_deuda          | 0.2401          | 0.01                     | **I(1)**             |
| ln_recaudacion    | 0.0100          | 0.01                     | **I(0)**             |
| ln_foncomun       | 0.0449          | 0.01                     | **I(0)**             |
| ln_pim            | 0.2607          | 0.01                     | **I(1)**             |
| ln_monto_viable   | 0.0248          | 0.01                     | **I(0)**             |
| Morosidad         | 0.0100          | 0.01                     | **I(0)**             |

> Las series son una mezcla de I(0) e I(1). El enfoque ARDL es apropiado.

---

## 2. Prueba de límites (Bounds Test) – Pesaran, Shin & Smith (2001)

| Prueba | Estadístico | p-valor     | Conclusión                          |
|--------|-------------|-------------|-------------------------------------|
| **F**  | 32.902      | < 0.000001  | Se rechaza H₀ de no cointegración   |
| **t**  | −13.608     | < 0.000001  | Se rechaza H₀ de no cointegración   |

**Existe una relación de cointegración (equilibrio de largo plazo).**

---

## 3. Velocidad de ajuste (Error Correction Term)

| Término | Coeficiente | Error Est. | t-valor  | p-valor   |
|---------|-------------|------------|----------|-----------|
| **ect** | **−1.1612** | 0.0802     | −14.483  | < 0.001   |

- El coeficiente es **negativo y altamente significativo**.
- Indica una corrección rápida hacia el equilibrio de largo plazo.
- Nota: el valor absoluto > 1 sugiere un ajuste oscilatorio/overshooting, frecuente en series mensuales con estacionalidad fuerte (efecto diciembre).

---

## 4. Coeficientes de corto plazo (MCE)

| Variable                    | Coeficiente | Error Est. | t-valor | p-valor  | Significancia |
|-----------------------------|-------------|------------|---------|----------|---------------|
| (Intercept)                 | −9.7177     | 0.6638     | −14.641 | < 0.001  | ***           |
| d(ln_recaudacion)           | 0.1153      | 0.1140     | 1.012   | 0.315    |               |
| d(L(ln_recaudacion, 1))     | −0.2331     | 0.0705     | −3.306  | 0.001    | **            |
| Morosidad                   | −0.0013     | 0.0059     | −0.221  | 0.826    |               |
| DUMMIE_COVID                | 0.0293      | 0.0401     | 0.731   | 0.467    |               |
| DUMMIE_Est                  | 0.1664      | 0.0944     | 1.763   | 0.082    | .             |
| n_proyectos_viab            | −0.0102     | 0.0093     | −1.096  | 0.276    |               |
| **D_dic**                   | **0.9747**  | 0.0960     | 10.151  | < 0.001  | ***           |

> El dummy de diciembre (D_dic) es el efecto más fuerte y significativo en el corto plazo (estacionalidad de cierre de año).

---

## 5. Multiplicadores de largo plazo

| Variable          | Coeficiente | Error Est. | t-valor | p-valor |
|-------------------|-------------|------------|---------|---------|
| (Intercept)       | −8.3684     | 3.0123     | −2.778  | 0.007   |
| ln_deuda          | 0.1497      | 0.7958     | 0.188   | 0.851   |
| ln_recaudacion    | 0.4893      | 0.7570     | 0.646   | 0.520   |
| ln_foncomun       | 0.5511      | 0.3248     | 1.697   | 0.094   |
| ln_pim            | 0.2881      | 0.1933     | 1.491   | 0.140   |
| ln_monto_viable   | −0.0012     | 0.0023     | −0.543  | 0.589   |

> En el largo plazo ninguna variable de interés alcanza significancia convencional al 5 %. El FONCOMUN se acerca (p ≈ 0.09).

---

## 6. Diagnósticos del modelo

| Prueba              | Estadístico | p-valor | Conclusión (α = 5 %)          |
|---------------------|-------------|---------|-------------------------------|
| Breusch-Godfrey (1) | 0.4554      | 0.4998  | No se rechaza H₀ (sin AC)     |
| Breusch-Godfrey (4) | 1.9048      | 0.7533  | No se rechaza H₀ (sin AC)     |
| Breusch-Godfrey (12)| 7.1382      | 0.8483  | No se rechaza H₀ (sin AC)     |
| Jarque-Bera         | 0.4777      | 0.7875  | Residuos normales             |
| Breusch-Pagan       | 8.7370      | 0.3650  | Homocedasticidad              |

**El modelo cumple todos los supuestos de diagnóstico clásicos.**

---

## 7. Figuras del análisis

Las figuras se encuentran en `docs/informe_latex/figuras/`:

| Archivo                         | Descripción                              |
|---------------------------------|------------------------------------------|
| `fig1_series.png`               | Series en logaritmos (2018–2025)         |
| `fig2_ardl_ajustado.png`        | Valores reales vs ajustados (ARDL)       |
| `fig3_mce_ajustado.png`         | Valores reales vs ajustados (MCE)        |
| `fig4_pvalores_diagnostico.png` | p-valores de las pruebas de diagnóstico  |
| `fig5_residuos_mce.png`         | Residuos del MCE                         |
| `fig6_acf_residuos.png`         | Función de autocorrelación de residuos   |
| `fig7_histograma.png`           | Histograma de residuos                   |
| `fig8_diagnostico_mce.png`      | Panel de diagnósticos del MCE            |
| `fig9_cusum.png`                | CUSUM y CUSUM-SQ (estabilidad)           |

---

## 8. Archivos de resultados

- `resultados_ARDL_MCE.xlsx` — Tablas completas exportadas desde R
- `Resultados_consola.txt` — Log completo de la estimación

---

*Generado a partir de la estimación ARDL (orden BIC: 1,0,2,0,0,0) + recm (caso 3).*
