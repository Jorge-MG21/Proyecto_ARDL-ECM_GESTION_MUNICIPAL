# Informe técnico en LaTeX

## Contenido

- `main.tex` — Documento principal del informe de investigación.
- `figuras/` — Gráficos generados a partir del modelo ARDL-MCE:
  - `fig1_series.png` — Series en logaritmos
  - `fig2_ardl_ajustado.png` — Ajuste del modelo ARDL
  - `fig3_mce_ajustado.png` — Ajuste del MCE
  - `fig4_pvalores_diagnostico.png` — p-valores de diagnósticos
  - `fig5_residuos_mce.png` — Residuos del MCE
  - `fig6_acf_residuos.png` — ACF de residuos
  - `fig7_histograma.png` — Histograma de residuos
  - `fig8_diagnostico_mce.png` — Diagnósticos gráficos
  - `fig9_cusum.png` — CUSUM y CUSUMSQ

## Cómo agregar los archivos

1. Descargar el archivo `informe_latex.zip` (adjunto en la conversación o generado localmente).
2. Extraer el contenido.
3. Subir `main.tex` a esta carpeta (`docs/informe_latex/`).
4. Subir todas las imágenes de la carpeta `figuras/` a `docs/informe_latex/figuras/`.

Alternativamente, desde la interfaz web de GitHub:
- Ir a **Add file → Upload files**
- Arrastrar `main.tex` y la carpeta `figuras/`.

## Compilación

Compatible con **pdfLaTeX**, **XeLaTeX** y **LuaLaTeX** (Overleaf recomendado).

```bash
pdflatex main.tex
```

El archivo `main.tex` ya incluye la ruta `\graphicspath{{figuras/}}`.
