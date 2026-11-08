# =============================================================================
# ARDL + MCE
# Incidencia de la deuda predial y la morosidad sobre la ejecución de la
# inversión pública (Municipalidad Distrital de José Leonardo Ortiz, 2018-2025)
#
# Uso:
#   Rscript script_ardl_mce.R [ruta_datos.xlsx] [carpeta_salida]
#   Por defecto: data/Nueva_dta.xlsx  y  results/salida_ARDL
# =============================================================================

args    <- commandArgs(trailingOnly = TRUE)
ruta    <- ifelse(length(args) >= 1, args[1], "data/Nueva_dta.xlsx")
carpeta <- ifelse(length(args) >= 2, args[2], "results/salida_ARDL")

dir.create(carpeta, showWarnings = FALSE, recursive = TRUE)

# -----------------------------------------------------------------------------
# Librerías
# -----------------------------------------------------------------------------
suppressMessages({
  library(readxl)
  library(writexl)
  library(tseries)
  library(ARDL)
  library(lmtest)
  library(sandwich)
  library(strucchange)
  library(car)
})

# -----------------------------------------------------------------------------
# 1. Datos y transformación
# -----------------------------------------------------------------------------
raw <- read_excel(ruta, sheet = "Hoja1")
names(raw) <- trimws(names(raw))
raw <- as.data.frame(raw)

names(raw)[names(raw) == "años"]         <- "anio"
names(raw)[names(raw) == "deuda predial"] <- "deuda"

raw$mes   <- rep(1:12, length.out = nrow(raw))
raw$D_dic <- as.integer(raw$mes == 12)

datos <- raw[raw$anio >= 2018 & raw$anio <= 2025, ]
cat("Observaciones 2018-2025:", nrow(datos), "\n")

stopifnot(
  !anyNA(datos[, c("deuda", "recaudacion", "devengado", "foncomun", "pim", "Morosidad")]),
  all(datos[, c("deuda", "recaudacion", "devengado", "foncomun", "pim")] > 0)
)

d <- data.frame(
  ln_devengado    = log(datos$devengado),
  ln_deuda        = log(datos$deuda),
  ln_recaudacion  = log(datos$recaudacion),
  ln_foncomun     = log(datos$foncomun),
  ln_pim          = log(datos$pim),
  ln_monto_viable = log1p(datos$monto_viable),
  Morosidad       = datos$Morosidad,
  DUMMIE_COVID    = datos$DUMMIE_COVID,
  DUMMIE_Est      = datos$DUMMIE_Est,
  n_proyectos_viab= datos$n_proyectos_viab,
  D_dic           = datos$D_dic
)
ts_d <- ts(d, start = c(2018, 1), frequency = 12)

# -----------------------------------------------------------------------------
# 2. Raíces unitarias (ADF)
# -----------------------------------------------------------------------------
adf_tabla <- function(x, nombre) {
  x  <- as.numeric(x)
  p0 <- suppressWarnings(adf.test(x)$p.value)
  p1 <- suppressWarnings(adf.test(diff(x))$p.value)
  data.frame(
    variable = nombre,
    p_nivel  = round(p0, 4),
    p_dif1   = round(p1, 4),
    orden    = ifelse(p0 < 0.05, "I(0)", ifelse(p1 < 0.05, "I(1)", "posible I(2)"))
  )
}

vars_adf <- c("ln_devengado", "ln_deuda", "ln_recaudacion", "ln_foncomun",
              "ln_pim", "ln_monto_viable", "Morosidad")
tabla_adf <- do.call(rbind, lapply(vars_adf, function(v) adf_tabla(ts_d[, v], v)))
cat("\n=== ADF ===\n"); print(tabla_adf)

# -----------------------------------------------------------------------------
# 3. Selección de rezagos y estimación ARDL
# -----------------------------------------------------------------------------
f_ardl <- ln_devengado ~ ln_deuda + ln_recaudacion + ln_foncomun + ln_pim +
  ln_monto_viable | Morosidad + DUMMIE_COVID + DUMMIE_Est + n_proyectos_viab + D_dic

max_ord <- 3
t0 <- Sys.time()
sel_bic <- auto_ardl(f_ardl, data = ts_d, max_order = max_ord, selection = "BIC")
sel_aic <- auto_ardl(f_ardl, data = ts_d, max_order = max_ord, selection = "AIC")
cat("\nTiempo selección:", round(difftime(Sys.time(), t0, units = "mins"), 1), "min\n")
cat("Mejor orden BIC:", sel_bic$best_order, "\n")
cat("Mejor orden AIC:", sel_aic$best_order, "\n")
print(head(sel_bic$top_orders, 5))

