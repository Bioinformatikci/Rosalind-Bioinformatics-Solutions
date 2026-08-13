# RNA-seq Alternative Splicing Workflow With rMATS

This folder contains a concise workflow note for detecting alternative splicing events from RNA-seq data.

## Contents

| File | Description |
| --- | --- |
| `alternative_splicing_pipeline.md` | Step-by-step command notes for alignment, rMATS analysis, result filtering, and sashimi plot generation. |

## Workflow Summary

1. Align paired-end FASTQ files with STAR and produce sorted BAM files.
2. Run rMATS with case and control BAM lists.
3. Filter significant splicing events by P-value and FDR.
4. Generate sashimi plots for selected events.

## Expected External Inputs

- Paired-end FASTQ files or prepared sorted BAM files.
- A STAR genome index.
- A matching GTF annotation file.
- Case and control BAM-list files for rMATS.
- A conda or system environment containing STAR, rMATS, and rmats2sashimiplot.

## Tools

- STAR
- rMATS
- rmats2sashimiplot
- awk
- Bash/shell workflow commands

## Notes

This folder is a workflow reference rather than a complete reproducible project. It assumes that genome indexes, GTF annotation files, FASTQ files, BAM lists, and conda environments are prepared separately.

The workflow notes in this folder were authored by Burak Keskin. Codex was used only to help organize the repository and write documentation.
