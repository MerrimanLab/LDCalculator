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

POPLIST = list("ALL", "YRI", "LWK", "GWD", "MSL", "ESN", "ASW", "ACB",
               "MXL", "PUR", "CLM", "PEL",
               "CEU", "TSI", "FIN", "GBR", "IBS",
               "CHB", "JPT", "CHS", "CDX", "KHV", 
               "GIH", "PJL", "BEB", "STU", "ITU")

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
                               choices = POPLIST,
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
                    br(),
                    br(),
                    div(
                        p("The LD Explorer is designed to easily and interactively explore linkage
                          disequilibrium in population groups. At present, LD is calculated from the 
                          1000 Genomes datasets (Phase 3). In the future, we aim to extend this
                          so that user's might supply their own data in VCF format.", 
                          style="color: #2c3e50;"),
                        br(),
                        p("There are 4 main areas of the LD Explorer, summarised below:"),
                        tags$ul(
                            tags$li(
                                tags$span("Home", style="color: #2c3e50; font-weight: bold;"), 
                                p("Overview and main configuration settings.", 
                                  style="color: #2c3e50;")
                            ),
                            tags$li(
                                tags$span("LD Zoom", style="color: #2c3e50; font-weight: bold;"),
                                p("Interactive visualisation of regions of LD. LD is calculated for
                                  all SNPs within a region, relative to a user-defined lead SNP.", 
                                  style="color: #2c3e50;")
                            ),
                            tags$li(
                                tags$span("LD Proximity", style="color: #2c3e50; font-weight: bold;"),
                                p("Visualisation (heatmap and dendrogram) of all pairwise LD 
                                  distances within the defined region.", 
                                  style="color: #2c3e50;")
                            ),
                            tags$li(
                                tags$span("LD Pairs", style="color: #2c3e50; font-weight: bold;"),
                                p("Summary information for a pair of variants in high LD.", 
                                  style="color: #2c3e50;")
                            )
                        )
                    ),
                    br(),
                    hr(),
                    h3("Instructions & Global Configuration"),
                    p("You can use the LD Explorer to interactive explore one chromosome region at a time.
                      To get started, enter the Chromosome number, start position and end position in the
                      control bar to the left. Then, select the populations of interest. Note, that you
                      can select multiple populations at once."),
                    br(),
                    p("The populations are arranged as follows:"),
                    fluidRow(
                        column(4, p("ALL", style="color: #2c3e50; font-weight: bold; text-decoration: underline;")),
                        column(4, p("(AFR) African", 
                                    style="color: #2c3e50; font-weight: bold; text-decoration: underline;"),
                               tags$ul(
                                   tags$li("(YRI) Yoruba in Ibadan, Nigera"),
                                   tags$li("(LWK) Luhya in Webuye, Kenya"),
                                   tags$li("(GWD) Gambian in Western Gambia"),
                                   tags$li("(MSL) Mende in Sierra Leone"),
                                   tags$li("(ESN) Esan in Nigeria"),
                                   tags$li("(ASW) Americans of African Ancestry in SW USA"),
                                   tags$li("(ACB) African Carribbeans in Barbados")
                               )
                        ),
                        column(4, p("(AMR) Ad Mixed American", 
                                    style="color: #2c3e50; font-weight: bold; text-decoration: underline;"),
                               tags$ul(
                                   tags$li("(MXL) Mexican Ancestry from Los Angeles, USA"),
                                   tags$li("(PUR) Puerto Ricans from Puerto Rico"),
                                   tags$li("(CLM) Columbians from Medellin, Colombia"),
                                   tags$li("(PEL) Peruvians from Lima, Peru")
                               )
                        )
                    ),
                    fluidRow(
                        column(4, p("(EUR) European", 
                                    style="color: #2c3e50; font-weight: bold; text-decoration: underline;"),
                               tags$ul(
                                   tags$li("(CEU) Utah residents from North and West Europe"),
                                   tags$li("(TSI) Toscani in Italia"),
                                   tags$li("(FIN) Finnish in Finland"),
                                   tags$li("(GBR) British in England and Scotland"),
                                   tags$li("(IBS) Iberian population in Spain")
                               )
                        ),
                        column(4, p("(EAS) East Asian", 
                                    style="color: #2c3e50; font-weight: bold; text-decoration: underline;"),
                               tags$ul(
                                   tags$li("(CHB) Han chinese in Bejing, China"),
                                   tags$li("(JPT) Japanese in Tokyo, Japan"),
                                   tags$li("(CHS) Southern Han Chinese"),
                                   tags$li("(CDX) Chinese Dai in Xishuangbanna, China"),
                                   tags$li("(KHV) Kinh in Ho Chu Minh City, Vietnam")
                               )
                        ),
                        column(4, p("(SAS) South Asian", 
                                    style="color: #2c3e50; font-weight: bold; text-decoration: underline;"),
                               tags$ul(
                                   tags$li("(GIH) Gujarati Indian from Houston, Texas"),
                                   tags$li("(PJL) Punjabi from Lahore, Pakistan"),
                                   tags$li("(BEB) Bengali from Bangladesh"),
                                   tags$li("(STU) Sri Lankan Tamil from the UK"),
                                   tags$li("(ITU) Indian Telugu from the UK")
                               )
                        ),
                        column(4)
                    ),
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