# Protein Domain Annotation of a Mini-Organism ORF Set

This repository presents a compact protein annotation workflow for a small set of predicted open reading frames (ORFs). The analysis combines homology search, Pfam domain evidence, manual functional interpretation, and marker-gene phylogenetic placement.

The project was originally developed as a team-based academic analysis by Burak Keskin and Riza Bilgin, then reorganized into a clean portfolio repository. The analysis code and project work are not AI-generated; Codex was used only to help curate the repository structure and improve documentation wording.

## Project Summary

The workflow annotates 12 predicted proteins from a mystery mini-organism FASTA file. It uses BLASTp against SwissProt and Pfam-A domain searches through InterProScan REST services, then summarizes the evidence into a table and visual domain architecture figure. A conserved marker protein is also used for a small phylogenetic placement analysis.

The final interpretation identifies the ORF set as most consistent with a hyperthermophilic methanogenic archaeon closely matching *Methanocaldococcus jannaschii*.

## Repository Structure

```text
protein_domain_annotation_term_project/
  README.md
  requirements.txt
  notebooks/
    protein_domain_annotation_pipeline.ipynb
  data/
    mystery_orfs.fasta
  results/
    tables/
      protein_domain_annotation_table.csv
      marker_gene_tree.nwk
    figures/
      domain_architecture.png
      marker_gene_tree.png
  reports/
    protein_domain_annotation_report.pdf
  slides/
    protein_domain_annotation_slides.pptx
```

## Inputs

- `data/mystery_orfs.fasta`: predicted protein sequences used as the primary input.

The notebook can be run from the repository root or from the `notebooks/` directory. Output paths are resolved relative to the repository structure.

## Methods

- Parse and inspect the input FASTA file with Biopython.
- Query SwissProt using NCBI BLASTp for per-ORF homology evidence.
- Query Pfam-A using the EBI InterProScan REST API for protein-domain evidence.
- Cache API responses locally under `.cache/api_results/` to avoid repeated web requests during reruns.
- Build a curated annotation table from BLAST, Pfam, and manual interpretation.
- Generate a Pfam domain architecture figure across the ORF set.
- Place the EF-Tu / elongation factor marker sequence in a small neighbor-joining tree using embedded reference sequences.

## Outputs

- `results/tables/protein_domain_annotation_table.csv`: final ORF-level annotation summary.
- `results/tables/marker_gene_tree.nwk`: marker-gene tree in Newick format.
- `results/figures/domain_architecture.png`: Pfam domain architecture summary.
- `results/figures/marker_gene_tree.png`: marker-gene phylogenetic placement figure.
- `reports/protein_domain_annotation_report.pdf`: project report.
- `slides/protein_domain_annotation_slides.pptx`: presentation slides.

## Reproducibility Notes

The notebook uses public web services from NCBI and EBI. Results may vary slightly over time as databases are updated. Local API cache files are intentionally excluded from Git because they are generated artifacts and can contain bulky intermediate responses.

Before running API-backed cells, replace the placeholder Entrez email in the notebook with your own contact email, as requested by NCBI usage guidelines.

Install the Python dependencies with:

```bash
pip install -r requirements.txt
```

Then run:

```bash
jupyter notebook notebooks/protein_domain_annotation_pipeline.ipynb
```

## Limitations

This is a compact annotation exercise rather than a full genome-scale taxonomic workflow. The strain-level interpretation is based on a limited ORF set and marker-gene context; stronger confirmation would require whole-genome comparison, broader marker sampling, or read-level validation.

