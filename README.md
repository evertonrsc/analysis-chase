# A Research Ethics Completeness Analysis for CHASE 2008-2025

## Description
This repository contains the materials for a meta-research study analyzing ethics reporting practices across 231 papers published at the *International Conference on Cooperative and Human Aspects of Software Engineering* (CHASE) between 2008 and 2025. The analysis consisted of codifying each paper across 10 ethics-related dimensions and assigning an Ethics Completeness Score (ECS) to quantify ethics reporting completeness.

The materials are provided to support transparency, reproducibility, and secondary analyses by other researchers. Detailed instructions for replicating the analyses are provided below.

## Repository Contents

```
.
├── analysis/            # A directory containing the R scripts used for statistical analysis
                           and the generation of charts
│   ├── demographics.R   # Class with the implementation of the two benchmarks
│   ├── rq1_dimensions.R # Class with the implementation of the two benchmarks
│   ├── rq2_temporal.R   # Class with the implementation of the two benchmarks
│   ├── rq3_reporting.R  # Class with the implementation of the two benchmarks
│   ├── rq4_context.R    # Class with the implementation of the two benchmarks
├── chase_papers.xlsx    # A Microsoft Excel spreadsheet with the study's data resulting
                           from the codification of each paper for the ethics-related dimensions
├── imports/             # A directory containing auxiliary R scripts for importing data and
                           setting up a customized theme for charts
│   ├── import_data.R    # Class with the implementation of the two benchmarks
│   ├── theme.R          # Class with the implementation of the two benchmarks
├── plots/               # A directory storing the plots generated from the analysis
└── README.md            # This documentation file
```

## Data Dictionary

Loading the data spreadsheet results in the following data frame. The import script coerces dimension values to numeric values to enable descriptive statistics and nonparametric inference.

| Variable name | Description | Type | Units / Coding |
|:--------------|:------------|:-----|:---------------|
| `ID` | Paper ID | Text | — | — |
| `year` | Paper's publication year | Numeric | Year |
| `country` | First author's country | Text | - |
| `affiliationType` | Author affiliation type | Categorical | Academia, Industry, Academia + Industry |
| `researchType` | Research type | Categorical | Quantitative, Qualitative, Mixed |
| `researchMethod` | Research method | Text | - |
| `sampleSize` | Sample size (human participants) | Numeric | - |
| `participantCategory` | Participant category | Text | - |
| `irb` | Institutional review approval or waiver reported | Numeric | 0.0 = no, 0.5 = partially, 1.0 = yes, NA = not applicable |
| `risk` | Risk assessment and mitigation procedures described | Numeric | 0.0 = no, 0.5 = partially, 1.0 = yes, NA = not applicable |
| `consent` | Risk assessment and mitigation procedures described | Numeric | 0.0 = no, 0.5 = partially, 1.0 = yes, NA = not applicable |
| `withdrawal` | Ability to withdraw explicitly statedd | Numeric | 0.0 = no, 0.5 = partially, 1.0 = yes, NA = not applicable |
| `recruitment` | Recruitment method described | Numeric | 0.0 = no, 0.5 = partially, 1.0 = yes, NA = not applicable |
| `compensation` | Compensation strategy ethically justified | Numeric | 0.0 = no, 0.5 = partially, 1.0 = yes, NA = not applicable |
| `vulnerability` | Participant vulnerability and power dynamics addressed | Numeric | 0.0 = no, 0.5 = partially, 1.0 = yes, NA = not applicable |
| `anonymization` | Anonymization procedure and protection of identifying data described | Numeric | 0.0 = no, 0.5 = partially, 1.0 = yes, NA = not applicable |
| `secondaryData` | Use of secondary or publicly available data or artifacts ethically addressed | Numeric | 0.0 = no, 0.5 = partially, 1.0 = yes, NA = not applicable |
| `transparency` | Materials available for transparency | Numeric | 0.0 = no, 0.5 = partially, 1.0 = yes, NA = not applicable |

## Analysis Workflow
