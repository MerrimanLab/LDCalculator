# LDExplorer ui.R
#
# The LD Explorer is motivated by the need to explore patterns of LD.
# This tool is largely inspired by the interactive analysis tool developed by
# the National Cancer Institute (NCI) (http://analysistools.nci.nih.gov/LDlink/?tab=home).
# Though it has been extended to work with 1000 Genomes data as well
# as user-supplied data sets (in VCF format).
#
# Nick Burns
# March, 2016

library(shiny)

shinyUI(
    pageWithSidebar(
        
        headerPanel(""),
        sidebarPanel(
            h2("LD Explorer", style="color: #3498db; text-align: center;"),
            hr(),
            br(),
            
            # main controls (chromosome and start  / end positions)
            p("Put instructions here...", style="color: #2c3e50;"),
            br(),
            
            #### Home, main configuration
            conditionalPanel(
                condition = "input.conditionedPanels == 1",
                
                fluidRow(
                    column(
                        5, 
                        br(),
                        p("Chromosome:", style="font-weight: bold; color: #2c3e50; padding-top: 6px; float: right;")),
                    column(
                        7,
                        textInput("txtChr", "", value = "",
                                  placeholder = "example: 5")
                    )
                ),
                fluidRow(
                    column(
                        5, br(),
                        p("Start:", style="font-weight: bold; color: #2c3e50; padding-top: 6px; float: right;")
                    ),
                    column(
                        7,
                        textInput("txtStart", "", value = "",
                                  placeholder = "example: 10000")
                    )
                ),
                fluidRow(
                    column(
                        5, br(),
                        p("End:", style="font-weight: bold; color: #2c3e50; padding-top: 6px; float: right;")
                    ),
                    column(
                        7,
                        textInput("txtEnd", "", value="",
                                  placeholder = "example: 15000")
                    )
                ),
                hr(),
                br(),
                # ---- Population Controls ----
                selectizeInput("inPop",
                               "Select population: ",
                               choices = list("GBR", "CEU", "FIN", "IBS", "TSI"),
                               multiple = TRUE
                ),
                
                hr(),
                br(),
                actionButton("btnGetLD",
                             label = p("Calculate LD", style="color: #ecf0f1; font-size: 15px;"),
                             style = "text-align: center; height: 35px; margin: auto; background-color: #3498db; float: right;")
            ),
            
            #### LD Zooms (proxies)
            conditionalPanel(
                condition = "input.conditionedPanels == 2",
                
                # ---- SNP controls (targeted snp) ----
                fluidRow(
                    column(
                        4, br(), 
                        p("SNP:", style="font-weight: bold; color: #2c3e50; padding-top: 6px; float: right;")
                    ),
                    column(
                        8,
                        textInput("txtSNP", "", value="",
                                  placeholder = "example: rs67808744")
                    )
                ),
                hr(),
                br(),
                actionButton("btnLDZoom",
                             label = p("Visualise LD", style="color: #ecf0f1; font-size: 15px;"),
                             style = "text-align: center; height: 35px; margin: auto; background-color: #3498db; float: right;")
            ),
            
            #### LD Heatmaps
            conditionalPanel(
                condition = "input.conditionedPanels == 3",
                fluidRow(
                    column(
                        5, 
                        br(),
                        p("Chromosome:", style="font-weight: bold; color: #2c3e50; padding-top: 6px; float: right;")),
                    column(
                        7,
                        textInput("txtChr", "", value = "",
                                  placeholder = "example: 5")
                    )
                ),
                fluidRow(
                    column(
                        5, br(),
                        p("Start:", style="font-weight: bold; color: #2c3e50; padding-top: 6px; float: right;")
                    ),
                    column(
                        7,
                        textInput("txtStart", "", value = "",
                                  placeholder = "example: 10000")
                    )
                ),
                fluidRow(
                    column(
                        5, br(),
                        p("End:", style="font-weight: bold; color: #2c3e50; padding-top: 6px; float: right;")
                    ),
                    column(
                        7,
                        textInput("txtEnd", "", value="",
                                  placeholder = "example: 15000")
                    )
                )
            ),
            br(),
            br(),
            width = 2
        ),
        mainPanel(
            tabsetPanel(
                tabPanel(
                    h4("Home"),
                    value = 1
                ),
                tabPanel(
                    h4("LD Zoom"),
                    plotOutput("pltZoom"),
                    dataTableOutput("proxyTableSummary"),
                    value = 2
                ),
                tabPanel(
                    h4("LD Proximity"),
                    plotOutput("pltHeatmap"),
                    value = 3
                ),
                tabPanel(
                    h4("LD Pairs")
                ),
                id = "conditionedPanels"
            )
        )
    )
)