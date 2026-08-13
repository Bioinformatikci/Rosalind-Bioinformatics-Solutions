# RNA-seq Alternative Splicing Pipeline With rMATS

This note outlines a basic RNA-seq alternative splicing workflow using STAR, rMATS, and rmats2sashimiplot.

## 1. Align FASTQ Files With STAR

```bash
STAR \
  --genomeDir ./genome_index \
  --readFilesIn read1.fastq.gz read2.fastq.gz \
  --readFilesCommand zcat \
  --outFileNamePrefix ./results/sample_ \
  --outSAMtype BAM SortedByCoordinate \
  --runThreadN 4
```

## 2. Run rMATS

The files `b1.txt` and `b2.txt` should contain comma-separated BAM paths for the two comparison groups.

```bash
rmats.py \
  --b1 b1.txt \
  --b2 b2.txt \
  --gtf gencode.v24.annotation.gtf \
  --od rmats_results \
  --tmp tmp_directory \
  -t paired \
  --readLength 100 \
  --nthread 6 \
  --variable-read-length \
  --cstat 0.05
```

## 3. Filter Significant Skipped Exon Events

This example filters skipped exon results using P-value and FDR thresholds.

```bash
awk -F'\t' 'NR > 1 && $19 < 0.05 && $20 < 0.05' \
  rmats_results/SE.MATS.JC.txt > filtered_SE.txt
```

## 4. Generate Sashimi Plots

Run this step in an environment where `rmats2sashimiplot` is installed.

```bash
rmats2sashimiplot \
  --b1 sample1.bam,sample2.bam \
  --b2 control1.bam,control2.bam \
  -t SE \
  -e filtered_SE.txt \
  -l1 AD \
  -l2 Control \
  --exon_s 1 \
  --intron_s 5 \
  -o sashimi_output
```

## Notes

Paths, annotation versions, read length, and group labels should be adjusted for the dataset being analyzed.

The workflow notes in this file were authored by Burak Keskin. Codex was used only to help organize the repository and write documentation.
