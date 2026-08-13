# Bioinformatics Python Scripts

This folder contains Python scripts written while practicing bioinformatics programming and introductory omics analysis tasks.

## Contents

| Script | Purpose |
| --- | --- |
| `gbm_gene_expression_analysis.py` | Reads a GBM expression table, calculates fold changes, runs Welch's t-tests, and writes filtered result tables. |
| `gbm_volcano_plot.py` | Creates a basic volcano-style scatter plot from processed GBM expression results. |
| `genome_assembly_shortest_superstring.py` | Early work-in-progress script for FASTA parsing and shortest superstring assembly logic. |
| `lcsm_shared_motif_search.py` | Searches for the longest shared motif across FASTA sequences. |
| `sliding_motif_tracker.py` | Searches for a motif chain within FASTA sequences and writes hit positions. |
| `variant_population_analysis.py` | Summarizes variant frequencies by population and creates a Venn diagram. |

## Tools

- Python
- pandas
- NumPy
- SciPy
- matplotlib
- matplotlib-venn

## Expected Inputs And Outputs

| Script | Expected input | Generated output |
| --- | --- | --- |
| `gbm_gene_expression_analysis.py` | `HW_GBM.csv` | `FC_increase.csv`, `FC_decrease.csv`, `HW_GBM_DEVAM.csv`, `p_005.csv`, `P_001.csv` |
| `gbm_volcano_plot.py` | `HW_GBM_DEVAM.csv` | Volcano-style matplotlib figure |
| `genome_assembly_shortest_superstring.py` | `gen.fasta` | Shortest superstring printed to standard output |
| `lcsm_shared_motif_search.py` | FASTA-formatted sequence file | Longest shared motif printed to standard output |
| `sliding_motif_tracker.py` | `gen.fasta`, `motifs.fasta` | `motif_chain_hits.txt` |
| `variant_population_analysis.py` | `variants.tsv` | `stats_and_counts.txt`, `filtered.tsv`, `venn_diagram.png` |

The input files are not all included here, so the scripts should be read as analysis examples unless the required data files are added locally.

## Notes

These scripts are educational and exploratory. A future improvement would be to standardize file names, add command-line arguments, and provide small example input files.

The code in this folder was authored by Burak Keskin. Codex was used only to help organize the repository and write documentation.
