# CHASE Ethics Reporting Dataset and Analysis

This repository contains the dataset, R scripts, and analysis materials developed for a meta-research study on **ethics reporting practices in CHASE (IEEE/ACM International Conference on Software Engineering — CHASE Workshop) papers**.  
The study aims to characterize how CHASE authors report ethical aspects of research involving human participants and to identify trends, gaps, and contextual influences over time.

---

## 🧭 Overview

Software engineering research increasingly involves human participants — developers, students, and professionals — raising ethical and methodological concerns regarding participant consent, risk mitigation, and data protection.  
This repository provides a transparent and reproducible workflow for analyzing the **completeness of ethics reporting** across CHASE papers (2008–2025).

The materials include:
- The **final dataset** with scoring for 231 papers.
- **Analysis scripts** covering descriptive, temporal, correlational, and contextual analyses.
- A **complete R Markdown document** that reproduces all figures and statistical results presented in the manuscript.

---

## 📂 Repository Structure

```
.
├── chase_papers.xlsx          # Dataset (scoring and yearly paper counts)
├── import_data.R              # Data import and cleaning procedures
├── theme.R                    # Custom ggplot2 theme for publication plots
├── rq1_dimensions.R           # Section 3.1 – Corpus scale and paper selection
├── rq2_temporal.R             # Section 3.2 / 3.4 – Temporal evolution of ethics dimensions
├── rq3_reporting.R            # Section 3.4 – Underreported dimensions analysis
├── rq4_context.R              # Section 3.5 – Contextual factors vs. ethics reporting completeness
├── demographics.R             # Summary of participant and research-type demographics
├── CHASE_Analysis_From_Scripts.Rmd  # Knit-ready R Markdown for full reproducibility
└── README.md                  # This file
```

---

## ⚙️ Reproducibility Guide

### 1. Requirements

The analyses were developed and tested under:

| Component | Version |
|------------|----------|
| R          | ≥ 4.3.0  |
| RStudio    | ≥ 2023.12 |
| Operating System | macOS / Linux / Windows compatible |

Key R packages:
```r
tidyverse, readxl, janitor, rstatix, scales, corrplot, stringr, ggplot2
```

Install missing packages with:
```r
install.packages(c("tidyverse", "readxl", "janitor", "rstatix", "scales", "corrplot", "stringr"))
```

### 2. Running the Analysis

Option A — **Single-step reproduction**
```r
rmarkdown::render("CHASE_Analysis_From_Scripts.Rmd")
```
This will reproduce all figures, statistical tests, and tables used in the study.

Option B — **Modular analysis**
You can run the analysis per section (e.g., RQ1–RQ4):
```r
source("import_data.R")
source("theme.R")
source("rq1_dimensions.R")
source("rq2_temporal.R")
source("rq3_reporting.R")
source("rq4_context.R")
```

### 3. Output

Running the R Markdown file will generate:
- Figures (ECS distributions, stacked proportions, temporal trends, correlation plots)
- Statistical summaries and Kruskal–Wallis / Dunn post-hoc results
- Summary tables for dimensions and contextual variables

---

## 📊 Dataset Description

**`chase_papers.xlsx`**  
- **Sheet 1 – Paper-level scoring:** normalized ethics-compliance scores for 10 dimensions  
- **Sheet 2 – Yearly counts:** number of retrieved and selected papers per year (2008–2025)

Each paper is coded across 10 ethics-reporting dimensions, grouped in four domains of ethical practice.  
Dimensions include:
1. Institutional review approval or waiver reported  
2. Risk assessment and mitigation described  
3. Informed consent reported  
4. Ability to withdraw stated  
5. Recruitment method described  
6. Compensation strategy ethically justified  
7. Participant vulnerability and power dynamics addressed  
8. (Pseudo)anonymization procedure described  
9. Use of secondary or publicly available data ethically addressed  
10. Materials available for transparency  

Scores were assigned on a 0–1 scale:
- **0.0** – Not reported  
- **0.5** – Partially reported  
- **1.0** – Fully reported  

---

## 🧩 Research Questions

| RQ | Focus |
|----|-------|
| **RQ1** | To what extent do CHASE papers explicitly report key elements of ethical compliance? |
| **RQ2** | How have ethics-reporting practices evolved within CHASE over time? |
| **RQ3** | Which ethics-reporting dimensions are most frequently underreported? |
| **RQ4** | What contextual factors (e.g., research method, participant type) are associated with stronger or weaker ethics-reporting completeness? |

---

## 📈 Analyses and Visualizations

| Script | Description | Key Output |
|---------|--------------|-------------|
| `rq1_dimensions.R` | Corpus evolution and selection rates | Stacked 100% bars of retrieved vs. selected papers |
| `rq2_temporal.R` | Temporal evolution per ethics dimension | Multi-series line plot with all years labeled |
| `rq3_reporting.R` | Underreported dimensions | Ranked mean ECS bar chart and correlogram |
| `rq4_context.R` | Contextual factors vs. ECSₙ | Independent boxplots and Kruskal–Wallis tests |

---

## 🧠 Interpretation Notes

- **ECS** (Ethics-Compliance Score) aggregates reporting across all applicable dimensions.  
- **ECSₙ** (Normalized ECS) expresses the proportion of addressed dimensions as a percentage.  
- Non-parametric tests (Kruskal–Wallis + Dunn’s post-hoc) were used due to non-normal ECSₙ distribution (Shapiro–Wilk *p* < 0.001).  
- Figures and tables correspond to the CHASE 2026 paper sections 3.1–3.5.

---

## 📜 Citation

If you use this dataset or analysis, please cite as:

> CHASE 2026 Paper Team. *Ethics Reporting Practices in CHASE Research (2008–2025): Dataset and Analysis Repository.*  
> Zenodo, 2025. DOI: [to be assigned]

---

## 🪪 License

All code and scripts are distributed under the **MIT License**.  
The dataset is released under the **CC BY 4.0** license — you may reuse or adapt it with appropriate attribution.

---

## 🤝 Acknowledgments

This repository was developed as part of the *CHASE 2026 meta-research project on ethics in software engineering research*.  
We thank the CHASE community for fostering open discussions on responsible research practices.

---

## 📬 Contact

For questions or contributions, please contact:  
**[Your Name]** — [your.email@example.com]  
or open an issue in the GitHub repository.

---

*Last updated:* `r format(Sys.Date(), "%B %Y")`
