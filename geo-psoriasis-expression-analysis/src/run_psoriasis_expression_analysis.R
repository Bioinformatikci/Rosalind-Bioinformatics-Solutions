suppressPackageStartupMessages({
  library(GEOquery)
  library(Biobase)
})

CONFIG <- list(
  geo_accession = "GSE52471",
  case_title_pattern = "^Psoriasis",
  control_title_pattern = "^Normal",
  adjusted_p_cutoff = 0.01,
  nominal_p_cutoff = 0.05,
  top_n_genes = 5,
  reference_top_table = file.path("data", "GSE52471_top_table_reference.tsv"),
  tables_dir = file.path("results", "tables"),
  plots_dir = file.path("results", "plots")
)

dir.create(CONFIG$tables_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(CONFIG$plots_dir, recursive = TRUE, showWarnings = FALSE)

clean_gene_symbol <- function(symbols) {
  sub("/.*", "", symbols)
}

load_geo_expression_set <- function(accession) {
  geo_objects <- getGEO(accession, AnnotGPL = TRUE)
  if (!length(geo_objects)) {
    stop("No GEO expression sets returned for accession: ", accession)
  }
  geo_objects[[1]]
}

get_group_columns <- function(pheno_data, case_pattern, control_pattern) {
  case_cols <- grep(case_pattern, pheno_data$title)
  control_cols <- grep(control_pattern, pheno_data$title)

  if (!length(case_cols) || !length(control_cols)) {
    stop("Could not identify both case and control groups from sample titles.")
  }

  list(case = case_cols, control = control_cols)
}

compute_ttest_table <- function(expression_matrix, feature_data, groups) {
  p_values <- apply(expression_matrix, 1, function(row_values) {
    t.test(row_values[groups$case], row_values[groups$control])$p.value
  })

  gene_symbols <- feature_data$`Gene symbol`
  if (is.null(gene_symbols)) {
    gene_symbols <- rownames(expression_matrix)
  }

  data.frame(
    probe_id = rownames(expression_matrix),
    gene_symbol = gene_symbols,
    p_value = p_values,
    adj_p_value_bh = p.adjust(p_values, method = "BH"),
    stringsAsFactors = FALSE
  )
}

find_lost_correlations <- function(expression_matrix, gene_indices, groups, method, alpha) {
  pairs <- combn(gene_indices, 2, simplify = FALSE)

  results <- lapply(pairs, function(pair) {
    control_test <- cor.test(
      expression_matrix[pair[1], groups$control],
      expression_matrix[pair[2], groups$control],
      method = method
    )
    case_test <- cor.test(
      expression_matrix[pair[1], groups$case],
      expression_matrix[pair[2], groups$case],
      method = method
    )

    data.frame(
      gene_1 = rownames(expression_matrix)[pair[1]],
      gene_2 = rownames(expression_matrix)[pair[2]],
      method = method,
      control_p_value = control_test$p.value,
      case_p_value = case_test$p.value,
      lost_correlation = control_test$p.value < alpha && case_test$p.value > alpha,
      stringsAsFactors = FALSE
    )
  })

  do.call(rbind, results)
}

plot_pvalue_distribution <- function(results_table, output_path) {
  png(output_path, width = 1200, height = 800, res = 150)
  hist(
    results_table$p_value,
    breaks = 50,
    col = "#6BAED6",
    border = "white",
    main = "Nominal p-value distribution",
    xlab = "p-value"
  )
  dev.off()
}

plot_top_gene_heatmap <- function(expression_matrix, top_indices, groups, output_path) {
  selected <- expression_matrix[top_indices, c(groups$case, groups$control), drop = FALSE]
  scaled <- t(scale(t(selected)))

  png(output_path, width = 1200, height = 800, res = 150)
  heatmap(
    scaled,
    Colv = NA,
    scale = "none",
    col = hcl.colors(50, "Blue-Red 3"),
    main = "Top differentially expressed probes"
  )
  dev.off()
}

main <- function(config = CONFIG) {
  expression_set <- load_geo_expression_set(config$geo_accession)
  expression_matrix <- exprs(expression_set)
  pheno_data <- pData(expression_set)
  feature_data <- fData(expression_set)
  groups <- get_group_columns(
    pheno_data,
    config$case_title_pattern,
    config$control_title_pattern
  )

  raw_results <- compute_ttest_table(expression_matrix, feature_data, groups)
  raw_results <- raw_results[order(raw_results$p_value), ]

  write.csv(
    raw_results,
    file.path(config$tables_dir, "differential_expression_raw_scale.csv"),
    row.names = FALSE
  )

  significant_genes <- clean_gene_symbol(
    raw_results$gene_symbol[raw_results$adj_p_value_bh <= config$adjusted_p_cutoff]
  )
  write.table(
    unique(na.omit(significant_genes)),
    file.path(config$tables_dir, "bh_significant_genes_raw_scale.txt"),
    quote = FALSE,
    row.names = FALSE,
    col.names = FALSE
  )

  if (file.exists(config$reference_top_table)) {
    reference_table <- read.delim(config$reference_top_table, stringsAsFactors = FALSE)
    reference_genes <- reference_table$Gene.symbol[
      reference_table$adj.P.Val <= config$adjusted_p_cutoff
    ]
    shared_genes <- intersect(unique(significant_genes), unique(clean_gene_symbol(reference_genes)))
    write.table(
      shared_genes,
      file.path(config$tables_dir, "shared_significant_genes_with_geo2r.txt"),
      quote = FALSE,
      row.names = FALSE,
      col.names = FALSE
    )
  }

  log2_expression_matrix <- log2(expression_matrix)
  log2_results <- compute_ttest_table(log2_expression_matrix, feature_data, groups)
  log2_results <- log2_results[order(log2_results$p_value), ]
  write.csv(
    log2_results,
    file.path(config$tables_dir, "differential_expression_log2_scale.csv"),
    row.names = FALSE
  )

  log2_significant_genes <- clean_gene_symbol(
    log2_results$gene_symbol[log2_results$adj_p_value_bh <= config$adjusted_p_cutoff]
  )
  write.table(
    unique(na.omit(log2_significant_genes)),
    file.path(config$tables_dir, "bh_significant_genes_log2_scale.txt"),
    quote = FALSE,
    row.names = FALSE,
    col.names = FALSE
  )

  top_probe_ids <- raw_results$probe_id[seq_len(min(config$top_n_genes, nrow(raw_results)))]
  top_indices <- match(top_probe_ids, rownames(expression_matrix))
  top_indices <- top_indices[!is.na(top_indices)]
  if (length(top_indices) < 2) {
    stop("At least two top probes are required for pairwise correlation testing.")
  }
  pearson_losses <- find_lost_correlations(
    expression_matrix,
    top_indices,
    groups,
    method = "pearson",
    alpha = config$nominal_p_cutoff
  )
  spearman_losses <- find_lost_correlations(
    expression_matrix,
    top_indices,
    groups,
    method = "spearman",
    alpha = config$nominal_p_cutoff
  )

  write.csv(
    rbind(pearson_losses, spearman_losses),
    file.path(config$tables_dir, "top_gene_correlation_shift_tests.csv"),
    row.names = FALSE
  )

  summary_table <- data.frame(
    geo_accession = config$geo_accession,
    n_probes = nrow(expression_matrix),
    n_case_samples = length(groups$case),
    n_control_samples = length(groups$control),
    nominal_p_0_05_raw_scale = sum(raw_results$p_value <= 0.05, na.rm = TRUE),
    nominal_p_0_01_raw_scale = sum(raw_results$p_value <= 0.01, na.rm = TRUE),
    bonferroni_p_0_05_raw_scale = sum(p.adjust(raw_results$p_value, method = "bonferroni") <= 0.05, na.rm = TRUE),
    bh_p_0_01_raw_scale = sum(raw_results$adj_p_value_bh <= config$adjusted_p_cutoff, na.rm = TRUE),
    bh_p_0_01_log2_scale = sum(log2_results$adj_p_value_bh <= config$adjusted_p_cutoff, na.rm = TRUE),
    stringsAsFactors = FALSE
  )
  write.csv(
    summary_table,
    file.path(config$tables_dir, "analysis_summary.csv"),
    row.names = FALSE
  )

  plot_pvalue_distribution(
    raw_results,
    file.path(config$plots_dir, "pvalue_distribution_raw_scale.png")
  )
  plot_top_gene_heatmap(
    expression_matrix,
    top_indices,
    groups,
    file.path(config$plots_dir, "top_gene_expression_heatmap.png")
  )

  message("Analysis complete. Tables: ", config$tables_dir, " Plots: ", config$plots_dir)
}

if (sys.nframe() == 0) {
  main()
}
