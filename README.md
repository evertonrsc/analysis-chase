# A Research Ethics Completeness Analysis for CHASE 2008-2025

This repository contains the dataset, R scripts, and analysis materials developed for a meta-research study on ethics reporting practices in papers published at the *International Conference on Cooperative and Human Aspects of Software Engineering* (CHASE). The study aims to characterize how CHASE authors report ethical aspects of research involving human participants and to identify trends, gaps, and contextual influences over time.

## Overview

Software Engineering is inherently a socio-technical discipline that relies on the collaboration, cognition, and interaction of people who design, build, and maintain software systems. Research on the human side of Software Engineering, that is, how individuals communicate, make decisions, coordinate work, and experience emotions, has long been recognized as central to improving software quality and team performance. Therefore, many studies involve human participants, including professional developers, students, users, and other stakeholders, raising ethical and methodological concerns about participant consent, risk mitigation, and data protection.

This repository provides a transparent and reproducible workflow for analyzing the completeness of ethics reporting across CHASE papers published between 2008 and 2025. The materials include:

- The final dataset with scoring for 231 papers.
- Analysis scripts covering descriptive, temporal, correlational, and contextual analyses.
- A complete R Markdown document that reproduces all statistical results and visualization charts.

---

## Repository Structure

```
.
├── analysis-chase.Rmd   # Knit-ready R Markdown for full reproducibility
├── analysis/            # Data analysis scripts
│   ├── demographics.R   # Script for obtaining an overview of the corpus of analysis
│   ├── rq1_dimensions.R # Script for analyzing the overall ethics completeness score
│   ├── rq2_temporal.R   # Script for analyzing ethics reporting over time
│   ├── rq3_reporting.R  # Script for analyzing ethics dimensions mostly underreported
│   ├── rq4_context.R    # Script for analyzing ethics reporting completeness against other factors
├── chase_papers.xlsx    # Dataset (scoring and yearly paper counts)
├── imports/             # Utility scripts
│   ├── import_data.R    # Data import procedures
│   ├── theme.R          # Custom ggplot2 theme for plots
├── plots/               # Plots generated from the analysis
└── README.md            # This documentation file
```

---

## Reproducibility Guide

### 1. Requirements

The analyses were developed and tested under:

| Component | Version |
|------------|----------|
| R          | 4.4.2  |
| RStudio    | 2025.09.1 |
| Operating system | macOS / Linux / Windows compatible |

Install key R packages with:
```r
required_packages <- c("readxl", "dplyr", "ggplot2", "tidyr", "scales", "stringr", "corrplot", "ragg", "rstatix")
install.packages(required_packages)
```
### 2. Running the Analysis

Option A — Single-step reproduction

```r
rmarkdown::render("analysis-chase.Rmd")
```

This will reproduce all plots, statistical tests, and tables used in the study.

Option B — Modular analysis

You can run the analysis one by one

```r
source("demographocs.R")
source("rq1_dimensions.R")
source("rq2_temporal.R")
source("rq3_reporting.R")
source("rq4_context.R")
```

Each analysis script loads data with the [`import_data.R`](imports/import_data.R) and uses the custom `ggplot2` theme defined in [`theme.R`](imports/theme.R).

### 3. Output

Running the R Markdown file will generate:

- Charts as figures (ethics completeness score distributions, temporal trends, correlation plots)
- Statistical summaries and test results
- Summary tables


## 📊 Dataset Description

[`chase_papers.xlsx`](chase-papers.xslx)  
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
