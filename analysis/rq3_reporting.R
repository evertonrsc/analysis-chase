# Install required packages if needed
required_packages <- c("tidyr", "scales", "stringr", "corrplot", "ragg")
for (package in required_packages) {
  if (!requireNamespace(package)) {
    install.packages(package, dependencies = TRUE)
  }
}

# Load libraries
library(tidyr)
library(scales)
library(stringr)
library(corrplot)
library(ragg)

# Read and prepare data
source("./imports/import_data.R")

# Full labels mapped to column names
label_map <- c(
  irb = "Institutional review approval or waiver reported",
  risk = "Risk assessment and mitigation procedures described",
  consent = "Informed consent reported",
  withdrawal = "Ability to withdraw explicitly stated",
  recruitment = "Recruitment method described",
  compensation = "Compensation strategy ethically justified",
  vulnerability = "Participant vulnerability and power dynamics addressed",
  anonymization = "(Pseudo)anonymization procedure described",
  secondaryData = "Use of secondary or publicly available data ethically addressed",
  transparency = "Materials available for transparency"
)

# Compute mean and SD per dimension
dimension_summary <- data %>%
  select(all_of(dimension_keywords)) %>%
  pivot_longer(cols = everything(), names_to = "Dimension", values_to = "Score") %>%
  group_by(Dimension) %>%
  summarise(
    mean = mean(Score, na.rm = TRUE),
    sd   = sd(Score, na.rm = TRUE),
    n    = sum(!is.na(Score)),
    .groups = "drop"
  ) %>%
  mutate(Label = label_map[Dimension], se = sd / sqrt(n)) %>%
  arrange(desc(mean)) %>%
  mutate(Label = factor(Label, levels = rev(Label)))

# ggplot2 theme
source("./imports/theme.R")

# Mean score per dimension (ranked)
plot_dimensions <- ggplot(dimension_summary, aes(x = Label, y = mean)) +
  geom_col(fill = "#08306b", width = 0.7) +
  # Optional: add error bars
  # geom_errorbar(aes(ymin = pmax(0, mean - se), ymax = pmin(1, mean + se)),
  #               width = 0.25, color = "gray40") +
  geom_text(aes(label = sprintf("%.2f", mean)), hjust = -0.2, size = 3.2) +
  coord_flip() +
  scale_y_continuous(limits = c(0, 1), labels = number_format(accuracy = 0.1)) +
  scale_x_discrete(labels = function(x) str_wrap(x, width = 35)) +
  labs(title = "Mean ECS per dimension", x = NULL, y = "Mean ECS (0–1)") +
  theme_pub() +
  theme(axis.title.x = element_text(vjust = -1))
print(plot_dimensions)
ggsave("./plots/ecs-ranked.png", plot_dimensions, width = 7, height = 5, dpi = 300)


# Temporal evolution per dimension
dim_year <- data %>%
  select(year, all_of(dimension_keywords)) %>%
  pivot_longer(-year, names_to = "Dimension", values_to = "Score") %>%
  group_by(year, Dimension) %>%
  summarise(mean = mean(Score, na.rm = TRUE), .groups = "drop") %>%
  mutate(Label = label_map[Dimension])
plot_dim_trend <- ggplot(dim_year, aes(x = year, y = mean, color = Label)) +
  geom_line(linewidth = 0.8, alpha = 0.85) +
  geom_point(size = 1.8, alpha = 0.9) +
  scale_y_continuous(breaks = seq(0, 1, 0.2), 
                     labels = number_format(accuracy = 0.1)) +
  scale_x_continuous(breaks = seq(min(dim_year$year), max(dim_year$year))) +
  scale_color_manual(values = RColorBrewer::brewer.pal(10, "Paired")) +
  labs(
    title = "Temporal evolution of ethics reporting dimensions",
    x = "Publication year", y = "Mean ECS (0–1)",
    color = "Dimension"
  ) +
  guides(color = guide_legend(nrow = 5, byrow = TRUE)) +
  theme_pub() +
  theme(
    legend.position = "bottom",
    legend.title = element_blank(),
    legend.text = element_text(size = 9),
    plot.title = element_blank(),
    aspect.ratio = 0.35/1
  )
print(plot_dim_trend)
ggsave("./plots/ecs-time.png", plot_dim_trend, width = 7, height = 5, dpi = 300)


# Spearman correlations among dimensions
corr_matrix <- data %>%
  select(all_of(dimension_keywords)) %>%
  cor(use = "pairwise.complete.obs", method = "spearman")
label_map_short <- c(
  irb = "REC approval",
  risk = "Risk assessment",
  consent = "Informed consent",
  withdrawal = "Withdrawal",
  recruitment = "Recruitment",
  compensation = "Compensation",
  vulnerability = "Vulnerability",
  anonymization = "Anonymization",
  secondaryData = "Secondary data",
  transparency = "Transparency"
)
dim_labels <- str_wrap(label_map_short[rownames(corr_matrix)], width = 35)
rownames(corr_matrix) <- dim_labels
colnames(corr_matrix) <- dim_labels

agg_png("./plots/dimensions-correlogram.png", width = 1800, height = 1600, res = 300)
corrplot(corr_matrix, method = "color", diag = FALSE, na.label = " ",
         tl.col = "black", tl.cex = 0.8, tl.srt = 45,
         addCoef.col = "white", number.cex = 15 / ncol(data),
         col = colorRampPalette(c("white", "#08306b"))(200))
dev.off()
