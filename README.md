# Bioinformatics Portfolio Projects

This repository collects selected bioinformatics portfolio projects, analysis scripts, workflow notes, and small applications from my computational biology training.

The projects focus on sequence analysis, transcriptomics, alternative splicing workflows, exploratory visualization, and compact reproducible analysis utilities.

## Repository Overview

| Folder | Focus | Main tools |
| --- | --- | --- |
| [sequence-alignment-and-scoring-matrices/](sequence-alignment-and-scoring-matrices/) | PAM scoring matrices and sequence alignment methods | Python, NumPy, pandas, matplotlib, Jupyter |
| [protein-domain-annotation-mini-organism/](protein-domain-annotation-mini-organism/) | ORF-level protein annotation with BLAST, Pfam, and marker-gene placement | Python, Biopython, pandas, matplotlib |
| [geo-psoriasis-expression-analysis/](geo-psoriasis-expression-analysis/) | GEO psoriasis expression analysis with differential testing and result plots | R, GEOquery, Biobase |
| [bioinformatics-python-scripts/](bioinformatics-python-scripts/) | Small reproducible bioinformatics utilities and analysis scripts | Python, pandas, SciPy, matplotlib |
| [rna-seq-alternative-splicing-rmats/](rna-seq-alternative-splicing-rmats/) | RNA-seq alternative splicing workflow notes | STAR, rMATS, rmats2sashimiplot, shell |
| [interactive-shiny-dashboards/](interactive-shiny-dashboards/) | Interactive data exploration applications | R, Shiny, ggplot2, DT |

## Highlighted Work

- Sequence alignment notebook with PAM-style matrix calculations and a rendered HTML version for quick review.
- Protein-domain annotation project with ORF annotations, Pfam architecture plots, and marker-gene phylogenetic placement.
- GEO psoriasis expression analysis with reproducible R code, summary tables, and diagnostic plots.
- Python scripts for FASTA parsing, motif search, simple genome assembly logic, GBM expression summaries, volcano plotting, and variant population summaries.
- R/Shiny applications for interactive Palmer Penguins and obesity transcriptome data exploration.
- RNA-seq alternative splicing workflow notes using STAR, rMATS, and rmats2sashimiplot.

## Topics Covered

- Sequence alignment and substitution scoring matrices
- Protein domain annotation and homology-based functional interpretation
- Public GEO expression-set analysis
- FASTA parsing and motif search
- Differential expression-style summary analysis
- Variant frequency summaries and visualization
- Alternative splicing workflow design with rMATS
- Interactive R/Shiny visualization

## Notes On Authorship

The analysis code and project files in this repository were authored by Burak Keskin. Codex was used only to help organize the repository structure and draft documentation such as README files.

## Repository Status

This is a portfolio-oriented repository. Some scripts are compact analysis examples or workflow notes rather than fully packaged software. Where external datasets are required, the relevant project README explains the expected input files.

Large raw sequencing files, model outputs, archives, and temporary analysis outputs are intentionally excluded from version control. Small coursework datasets needed by the Shiny examples are included so those apps can be reviewed locally.

## Suggested Use

Start with the project-level README files inside each folder. They explain what each project contains, which tools are involved, and whether the files are intended to be run directly or reviewed as coursework/workflow examples.
