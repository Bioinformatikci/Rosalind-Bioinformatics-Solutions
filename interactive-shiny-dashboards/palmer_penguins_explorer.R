# ==============================================================================
# BENG 415 & BSB 632 - Homework IV: Shiny
# Question 1: Palmer Penguins two-tab Shiny application
# Author : Burak Keskin
# Due    : June 01, 2026
# ------------------------------------------------------------------------------
# 1. Load the packages used by the app
# ------------------------------------------------------------------------------
library(shiny)    # Builds the web interface and connects inputs to outputs
library(ggplot2)  # Creates the scatter plot in the first tab
library(dplyr)    # Makes filtering and summary-table calculations easier

# ------------------------------------------------------------------------------
# 2. Load the penguin data when the app starts
#    The app expects palmer_penguins_data.RData to be in the same folder as the app.
#    This file should contain a data frame called 'penguins' with species,
#    island, bill measurements, flipper length, and sex information.
# ------------------------------------------------------------------------------
load("palmer_penguins_data.RData")

# Remove incomplete rows so the plot and table do not produce missing-value warnings.
penguins <- na.omit(penguins)

# ==============================================================================
# 3. User interface
# ==============================================================================
ui <- fluidPage(

  titlePanel("Palmer Penguins Explorer"),

  sidebarLayout(

    # --------------------------------------------------------------------------
    # Sidebar panel with the four controls requested in the homework.
    # --------------------------------------------------------------------------
    sidebarPanel(

      h4("Plot Settings"),
      hr(),

      # First dropdown: the measurement used on the x-axis.
      selectInput(
        inputId  = "x_var",
        label    = "X-Axis Variable:",
        choices  = list(
          "Bill Length (mm)"    = "bill_length_mm",
          "Bill Depth (mm)"     = "bill_depth_mm",
          "Flipper Length (mm)" = "flipper_length_mm"
        ),
        selected = "bill_length_mm"
      ),

      # Second dropdown: the measurement used on the y-axis.
      selectInput(
        inputId  = "y_var",
        label    = "Y-Axis Variable:",
        choices  = list(
          "Bill Length (mm)"    = "bill_length_mm",
          "Bill Depth (mm)"     = "bill_depth_mm",
          "Flipper Length (mm)" = "flipper_length_mm"
        ),
        selected = "flipper_length_mm"
      ),

      hr(),
      h4("Filter by Gender"),

      # Radio buttons for the sex filter. Only the selected group appears in the plot.
      radioButtons(
        inputId  = "gender",
        label    = "Select Penguin Sex:",
        choices  = list(
          "Male"   = "male",
          "Female" = "female"
        ),
        selected = "male"
      ),

      hr(),
      h4("Point Color"),

      # Radio buttons for point color. The selected value is used by geom_point().
      radioButtons(
        inputId  = "point_color",
        label    = "Select Point Color:",
        choices  = list(
          "Red"   = "red",
          "Green" = "green",
          "Blue"  = "blue"
        ),
        selected = "blue"
      )

    ), # end sidebarPanel

    # --------------------------------------------------------------------------
    # Main panel with the two output tabs.
    # --------------------------------------------------------------------------
    mainPanel(

      tabsetPanel(

        # First tab: scatter plot controlled by the sidebar inputs.
        tabPanel(
          title = "Scatter Plot",
          br(),
          plotOutput(outputId = "scatter_plot", height = "480px"),
          br(),
          p("Only data points from the selected gender are displayed.",
            style = "color: #888; font-size: 12px;")
        ),

        # Second tab: summary table that always uses the full cleaned dataset.
        tabPanel(
          title = "Summary Table",
          br(),
          p("Average bill length, bill depth, and flipper length per species and island:"),
          tableOutput(outputId = "summary_table")
        )

      ) # end tabsetPanel
    )   # end mainPanel
  )     # end sidebarLayout
)       # end fluidPage

# ==============================================================================
# 4. Server logic
# ==============================================================================
server <- function(input, output, session) {

  # ----------------------------------------------------------------------------
  # Keep the selected-sex filter in one reactive expression so the plot updates
  # automatically whenever the user changes the radio button.
  # ----------------------------------------------------------------------------
  filtered_data <- reactive({
    penguins %>%
      filter(sex == input$gender)
  })

  # ----------------------------------------------------------------------------
  # Draw the scatter plot in Tab 1 using the selected x variable, y variable,
  # sex filter, and point color.
  # ----------------------------------------------------------------------------
  output$scatter_plot <- renderPlot({

    df <- filtered_data()   # data after applying the selected sex filter

    # Convert internal column names into labels that look clear on the plot.
    axis_labels <- c(
      bill_length_mm    = "Bill Length (mm)",
      bill_depth_mm     = "Bill Depth (mm)",
      flipper_length_mm = "Flipper Length (mm)"
    )
    x_label <- axis_labels[input$x_var]
    y_label <- axis_labels[input$y_var]

    # Make the title match the selected sex so the plot is self-explanatory.
    gender_label <- ifelse(input$gender == "male", "Male", "Female")
    plot_title   <- paste0("Penguin Scatter Plot - ", gender_label, " Penguins")

    # .data[[...]] lets ggplot use column names chosen from the dropdown menus.
    ggplot(df, aes(x = .data[[input$x_var]], y = .data[[input$y_var]])) +
      geom_point(
        color = input$point_color,   # color selected by the user
        size  = 3,
        alpha = 0.65
      ) +
      labs(
        title    = plot_title,
        subtitle = paste(x_label, "vs.", y_label),
        x        = x_label,
        y        = y_label,
        caption  = "Source: palmerpenguins R package (Horst et al., 2020)"
      ) +
      theme_bw(base_size = 14) +
      theme(
        plot.title    = element_text(face = "bold"),
        plot.subtitle = element_text(color = "#555555"),
        plot.caption  = element_text(color = "#999999", size = 10)
      )
  })

  # ----------------------------------------------------------------------------
  # Build the summary table in Tab 2. It does not depend on the sidebar inputs,
  # because the assignment asks for a fixed species-by-island summary.
  # ----------------------------------------------------------------------------
  output$summary_table <- renderTable({

    penguins %>%
      group_by(Species = species, Island = island) %>%
      summarise(
        "Avg Bill Length (mm)"    = round(mean(bill_length_mm,    na.rm = TRUE), 2),
        "Avg Bill Depth (mm)"     = round(mean(bill_depth_mm,     na.rm = TRUE), 2),
        "Avg Flipper Length (mm)" = round(mean(flipper_length_mm, na.rm = TRUE), 2),
        .groups = "drop"
      ) %>%
      arrange(Species, Island)

  },
  striped  = TRUE,   # alternate row shading makes the table easier to scan
  bordered = TRUE,   # borders separate the cells clearly
  hover    = TRUE    # highlight the row under the mouse
  )

} # end server

# ==============================================================================
# 5. Launch the application
# ==============================================================================
shinyApp(ui = ui, server = server)

