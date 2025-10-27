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
ecs_by_year <- data %>%
  mutate(year = as.integer(year)) %>%
  group_by(year) %>%
  summarise(
    mean_ECS_n = mean(ecs_n, na.rm = TRUE),
    sd_ECS_n   = sd(ecs_n, na.rm = TRUE),
    years      = n(),
    sderror    = sd_ECS_n / sqrt(years),
    CI_lower   = pmax(0, mean_ECS_n - 1.96 * sderror),
    CI_upper   = pmin(1, mean_ECS_n + 1.96 * sderror),
    .groups = "drop"
  ) %>%
  arrange(year)

# ggplot2 theme
source("./imports/theme.R")


# Temporal trend of normalized ECS by year
plot_time <- data |>
  group_by(year = data$year) |>
  summarise(mean_ecs_norm = mean(ecs_n), .groups = "drop") |>
  ggplot(aes(x = year, y = mean_ecs_norm)) +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE) +
  scale_x_continuous(breaks = seq(2008, 2025, 2)) +
  labs(title = "Temporal trend in normalized ECS across CHASE editions",
       x = "Year", y = "Normalized ECS (mean)") +
  theme_pub() +
  theme(axis.title.x = element_text(vjust = -1))
print(plot_time)
ggsave("./plots/temporal.png", plot_time, width = 7, height = 5, dpi = 300)

# Temporal evolution of mean ECS per dimension
dim_year <- data %>%
  select(year, all_of(dimension_keywords)) %>%
  pivot_longer(-year, names_to = "Dimension", values_to = "Score") %>%
  group_by(year, Dimension) %>%
  summarise(mean = mean(Score, na.rm = TRUE), .groups = "drop") %>%
  mutate(Label = label_map[Dimension])
plot_dim_year <- ggplot(dim_year, aes(x = year, y = mean, color = Label)) +
  geom_line(linewidth = 0.8, alpha = 0.85) +
  geom_point(size = 1.8, alpha = 0.9) +
  scale_y_continuous(
    limits = c(0, 1), breaks = seq(0, 1, 0.2), 
    labels = number_format(accuracy = 0.1)
  ) +
  scale_x_continuous(breaks = seq(2008, 2025)) +
  scale_color_manual(
    values = RColorBrewer::brewer.pal(10, "Paired"),
    labels = function(x) str_wrap(x, width = 50)
  ) +
  labs(
    title = "Temporal evolution of ethics-reporting dimensions",
    x = "Publication year", y = "Mean ECS (0–1)",
    color = "Dimension"
  ) +
  theme_pub() +
  theme(
    legend.position = "bottom",
    legend.title = element_blank(),
    legend.text = element_text(size = 9),
    legend.justification = "center",
    plot.title = element_blank()
  ) +
  guides(color = guide_legend(nrow = 5, ncol = 2, byrow = TRUE))
print(plot_dim_year)
ggsave("./plots/ecs-time.png", plot_dim_year, width = 7, height = 5, dpi = 300)


# Nonparametric test: Spearman correlation with year
spearman_out <- cor.test(data$year, data$ecs_n, method = "spearman")
print(spearman_out)


# Nonparametric test: Mann–Whitney test comparing early (2008-2016) 
# vs. recent periods (2017-2025)
data <- data %>%
  mutate(period = ifelse(year <= 2016, "Early (2008–2016)", "Recent (2017–2025)"))
mw_test <- wilcox.test(ecs_n ~ period, data = data)
print(mw_test)

# Descriptive summary for both periods
early_recent <- data %>%
  group_by(period) %>%
  summarise(
    mean_ECS_n = mean(ecs_n, na.rm = TRUE),
    sd_ECS_n = sd(ecs_n, na.rm = TRUE),
    median_ECS_n = median(ecs_n, na.rm = TRUE),
    N = n()
  )