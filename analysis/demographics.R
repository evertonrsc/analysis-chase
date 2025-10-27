# Install required packages if needed
required_packages <- c("dplyr", "ggplot2")
for (package in required_packages) {
  if (!requireNamespace(package)) {
    install.packages(package, dependencies = TRUE)
  }
}

# Load libraries
library(dplyr)
library(ggplot2)

# Read and prepare data
source("./imports/import_data.R")

# Custom ggplot2 theme
source("./imports/theme.R")

# Annual counts of retrieved and selected papers
counts_long <- counts %>%
  mutate(notSelected = retrievedPapers - selectedPapers) %>%
  select(year, selectedPapers, notSelected) %>%
  pivot_longer(c(selectedPapers, notSelected),
               names_to = "Category", values_to = "Count") %>%
  mutate(Category = recode(Category,
                           "selectedPapers" = "Selected",
                           "notSelected" = "Not selected"),
    Category = factor(Category, levels = c("Not selected", "Selected"))
  ) %>%
  group_by(year) %>%
  mutate(Proportion = Count / sum(Count)) %>%
  ungroup()
plot_years <- ggplot(counts_long, aes(x = as.factor(year), y = Proportion, 
                                      fill = Category)) +
  geom_col(width = 0.8) +
  geom_text(
    data = subset(counts_long, Category == "Selected"),
    aes(x = as.factor(year), y = Proportion - 0.04,
        label = scales::percent(Proportion, accuracy = 1)),
    inherit.aes = FALSE,
    color = "white",
    size = 3
  ) +
  scale_fill_manual(values = c("Not selected" = "#D7191C", "Selected" = "#2C7BB6")) +
  scale_y_continuous(labels = percent_format(accuracy = 10)) +
  labs(
    title = "Proportion of selected and not-selected CHASE papers per year (2008–2025)",
    x = "Publication year",
    y = "Proportion of retrieved papers",
    fill = "Category"
  ) +
  theme_pub() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 0.5),
    legend.title = element_blank(),
    legend.position = "bottom"
  )
print(plot_years)
ggsave("./plots/paper_counts.png", plot_years, width = 7, height = 5, dpi = 300)


# Participant type analysis
participant_summary <- data %>%
  group_by(participantCategory) %>%
  summarise(Count = n()) %>%
  mutate(Proportion = Count / sum(Count))


# Research type analysis
research_type_summary <- data %>%
  group_by(researchType) %>%
  summarise(Count = n()) %>%
  mutate(Proportion = Count / sum(Count))
plot_researchType <- ggplot(research_type_summary, 
                            aes(x = reorder(researchType, -Count), y = Proportion)) +
  geom_col(fill = "#4575B4", width = 0.7) +
  scale_y_continuous(labels = percent_format()) +
  labs(title = "Distribution of research types",
       x = "Research type", y = "Proportion of papers") +
  theme_pub() + 
  theme(aspect.ratio = 1.5/1, 
        axis.title.x = element_text(size = 12, vjust = -1), 
        axis.text.x = element_text(size = 9.5),
        axis.title.y = element_text(size = 12, vjust = 2),
        axis.text.y = element_text(size = 9.5))
print(plot_researchType)
ggsave("./plots/research_type.png", plot_researchType, width = 7, height = 5, dpi = 300)


# Research method analysis
method_summary <- data %>%
  group_by(researchMethod) %>%
  summarise(Count = n()) %>%
  mutate(Proportion = Count / sum(Count))
plot_researchMethod <- ggplot(method_summary, 
                              aes(x = Proportion, y = reorder(researchMethod, -Count))) +
  geom_col(fill = "#74ADD1", width = 0.8) +
  scale_x_continuous(labels = percent_format()) +
  labs(title = "Distribution of research methods",
       x = "Research method", y = "Proportion of papers") +
  theme_pub() +
  theme(aspect.ratio = 1.5/1, 
        axis.title.x = element_text(size = 12, vjust = -1), 
        axis.text.x = element_text(size = 9.5),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 9.5))
print(plot_researchMethod)
ggsave("./plots/research_method.png", plot_researchMethod, width = 7, height = 5, dpi = 300)
