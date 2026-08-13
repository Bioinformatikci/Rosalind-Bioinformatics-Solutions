# ==============================================================================
# BENG 415 & BSB 632 - Homework IV: Shiny
# Question 2: Obesity transcriptome data from Park et al. (2006), GSE474
# Author : Burak Keskin
# Due    : June 01, 2026
# ------------------------------------------------------------------------------
# 1. Load the packages used by the app
# ------------------------------------------------------------------------------
library(shiny)    # Builds the web interface and handles reactivity
library(ggplot2)  # Creates the expression scatter plot
library(DT)       # Displays the selected expression values as an interactive table

# ------------------------------------------------------------------------------
# 2. Load the transcriptome data when the app starts
#    obesity_transcriptome_data.RData should contain a data frame named ObeseData.
#    Each row is a probe ID, and the three columns store average expression
#    values for the normal, obese, and morbidly obese groups.
# ------------------------------------------------------------------------------
load("obesity_transcriptome_data.RData")

# Use consistent column names so the dropdown choices always match the data.
colnames(ObeseData) <- c("Normal", "Obese", "Morbidly_Obese")

# ==============================================================================
# 3. User interface
# ==============================================================================
ui <- fluidPage(

  titlePanel("Obesity Transcriptome Explorer - Park et al. (2006)"),

  sidebarLayout(

    # --------------------------------------------------------------------------
    # Sidebar panel with the three controls required for this question.
    # --------------------------------------------------------------------------
    sidebarPanel(

      h4("Analysis Controls"),
      hr(),

      # First dropdown: choose the group shown on the x-axis.
      selectInput(
        inputId  = "group_x",
        label    = "X-Axis Group:",
        choices  = list(
          "Normal"         = "Normal",
          "Obese"          = "Obese",
          "Morbidly Obese" = "Morbidly_Obese"
        ),
        selected = "Normal"
      ),

      # Second dropdown: choose the group shown on the y-axis and in the table.
      selectInput(
        inputId  = "group_y",
        label    = "Y-Axis Group:",
        choices  = list(
          "Normal"         = "Normal",
          "Obese"          = "Obese",
          "Morbidly Obese" = "Morbidly_Obese"
        ),
        selected = "Obese"
      ),

      hr(),

      # Slider: choose how many of the first probe IDs are included.
      # The assignment asks for a range from 10 to 1000.
      sliderInput(
        inputId = "gene_count",
        label   = "Number of Genes (Probe IDs):",
        min     = 10,
        max     = 1000,
        value   = 200,
        step    = 1
      )

    ), # end sidebarPanel

    # --------------------------------------------------------------------------
    # Main panel with two tabs and the required explanation on the right side.
    # --------------------------------------------------------------------------
    mainPanel(

      tabsetPanel(

        # First tab: scatter plot for the two selected groups.
        tabPanel(
          title = "Scatter Plot",
          br(),
          plotOutput(outputId = "expression_scatter", height = "460px"),
          br(),
          p("Each point represents one probe ID. The red dashed diagonal (y = x)
             marks equal average expression between the two selected groups.",
            style = "color: #888; font-size: 12px;")
        ),

        # Second tab: interactive table for the same two groups and selected rows.
        tabPanel(
          title = "Data Table",
          br(),
          p("Average expression values for the two selected groups (first N probe IDs):"),
          DT::dataTableOutput(outputId = "expression_table")
        )

      ), # end tabsetPanel

      hr(),

      # --------------------------------------------------------------------
      # This section explains the app and satisfies the right-side description
      # requested in part 2a of the homework.
      # --------------------------------------------------------------------
      wellPanel(
        h4("About This Application"),
        p("This Shiny application visualizes microarray gene expression data
           from Park et al. (2006), published in Physiological Genomics."),
        p(strong("Dataset:"), " GEO Accession GSE474 - Human skeletal muscle
           transcriptome profiled in three subject groups:"),
        tags$ul(
          tags$li(strong("Normal:"),         " Healthy, insulin-sensitive individuals"),
          tags$li(strong("Obese:"),          " Obese, insulin-resistant individuals"),
          tags$li(strong("Morbidly Obese:"), " Morbidly obese individuals")
        ),
        p("Each row in the dataset represents one probe ID (gene). The stored
           values are average expression levels across all subjects in that group."),
        p("Use the two dropdown menus to select any pair of groups to compare.
           The slider controls how many probe IDs (starting from the first) are
           included in both the scatter plot and the data table."),
        p(em("On the scatter plot, the red dashed y = x line indicates equal
              expression in both groups. Points above the line are more highly
              expressed in the Y-axis group; points below are more highly
              expressed in the X-axis group."),
          style = "font-size: 11px; color: #555;")
      ) # end wellPanel

    )   # end mainPanel
  )     # end sidebarLayout
)       # end fluidPage

# ==============================================================================
# 4. Server logic
# ==============================================================================
server <- function(input, output, session) {

  # ----------------------------------------------------------------------------
  # Prepare the selected rows and groups in one reactive expression. Both the
  # plot and table use this same object, so they stay synchronized with the
  # dropdown menus and slider.
  # ----------------------------------------------------------------------------
  selected_data <- reactive({

    n <- input$gene_count   # number of probe IDs selected by the slider

    # Convert the selected expression values to a matrix inside the server,
    # as suggested in the homework instructions.
    mat <- as.matrix(ObeseData[1:n, c(input$group_x, input$group_y)])

    # Convert back to a data frame because ggplot2 and DT work smoothly with it.
    df <- as.data.frame(mat)

    # Add a simple probe ID based on the original row position.
    df$Probe_ID <- seq_len(n)

    df
  })

  # ----------------------------------------------------------------------------
  # Draw the scatter plot in Tab 1. The axes come directly from the two dropdown
  # selections, and the red diagonal line marks equal expression.
  # ----------------------------------------------------------------------------
  output$expression_scatter <- renderPlot({

    df <- selected_data()

    # Use clean labels on the plot instead of the internal column names.
    label_map <- c(
      Normal         = "Normal",
      Obese          = "Obese",
      Morbidly_Obese = "Morbidly Obese"
    )
    x_label    <- paste(label_map[input$group_x], "- Avg Expression")
    y_label    <- paste(label_map[input$group_y], "- Avg Expression")
    plot_title <- paste("Gene Expression:",
                        label_map[input$group_x], "vs.", label_map[input$group_y])
    subtitle   <- paste("First", input$gene_count, "probe IDs | GSE474")

    # .data[[...]] lets ggplot use column names selected by the user.
    ggplot(df, aes(x = .data[[input$group_x]], y = .data[[input$group_y]])) +

      # Points on this diagonal have the same average expression in both groups.
      geom_abline(
        intercept = 0, slope = 1,
        color = "red", linetype = "dashed", linewidth = 0.8
      ) +

      # Each point represents one probe ID.
      geom_point(
        color = "#2C7BB6",
        alpha = 0.55,
        size  = 2
      ) +

      labs(
        title    = plot_title,
        subtitle = subtitle,
        x        = x_label,
        y        = y_label,
        caption  = "Park et al. (2006), Physiol Genomics 27:114-121 | GEO: GSE474"
      ) +
      theme_classic(base_size = 14) +
      theme(
        plot.title    = element_text(face = "bold"),
        plot.subtitle = element_text(color = "#555555"),
        plot.caption  = element_text(color = "#999999", size = 10)
      )
  })

  # ----------------------------------------------------------------------------
  # Build the interactive table in Tab 2 with the two selected groups and a
  # probe ID column for easier reading.
  # ----------------------------------------------------------------------------
  output$expression_table <- DT::renderDataTable({

    df <- selected_data()   # selected expression values plus Probe_ID

    # Show Probe_ID first, followed by the two selected expression columns.
    df <- df[, c("Probe_ID", input$group_x, input$group_y)]

    # Replace underscores in headers so the table looks cleaner.
    colnames(df) <- c(
      "Probe ID",
      gsub("_", " ", input$group_x),
      gsub("_", " ", input$group_y)
    )

    df

  },
  options  = list(
    pageLength      = 15,    # show 15 rows per page
    scrollX         = TRUE,  # keep the table usable on narrow screens
    searchHighlight = TRUE   # highlight text that matches the search box
  ),
  rownames = FALSE            # Probe_ID is already shown, so hide the default row index
  )

} # end server

# ==============================================================================
# 5. Launch the application
# ==============================================================================
shinyApp(ui = ui, server = server)

