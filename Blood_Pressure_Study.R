library(ggplot2)
library(dplyr)

# Generar 80 mediciones simuladas realistas
set.seed(123)
n <- 80

# Simular mediciones durante 4 semanas (28 días)
fecha_inicio <- as.POSIXct("2025-01-01 08:00:00")
fechas <- fecha_inicio + sample(0:(28*24*60*60), n, replace = TRUE)

# Generar valores de tensión con distribución realista
# Tendencia a valores altos pero con variabilidad
sistolica <- rnorm(n, mean = 138, sd = 8)
sistolica <- pmax(pmin(sistolica, 165), 115) # Limitar entre 115-165

# Diastólica correlacionada con sistólica pero con su propia variabilidad
diastolica <- 0.6 * sistolica + rnorm(n, mean = 15, sd = 5)
diastolica <- pmax(pmin(diastolica, 105), 70) # Limitar entre 70-105

# Crear dataframe
datos <- data.frame(
  fecha_hora = fechas,
  sistolica = round(sistolica),
  diastolica = round(diastolica)
) %>%
  arrange(fecha_hora)

# Añadir momento del día
datos <- datos %>%
  mutate(
    hora = as.numeric(format(fecha_hora, "%H")),
    momento = case_when(
      hora < 12 ~ "Mañana",
      hora < 18 ~ "Tarde",
      TRUE ~ "Noche"
    )
  )

# Calcular densidad 2D para el color (número de puntos cercanos)
# Usamos stat_density2d para colorear según densidad
ggplot(datos, aes(x = fecha_hora)) +
  # Scatterplot simple con colores pastel
  geom_point(aes(y = sistolica, color = "Sistólica"), 
             shape = 16, size = 3.5, alpha = 0.7) +
  geom_point(aes(y = diastolica, color = "Diastólica"), 
             shape = 16, size = 3.5, alpha = 0.7) +
  # Líneas de tendencia suaves con colores pastel
  geom_smooth(aes(y = sistolica), color = "#FF9999", 
              method = "loess", se = TRUE, fill = "#FFE5E5",
              linewidth = 1, alpha = 0.4) +
  geom_smooth(aes(y = diastolica), color = "#99CCFF", 
              method = "loess", se = TRUE, fill = "#E5F2FF",
              linewidth = 1, alpha = 0.4) +
  # Colores pastel para los puntos
  scale_color_manual(values = c("Sistólica" = "#FF9999", 
                                "Diastólica" = "#99CCFF"),
                     name = "Tipo de medición") +
  # Umbrales de hipertensión con colores suaves
  geom_hline(yintercept = 140, linetype = "dashed", 
             color = "#FF6B6B", alpha = 0.6, linewidth = 0.7) +
  geom_hline(yintercept = 90, linetype = "dashed", 
             color = "#FF6B6B", alpha = 0.6, linewidth = 0.7) +
  # Umbrales normales
  geom_hline(yintercept = 120, linetype = "dotted", 
             color = "#51CF66", alpha = 0.5, linewidth = 0.6) +
  geom_hline(yintercept = 80, linetype = "dotted", 
             color = "#51CF66", alpha = 0.5, linewidth = 0.6) +
  # Anotaciones con colores pastel
  annotate("text", x = min(datos$fecha_hora), y = 143, 
           label = "140 mmHg", hjust = 0, size = 3.2, 
           color = "#FF6B6B", fontface = "italic") +
  annotate("text", x = min(datos$fecha_hora), y = 123, 
           label = "120 mmHg", hjust = 0, size = 3.2, 
           color = "#51CF66", fontface = "italic") +
  # Formato del eje X
  scale_x_datetime(date_breaks = "4 days", date_labels = "%d %b") +
  scale_y_continuous(breaks = seq(70, 170, by = 10)) +
  labs(
    title = "Monitoreo de Tensión Arterial",
    subtitle = "Evolución durante 4 semanas",
    x = "",
    y = "Presión Arterial (mmHg)",
    caption = paste("Periodo:", format(min(datos$fecha_hora), "%d %b %Y"), 
                    "-", format(max(datos$fecha_hora), "%d %b %Y"), 
                    "• Total:", nrow(datos), "mediciones")
  ) +
  theme_minimal(base_size = 12) +
  theme(
    legend.position = "top",
    legend.title = element_text(size = 10, face = "bold"),
    legend.text = element_text(size = 9),
    axis.text.x = element_text(angle = 0, hjust = 0.5, size = 9, color = "#666666"),
    axis.text.y = element_text(size = 9, color = "#666666"),
    axis.title.y = element_text(size = 11, face = "bold", color = "#444444"),
    panel.grid.major = element_line(color = "#E8E8E8", linewidth = 0.3),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "#FAFAFA", color = NA),
    plot.background = element_rect(fill = "white", color = NA),
    plot.title = element_text(face = "bold", size = 15, color = "#333333", hjust = 0),
    plot.subtitle = element_text(size = 11, color = "#666666", hjust = 0, 
                                 margin = margin(b = 15)),
    plot.caption = element_text(size = 8, color = "#999999", hjust = 1),
    plot.margin = margin(15, 15, 15, 15)
  )

# Estadísticas resumen
cat("\n=== RESUMEN ESTADÍSTICO ===\n")
cat("SISTÓLICA:\n")
cat("  Media:", round(mean(datos$sistolica), 1), "mmHg\n")
cat("  Rango:", min(datos$sistolica), "-", max(datos$sistolica), "mmHg\n")
cat("  % por encima de 140:", 
    round(100 * sum(datos$sistolica > 140) / nrow(datos), 1), "%\n\n")

cat("DIASTÓLICA:\n")
cat("  Media:", round(mean(datos$diastolica), 1), "mmHg\n")
cat("  Rango:", min(datos$diastolica), "-", max(datos$diastolica), "mmHg\n")
cat("  % por encima de 90:", 
    round(100 * sum(datos$diastolica > 90) / nrow(datos), 1), "%\n")