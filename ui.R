##
## LD Calculation Interface
##
## Front end for LDCalculation. Contains two tabs:
##    100Genomes:  allows users to calculate LD for given SNPs from 1000 Genomes
##    User Data:   allows users to define their own VCF files and Samples to calculate LD for.
##
## Values from input widgets are saved to global variables in server.R. These may then be used
## to pass parameters to the backend for the calculation of LD.
##
## Nick Burns
## Jan 2016
##

## UI.R
library(shiny)
library(shinyFiles)
setwd("~/Documents/GitHub/LDCalculator")


shinyUI(
    navbarPage(
        "LD Calculator",
        
        ## Setup 3 tabs: 1000 Genomes, User Data, Instructions
        tabPanel(
            "Instructions",
            mainPanel(
                h3(),
                br(),
                br(),
                p("In olden times when wishing still helped one, there lived a king
whose daughters were all beautiful, but the youngest was so beautiful
                  that the sun itself, which has seen so much, was astonished whenever
                  it shone in her face.  Close by the king's castle lay a great dark
                  forest, and under an old lime-tree in the forest was a well, and when
                  the day was very warm, the king's child went out into the forest and
                  sat down by the side of the cool fountain, and when she was bored she
                  took a golden ball, and threw it up on high and caught it, and this
                  ball was her favorite plaything."),
                br(),
                p("Now it so happened that on one occasion the princess's golden ball
                  did not fall into the little hand which she was holding up for it,
                  but on to the ground beyond, and rolled straight into the water.  The
                  king's daughter followed it with her eyes, but it vanished, and the
                  well was deep, so deep that the bottom could not be seen.  At this
                  she began to cry, and cried louder and louder, and could not be
                  comforted.  And as she thus lamented someone said to her, 'What ails
                  you, king's daughter?  You weep so that even a stone would show pity.'"),
                br(),
                p("She looked round to the side from whence the voice came, and saw a
                  frog stretching forth its big, ugly head from the water.  'Ah, old
                  water-splasher, is it you,' she said, 'I am weeping for my golden ball,
                  which has fallen into the well.'")
            )
        ),  
        tabPanel(
              "1000 Genomes",
              mainPanel(
                  fluidRow(
                      column(4, wellPanel(checkboxGroupInput("checkPopulation",
                                                        label = h3("Population"),
                                                        choices = list("All" = 1, 
                                                                       "Wombles" = 2, 
                                                                       "Smurfs" = 3, 
                                                                       "Snorks" = 4),
                                                        inline = TRUE))),
                      column(8, br(),
                                p("'Be quiet, and do not weep,' answered the frog, 'I can help you, but what will you give me if I bring your
                                  plaything up again?'"),
                                br(),
                                p("'Whatever you will have, dear frog,' said she, 'My
                                  clothes, my pearls and jewels, and even the golden crown which I am
                                  wearing.'"))
                  ),
                  br(),
                  hr(),
                  br(),
                  fluidRow(
                      column(4, wellPanel(h4("Region", style="text-align: left;"),
                                          p("Example:  5:10458732-10458740"),
                                          hr(),
                                          textInput("textRegChr1KG", label = p("Chromosome (example: 5)")),
                                          textInput("textRegStart1KG", label = p("Start position (example: 10458732)")),
                                          textInput("textRegEnd1KG", label = p("End position (example: 10458740)"))))
                  ),
                  br(),
                  hr(),
                  br(),
                  fluidRow(
                      column(4, p("These are optional. Specify a SNP File if there are specific SNPs you would like to include.
                                  Additionally, you can specify a list of SNPs to include or exclude as required.", style="font-weight: normal;")),
                      column(4, wellPanel(shinyFilesButton("inputSNPFile1KG", 
                                                           label=h5("SNP File (optional)"), 
                                                           title="Please select an input SNP File",
                                                           multiple=FALSE),
                                          br(),
                                          hr(),
                                          br(),
                                          p("SNP File:  ", style="text-align: left;"),
                                          verbatimTextOutput("outSNPFile1KG"))),
                      column(4, wellPanel (textInput("textSNPInclude1KG", label=p("SNPs to include:")),
                                           textInput("textSNPExclude1KG", label=p("SNPs to exclude:"))))
                  ),
                  br(),
                  hr(),
                  br(),
                  fluidRow(
                      column(4, h4("Output Options", style="text-align: center;")),
                      column(8, h4("Proxy settings", style="text-align: center;"))
                  ),
                  br(),
                  br(),
                  fluidRow(
                      column(4, wellPanel(radioButtons("radioOutputFormat1KG",
                                                       label = NULL,
                                                       choices = list("Haploview" = 1, "Pairwise LD" = 2, "Find Proxy SNP" = 3)),
                                          hr(),
                                          textInput("textOutputFile1KG", label=p("Output File: (without file extension eg. MyOutputFile)")))),
                      column(4, textInput("textProxyWindow1KG", label=p("Window Size"))),
                      column(4, sliderInput("sliderProxySNP1KG", 
                                            label=p("Include LD greater than:"),
                                            min = 0, max = 1, value = 0.8, step=0.1))
                  ),
                  br(),
                  br(),
                  hr(),
                  br(),
                  fluidRow(
                      column(4, actionButton("actionBtn", "Calculate LD")),
                      column(8, wellPanel(verbatimTextOutput("outputGLOBALOPTIONS")))
                  ),
                  br(),
                  br()
              )
        ),
        tabPanel(
            "User Data",
            mainPanel(
                fluidRow(
                    column(4, wellPanel(shinyFilesButton("inputVCFFile", 
                                                         label=h5("VCF File Input"), 
                                                         title="Please select an input VCF File",
                                                         multiple=FALSE),
                                        br(),
                                        hr(),
                                        br(),
                                        p("VCF File:  ", style="text-align: left;"),
                                        verbatimTextOutput("outVCFFile"))),
                    
                    column(4, wellPanel(textInput("textSampleExcl", label = p("Exclude the following samples:  "))))
                ),
                br(),
                hr(),
                br(),
                fluidRow(
                    column(4, wellPanel(h4("Region", style="text-align: left;"),
                                        hr(),
                                        textInput("textRegChrUsr", label = p("Chromosome")),
                                        textInput("textRegStartUsr", label = p("Start position")),
                                        textInput("textRegEndUsr", label = p("End position"))))
                ),
                fluidRow(
                    column(4, p("These are optional. Specify a SNP File if there are specific SNPs you would like to include.
                                  Additionally, you can specify a list of SNPs to include or exclude as required.", style="font-weight: normal;")),
                    column(4, wellPanel(shinyFilesButton("inputSNPFileUsr", 
                                                         label=h5("SNP File (optional)"), 
                                                         title="Please select an input SNP File",
                                                         multiple=FALSE),
                                        br(),
                                        hr(),
                                        br(),
                                        p("SNP File:  ", style="text-align: left;"),
                                        verbatimTextOutput("outSNPFileUsr"))),
                    column(4, wellPanel (textInput("textSNPIncludeUsr", label=p("SNPs to include:")),
                                         textInput("textSNPExcludeUsr", label=p("SNPs to exclude:"))))
                ),
                br(),
                hr(),
                br(),
                fluidRow(
                    column(4, h4("Output Options", style="text-align: center;")),
                    column(8, h4("Proxy settings", style="text-align: center;"))
                ),
                br(),
                br(),
                fluidRow(
                    column(4, wellPanel(radioButtons("radioOutputFormatUsr",
                                                     label = NULL,
                                                     choices = list("Haploview" = 1, "Pairwise LD" = 2, "Find Proxy SNP" = 3)),
                                        hr(),
                                        textInput("textOutputFileUsr", label=p("Output File: (without file extension eg. MyOutputFile)")))),
                    column(4, textInput("textProxyWindowUsr", label=p("Window Size"))),
                    column(4, sliderInput("sliderProxySNPUsr", 
                                          label=p("Include LD greater than:"),
                                          min = 0, max = 1, value = 0.8))
                ),
                br(),
                br(),
                hr(),
                br(),
                fluidRow(
                    column(4, actionButton("actionBtnUsr", "Calculate LD")),
                    column(8, wellPanel(verbatimTextOutput("outputGLOBALOPTIONSUsr")))
                ),
                br(),
                br()
            )
        )
      
    )  # close fluidPage
)  # close shinyUI