orden <- sel_bic$best_order
if (!is.na(Sys.getenv("ORDEN", NA))) {
  orden <- as.integer(strsplit(Sys.getenv("ORDEN"), ",")[[1]])
}
cat("Orden usado:", orden, "\n")

m_ardl <- ardl(f_ardl, data = ts_d, order = orden)
cat("\n=== ARDL ===\n"); print(summary(m_ardl))

# -----------------------------------------------------------------------------
# 4. Prueba de límites (Pesaran, Shin y Smith, 2001) — caso 3
# -----------------------------------------------------------------------------
bf <- bounds_f_test(m_ardl, case = 3)
bt <- bounds_t_test(m_ardl, case = 3)
cat("\n=== Bounds F ===\n"); print(bf)
cat("\n=== Bounds t ===\n"); print(bt)

# -----------------------------------------------------------------------------
# 5. Modelo de corrección de errores (MCE)
# -----------------------------------------------------------------------------
m_ecm <- recm(m_ardl, case = 3)
cat("\n=== MCE ===\n"); print(summary(m_ecm))

tab       <- coef(summary(m_ecm))
fila_ect  <- grep("^ect", rownames(tab))
ect       <- tab[fila_ect, , drop = FALSE]
corto     <- tab[-fila_ect, , drop = FALSE]

cat("\nECT:", round(ect[1, 1], 4),
    "| p =", round(ect[1, 4], 4),
    "| negativo:", ect[1, 1] < 0,
    "| signif 5%:", ect[1, 4] < 0.05,
    "| -1 < rho < 0:", ect[1, 1] > -1 && ect[1, 1] < 0, "\n")

cat("\n--- Corto plazo ---\n"); print(round(corto, 4))
cat("\n--- Largo plazo (multiplicadores) ---\n")
lp <- multipliers(m_ardl); print(lp)

# -----------------------------------------------------------------------------
# 6. Diagnósticos
# -----------------------------------------------------------------------------
res <- residuals(m_ecm)
bg  <- lapply(c(1, 4, 12), function(o) {
  cat("\nBreusch-Godfrey orden", o, "\n")
  r <- bgtest(m_ecm, order = o); print(r); r
})
jb <- jarque.bera.test(as.numeric(res)); print(jb)
bp <- bptest(m_ecm); print(bp)

diag_df <- data.frame(
  prueba       = c("BG orden 1", "BG orden 4", "BG orden 12", "Jarque-Bera", "Breusch-Pagan"),
  estadistico  = round(c(sapply(bg, function(r) r$statistic), jb$statistic, bp$statistic), 4),
  p_valor      = round(c(sapply(bg, function(r) r$p.value), jb$p.value, bp$p.value), 4)
)
diag_df$conclusion_5pct <- ifelse(diag_df$p_valor > 0.05, "No se rechaza H0 (OK)", "Se rechaza H0")
cat("\n=== Resumen diagnósticos ===\n"); print(diag_df)

# -----------------------------------------------------------------------------
# 7. Exportar resultados
# -----------------------------------------------------------------------------
lp_df <- as.data.frame(lp)
lp_df <- cbind(termino = rownames(lp_df), lp_df)

tablas <- list(
  ADF              = tabla_adf,
  Bounds           = data.frame(
    prueba      = c("F", "t"),
    estadistico = c(bf$statistic, bt$statistic),
    p_valor     = c(bf$p.value, bt$p.value)
  ),
  Velocidad_ajuste = data.frame(termino = rownames(ect), ect, check.names = FALSE),
  Corto_plazo      = data.frame(termino = rownames(corto), corto, check.names = FALSE),
  Largo_plazo      = lp_df,
  Diagnosticos     = diag_df,
  ARDL_coef        = data.frame(
    termino = rownames(coef(summary(m_ardl))),
    coef(summary(m_ardl)),
    check.names = FALSE
  )
)

write_xlsx(tablas, file.path(carpeta, "resultados_ARDL_MCE.xlsx"))
save(m_ardl, m_ecm, ts_d, file = file.path(carpeta, "modelos_ARDL_MCE.RData"))

cat("\nListo. Resultados exportados en:", carpeta, "\n")
