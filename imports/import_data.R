# Install required packages if needed
required_packages <- c("readxl", "dplyr")
for (package in required_packages) {
  if (!requireNamespace(package)) {
    install.packages(package, dependencies = TRUE)
  }
}

# Load libraries
library(readxl)
library(dplyr)

# Retrieve data from spreadsheet
data_file <- "./chase_papers.xlsx"
data <- read_excel(data_file, sheet = 1)
counts <- read_excel(data_file, sheet = 2)

# Mapping column names
data <- data %>%
  rename(
    year = "Year",
    country = "First Author's Country",
    affiliationType = "Author Affiliation Type",
    researchType = "Research Type",
    researchMethod = "Research Method",
    sampleSize = "Sample size (human participants)",
    participantCategory = "Participant category",
    irb = "1. Institutional review approval or waiver reported",
    risk = "2. Risk assessment and mitigation procedures described",
    consent = "3. Informed consent reported",
    withdrawal = "4. Ability to withdraw explicitly stated",
    recruitment = "5. Recruitment method described",
    compensation = "6. Compensation strategy ethically justified",
    vulnerability = "7. Participant vulnerability and power dynamics addressed",
    anonymization = "8. Anonymization procedure and protection of identifying data described",
    secondaryData = "9. Use of secondary or publicly available data or artifacts ethically addressed",
    transparency = "10. Materials available for transparency",
  )
counts <- counts[-nrow(counts), -c(3, 4, 5, 6, 8)]
counts <- counts %>%
  rename(
    year = "Publication year",
    retrievedPapers = "Total of published papers",
    selectedPapers = "Corpus size",
  )

# Coerce dimension values to numeric (0/0.5/1) with NA for N/A
dimension_keywords <- c("irb", "risk", "consent", "withdrawal", "recruitment", 
                        "compensation", "vulnerability", "anonymization", 
                        "secondaryData", "transparency")
to_num_or_na <- function(x){
  if (is.null(x)) return(NA_real_)
  s <- trimws(as.character(x))
  s[s %in% c("NA","N/A","")] <- NA_character_
  s <- gsub(",", ".", s, fixed = TRUE)
  suppressWarnings(as.numeric(s))
}
data <- data |>
  mutate(across(all_of(dimension_keywords), to_num_or_na))