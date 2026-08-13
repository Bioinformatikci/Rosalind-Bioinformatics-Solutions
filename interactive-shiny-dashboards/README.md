# Interactive Shiny Dashboards

This folder contains two small R/Shiny applications developed for interactive data exploration coursework.

## Contents

| File | Description |
| --- | --- |
| `palmer_penguins_explorer.R` | Palmer Penguins explorer with plotting controls and summary outputs. |
| `obesity_transcriptome_explorer.R` | Obesity transcriptome explorer based on Park et al. (2006), GSE474. |
| `palmer_penguins_data.RData` | Dataset used by `palmer_penguins_explorer.R`. |
| `obesity_transcriptome_data.RData` | Dataset used by `obesity_transcriptome_explorer.R`. |

## Tools

- R
- Shiny
- ggplot2
- dplyr
- DT

## Included Data

| Data file | Object loaded by the app | Notes |
| --- | --- | --- |
| `palmer_penguins_data.RData` | `penguins` | Palmer Penguins data used by the penguin explorer. |
| `obesity_transcriptome_data.RData` | `ObeseData` | Obesity transcriptome summary matrix based on Park et al. (2006), GSE474. |

## Running The Apps

Open R in this folder and run one of the following commands:

```r
shiny::runApp(shiny::shinyAppFile("palmer_penguins_explorer.R"))
shiny::runApp(shiny::shinyAppFile("obesity_transcriptome_explorer.R"))
```

If running from another directory, set the working directory to this folder first so the `.RData` files can be loaded correctly.

## App Scope

- `palmer_penguins_explorer.R` provides measurement selection, gender filtering, point color selection, a scatter plot, and a species/island summary table.
- `obesity_transcriptome_explorer.R` compares expression values between normal, obese, and morbidly obese groups with a scatter plot and an interactive data table.

## Notes

These apps are coursework-scale examples of interactive visualization and basic filtering workflows.

The application code in this folder was authored by Burak Keskin. Codex was used only to help organize the repository and write documentation.
