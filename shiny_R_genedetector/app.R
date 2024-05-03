library(shiny)
library(readr)
library(dplyr)

root_dir <- "/Users/u0118120/FlySleepLab Dropbox/Joana/sleep_signature/10x/analysis/code/description/shiny_R_genedetector/"
  
# Define UI for application
ui <- fluidPage(
  
  titlePanel("gene expression detector"),
  HTML("<p>This app is for those with the following question:</p>
       <p>How strongly are my genes of interest expressed across cell types in the adult fly brain?</p>
       <p>Download a table below listing the expression of your input genes per cell type (provided as a fraction of cells expressing the gene within the same cell type)</p>
       <p>The calculations are based on the 106K single-cell dataset of adult fruit fly central brains described in this <a href='https://www.nature.com/articles/s41593-023-01549-4'>publication.</a></p>
       <p>More information can be found in this <a href='https://github.com/joanadopp/genedetector'>github repository.</a></p>"),
  
  sidebarLayout(
    sidebarPanel(
      # Input: Upload list of genes
      fileInput("genes_file", accept = ".csv", multiple = FALSE, "Choose your gene list (.csv file). Genes need to be listed in the first column without header, one gene per row."),
      
      # Download button
      downloadButton("downloadData", "Download Data")
    ),
    # Main panel
    mainPanel(
      HTML("<p>The genes in the list below that you have uploaded are not captured in our dataset.</p>"),
      tableOutput("missingGenes")
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  
  all_data <- reactive({
    read_csv(file.path(root_dir, "data/genedetector_all.csv"))
  })
  
  # Read uploaded gene list
  user_genes <- reactive({
    req(input$genes_file)
    genes <- read_csv(input$genes_file$datapath, col_names = FALSE)$X1
    return(genes)
  })
  
  # Subset data based on selected genes
  missing_data <- reactive({
    req(input$genes_file)
    req(all_data())
    selected_genes <- user_genes()
    present_genes <- intersect(selected_genes, colnames(all_data()))
    missing_genes <- setdiff(selected_genes, present_genes)
    missing_df <- data.frame(Missing_Genes = missing_genes)
    return(missing_df)
    })
    
  # Render missing genes as table
  output$missingGenes <- renderTable({
    missing_data()
  })
  
  # Subset data based on selected genes
  subset_data <- reactive({
    req(input$genes_file)
    req(all_data())
    selected_genes <- user_genes()
    present_genes <- intersect(selected_genes, colnames(all_data()))
    columns_to_keep <- c("cell_type", "cell_count", present_genes)
    subsetted_df <- all_data() %>% select(all_of(columns_to_keep))
    return(subsetted_df)
  })
  
  # Download subsetted data
  output$downloadData <- downloadHandler(
    filename = function() {
      # Create filename with current date and time
      paste(format(Sys.time(), "%Y%m%d_"), "gene_detector", ".csv", sep = "")
    },
    content = function(file) {
      write.csv(subset_data(), file, row.names = FALSE)
    }
  )
}

shinyApp(ui = ui, server = server)
