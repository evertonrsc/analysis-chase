# Install required packages if needed
required_packages <- c("tidyr", "rstatix")
for (package in required_packages) {
  if (!requireNamespace(package)) {
    install.packages(package, dependencies = TRUE)
  }
}

# Load libraries
library(tidyr)
library(rstatix)

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


# Shapiro–Wilk test for normality
sh_test <- shapiro.test(data$ecs_n)
sh_test

# Research method vs. normalized ECS
kw_method <- kruskal_test(ecs_n ~ researchMethod, data = data)
kw_method

# Post-hoc only if significant
dunn_method <- if (kw_method$p < 0.05) {
  dunn_test(data, ecs_n ~ researchMethod, p.adjust.method = "holm") %>% 
    arrange(p.adj)
} else NULL
if (!is.null(dunn_method)) dunn_method %>% print(n = 68)

# Plot: normalized ECS by research method
plot_ecs_method <- ggplot(data, aes(x = reorder(researchMethod, ecs_n, 
                                                FUN = median, na.rm = TRUE),
                                    y = ecs_n)) +
  geom_boxplot(outlier.alpha = 0.35, width = 0.55, fill = "#6BAED6") +
  #stat_summary(fun = mean, geom = "point", shape = 21, size = 2.4, fill = "white") +
  coord_flip() +
  scale_y_continuous(limits = c(0, 100), labels = label_number(accuracy = 1)) +
  scale_x_discrete(labels = function(x) str_wrap(x, width = 20)) +
  labs(
    title = "Normalized ECS by research method", 
    x = NULL, y = "Normalized ECS (0-100)") +
  theme_pub() +
  theme(axis.title.x = element_text(vjust = -1))
print(plot_ecs_method)
ggsave("./plots/ecs_method.png", plot_ecs_method, width = 7, height = 5, dpi = 300)


# Research type vs. normalized ECS
kw_type <- kruskal_test(ecs_n ~ researchType, data = data)
kw_type

# Post-hoc only if significant
dunn_type <- if (kw_type$p < 0.05) {
  dunn_test(data, ecs_n ~ researchType, p.adjust.method = "holm") %>% 
    arrange(p.adj)
} else NULL
if (!is.null(dunn_type)) dunn_part

# Plot: normalized ECS by research type
plot_ecs_type <- ggplot(data, aes(x = reorder(researchType, ecs_n, 
                                              FUN = median, na.rm = TRUE),
                                  y = ecs_n)) +
  geom_boxplot(outlier.alpha = 0.35, width = 0.3, fill = "#6BAED6") +
  #stat_summary(fun = mean, geom = "point", shape = 21, size = 2.4, fill = "white") +
  scale_y_continuous(limits = c(0, 100), labels = label_number(accuracy = 1)) +
  labs(
    title = "Normalized ECS by research type", 
    x = NULL, y = "Normalized ECS (0-100)") +
  theme_pub() +
  theme(axis.title.x = element_text(vjust = -1), aspect.ratio = 1.5/1)
print(plot_ecs_type)
ggsave("./plots/ecs_type.png", plot_ecs_type, width = 7, height = 5, dpi = 300)


# Participant category vs. normalized ECS
kw_participant <- kruskal_test(ecs_n ~ participantCategory, data = data)
kw_participant

# Post-hoc only if significant
dunn_type <- if (kw_participant$p < 0.05) {
  dunn_test(data, ecs_n ~ participantCategory, p.adjust.method = "holm") %>% 
    arrange(p.adj)
} else NULL
if (!is.null(dunn_type)) dunn_type

# Plot: normalized ECS by participant category
data_part <- data %>%
  filter(participantCategory %in% c("Professionals", "Students", "Mixed")) %>%
  droplevels()
plot_ecs_participant <- ggplot(data_part, aes(x = reorder(participantCategory, ecs_n, 
                                                     FUN = median, na.rm = TRUE),
                                         y = ecs_n)) +
  geom_boxplot(outlier.alpha = 0.35, width = 0.3, fill = "#6BAED6") +
  #stat_summary(fun = mean, geom = "point", shape = 21, size = 2.4, fill = "white") +
  scale_y_continuous(limits = c(0, 100), labels = label_number(accuracy = 1)) +
  labs(
    title = "Normalized ECS by participant category", 
    x = NULL, y = "Normalized ECS (0-100)") +
  theme_pub() +
  theme(axis.title.x = element_text(vjust = -1), aspect.ratio = 1.5/1)
print(plot_ecs_participant)
ggsave("./plots/ecs_participant.png", plot_ecs_participant, width = 7, height = 5, dpi = 300)
