# Install required packages if needed
required_packages <- c("ggplot2")
for (package in required_packages) {
  if (!requireNamespace(package)) {
    install.packages(package, dependencies = TRUE)
  }
}

# Load libraries
library(ggplot2)

# Read and prepare data
source("./imports/import_data.R")

# Compute ECS and normalized ECS
data <- data |>
  rowwise() |>
  mutate(
    applicable_dimensions = sum(!is.na(c_across(all_of(dimension_keywords)))),
    ecs = sum(c_across(all_of(dimension_keywords)), na.rm = TRUE),
    ecs_n = ifelse(applicable_dimensions > 0, (ecs / applicable_dimensions) * 100, NA_real_)
  ) |>
  ungroup()

# Overall ECS summaries
overall_ecs <- tibble(
  metric = c("ECS", "ECS_n"),
  mean   = c(mean(data$ecs), mean(data$ecs_n)),
  sd     = c(sd(data$ecs), sd(data$ecs_n)),
  median = c(median(data$ecs), median(data$ecs_n)),
  min    = c(min(data$ecs),  min(data$ecs_n)),
  max    = c(max(data$ecs),  max(data$ecs_n))
)

# ggplot2 theme
source("./imports/theme.R")

# Distribution of normalized ECS
plot_distECS <- ggplot(data, aes(x = ecs_n)) +
  geom_histogram(aes(y = after_stat(density)), 
                 bins = 10, fill = "lightblue", color = "#999999", boundary = 0) +
  stat_function(fun = dnorm,
                args = list(mean = overall_ecs$mean[2], sd = overall_ecs$sd[2]),
                color = "red", linewidth = 0.5) +
  geom_vline(xintercept = overall_ecs$mean[2], 
             color = "black", linetype = "dotted") +
  annotate("text", x = overall_ecs$mean[2] + 0.03, 
           y = dnorm(overall_ecs$mean[2], 
                     mean = overall_ecs$mean[2], sd = overall_ecs$sd[2]) * 0.9,
           label = paste0("Mean = ", round(overall_ecs$mean[2], 2)), 
           hjust = -0.15, vjust = -5, size = 3.5) +
  labs(title = "Distribution of the Ethics Completeness Score (ECS)",
       x = "Normalized ECS (0–100)",
       y = "Density") +
  theme_pub() +
  theme(axis.text.y = element_blank(), 
        axis.title.y = element_blank(),
        axis.title.x = element_text(vjust = -1))
print(plot_distECS)
ggsave("./plots/distribution-ecs_n.png", plot_distECS, width = 7, height = 5, dpi = 300)