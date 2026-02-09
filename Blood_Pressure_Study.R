library(ggplot2)
library(dplyr)

# --- PASO 1: CARGA Y LIMPIEZA DE DATOS ---

# Cargar el archivo CSV
datos_raw <- read.csv("omron.csv", check.names = FALSE, encoding = "UTF-8", stringsAsFactors = FALSE)

# Procesar los datos
datos <- datos_raw %>%
  mutate(
    # Crear fecha combinada
    fecha_temp = paste(Fecha, Hora),
    
    # Traducción de meses (asegura compatibilidad)
    fecha_temp = gsub("ene\\.", "01", fecha_temp),
    fecha_temp = gsub("feb\\.", "02", fecha_temp),
    fecha_temp = gsub("mar\\.", "03", fecha_temp),
    fecha_temp = gsub("abr\\.", "04", fecha_temp),
    fecha_temp = gsub("may\\.", "05", fecha_temp),
    fecha_temp = gsub("jun\\.", "06", fecha_temp),
    fecha_temp = gsub("jul\\.", "07", fecha_temp),
    fecha_temp = gsub("ago\\.", "08", fecha_temp),
    fecha_temp = gsub("sep\\.", "09", fecha_temp),
    fecha_temp = gsub("oct\\.", "10", fecha_temp),
    fecha_temp = gsub("nov\\.", "11", fecha_temp),
    fecha_temp = gsub("dic\\.", "12", fecha_temp),
    
    # Convertir a objeto de fecha
    fecha_hora = as.POSIXct(fecha_temp, format = "%d %m %Y %H:%M")
  ) %>%
  select(
    fecha_hora,
    sistolica = `Sistólica (mmHg)`,
    diastolica = `Diastólica (mmHg)`,
    pulso = `Pulso (ppm)`  # <--- NUEVO: Seleccionamos el pulso
  ) %>%
  filter(!is.na(fecha_hora)) %>%
  arrange(fecha_hora)

# --- PASO 2: GRAFICAR ---

ggplot(datos, aes(x = fecha_hora)) +
  # --- SISTÓLICA ---
  geom_point(aes(y = sistolica, color = "Sistólica"), 
             shape = 16, size = 3.5, alpha = 0.7) +
  geom_smooth(aes(y = sistolica), color = "#FF9999", 
              method = "loess", se = TRUE, fill = "#FFE5E5",
              linewidth = 1, alpha = 0.4) +
  
  # --- DIASTÓLICA ---
  geom_point(aes(y = diastolica, color = "Diastólica"), 
             shape = 16, size = 3.5, alpha = 0.7) +
  geom_smooth(aes(y = diastolica), color = "#99CCFF", 
              method = "loess", se = TRUE, fill = "#E5F2FF",
              linewidth = 1, alpha = 0.4) +
  
  # --- PULSO (NUEVO) ---
  geom_point(aes(y = pulso, color = "Pulso"), 
             shape = 17, size = 3, alpha = 0.7) + # Triángulos para diferenciar
  geom_smooth(aes(y = pulso), color = "#82C91E", 
              method = "loess", se = FALSE, # Sin sombra para no ensuciar
              linetype = "dashed", linewidth = 0.8, alpha = 0.6) +
  
  # --- CONFIGURACIÓN DE COLORES ---
  scale_color_manual(values = c("Sistólica" = "#FF9999", 
                                "Diastólica" = "#99CCFF",
                                "Pulso" = "#82C91E"),
                     name = "Medición") +
  
  # --- LÍNEAS DE REFERENCIA (SOLO PRESIÓN) ---
  # Hipertensión
  geom_hline(yintercept = 140, linetype = "dashed", color = "#FF6B6B", alpha = 0.4, linewidth = 0.5) +
  geom_hline(yintercept = 90, linetype = "dashed", color = "#FF6B6B", alpha = 0.4, linewidth = 0.5) +
  # Normalidad
  geom_hline(yintercept = 120, linetype = "dotted", color = "#51CF66", alpha = 0.3, linewidth = 0.5) +
  geom_hline(yintercept = 80, linetype = "dotted", color = "#51CF66", alpha = 0.3, linewidth = 0.5) +
  
  # --- EJES Y ETIQUETAS ---
  scale_x_datetime(date_labels = "%d %b") +
  # Ajustamos el eje Y para que quepan pulsos bajos (ej. 50) y tensiones altas (ej. 160)
  scale_y_continuous(breaks = seq(40, 180, by = 10)) + 
  labs(
    title = "Monitoreo de Salud Cardiovascular",
    subtitle = paste("Tensión Arterial y Frecuencia Cardíaca -", nrow(datos), "registros"),
    x = "",
    y = "mmHg / ppm", # Unidades combinadas
    caption = paste("Periodo:", format(min(datos$fecha_hora), "%d %b"), 
                    "-", format(max(datos$fecha_hora), "%d %b %Y"))
  ) +
  theme_minimal(base_size = 12) +
  theme(
    legend.position = "top",
    legend.title = element_text(size = 10, face = "bold"),
    legend.text = element_text(size = 9),
    axis.text.x = element_text(angle = 0, hjust = 0.5, size = 9, color = "#666666"),
    axis.text.y = element_text(size = 9, color = "#666666"),
    panel.grid.major = element_line(color = "#E8E8E8", linewidth = 0.3),
    panel.grid.minor = element_blank(),
    plot.title = element_text(face = "bold", size = 15, color = "#333333"),
    plot.subtitle = element_text(size = 11, color = "#666666", margin = margin(b = 15))
  )

# --- PASO 3: RESUMEN ESTADÍSTICO ACTUALIZADO ---
cat("\n=== RESUMEN ESTADÍSTICO ===\n")
cat("SISTÓLICA (mmHg):\n")
cat("  Media:", round(mean(datos$sistolica), 1), "| Máx:", max(datos$sistolica), "\n")

cat("DIASTÓLICA (mmHg):\n")
cat("  Media:", round(mean(datos$diastolica), 1), "| Máx:", max(datos$diastolica), "\n")

cat("PULSO (ppm):\n")
cat("  Media:", round(mean(datos$pulso), 1), "\n")
cat("  Rango:", min(datos$pulso), "-", max(datos$pulso), "\n")
cat("  Variabilidad (Desv. Estándar):", round(sd(datos$pulso), 1), "\n")