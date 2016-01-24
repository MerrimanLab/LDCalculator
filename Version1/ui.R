##
## LD Calculation Interface
##
## This interface allows users to define the input parameters for
## James's LD Calculation script and dynamically builds the command string.
##
## Nick Burns
## Dec 2015
##

## UI.R
library(shiny)
library(shinyFiles)
setwd("~/Documents/GitHub/LDCalculator")


shinyUI(
  
    fluidPage(
      
        h1("LD Calculation",
           style = "font-family: 'Arial'; text-align: center;"),
        hr(),
        hr(),
        
        # File input widgets
        #     - inputVCFFile: user VCF file
        #     - inputSNPFile: text file conatining snp RSID to calclute LD for
        p(
            "Select an input file. Input files may be either a user-defined VCF file or,
            a text file containing a list of target SNPs."
        ),
        p(
            "Additionally, you can enter a list of SNPs to include / exclude as required (';' delimited)"
        ),
        br(),
        fluidRow(
          # InputVCFFile    option: -v
          column(4,
                 wellPanel (
                   shinyFilesButton("inputVCFFile", 
                                    label=h5("VCF File Input"), 
                                    title="Please select an input VCF File",
                                    multiple=FALSE),
                   br(),
                   hr(),
                   p("VCF File:", style="color:#888888;"),
                   verbatimTextOutput("outputVCFFile")
                 )
          ),
          # InputSNPFile    option: -s
          column(4, 
                 wellPanel (
                   shinyFilesButton("inputSNPFile", 
                                    label=h5("SNP File Input"), 
                                    title="Please select an input SNP File",
                                    multiple=FALSE),
                   br(),
                   hr(),
                   p("SNP File:", style="color:#888888;"),
                   verbatimTextOutput("outputSNPFile")
                 )
          ),
          # Individual SNPs    options: -r, -i
          column(4, 
                 wellPanel (
                   textInput("textSNPInclude", label=p("SNPs to include...")),
                   textInput("textSNPExclude", label=p("SNPs to exclude..."))
                 )
          )
        ),
        br(),
        hr(),
        br(),
        
        # Window of Calculation
        #     windowSNPs: the LD distance in number of SNPs
        #     windowKB:   the maximum distance (Kb) over which to calculate LD
        #     windowFreq: only show SNPs with LD greater than this
        fluidRow(
          # windowSNPs   option: -w
          column(4, sliderInput("sliderWindowSNPs", 
                               label=p("LD Distance in number of SNPs"),
                               min = 0, max = 100, value = 0)
          ),
          # windowKB    option: -l
          column(4, sliderInput("sliderWindowKB", 
                               label=p("Max distance (Kb) to calculate LD"),
                               min = 0, max = 1000, value = 200)
          ),
          # windowFreq    option: -r
          column(4, sliderInput("sliderWindowFreq", 
                               label=p("Only show SNPs with LD greater than:"),
                               min = 0, max = 1, value = 0)
          )
        ),
        br(),
        hr(),
        br(),
        
        # other options
        #     textHaploview: text input with the filename for haploview output.
        #     textPED:       text input with the filename for haploview output.
        #     checkMatrix:   Output data in a matrix
        #     textLogFile:   text input with the filename for log file
        fluidRow(
          # textHaploview   option: -h
          column(4, textInput("textHaploview", label=p("Haploview output:"))),
                 
          # textPED    option: -p
          column(4, textInput("textPED", label=p("PED file output:"))),
                 
          # checkMatrix    option: -m
          column(4, radioButtons("radioMatrix", 
                                  label=p("Output data to matrix"),
                                  choices = list("No" = 1, "Yes" = 2),
                                  selected = 1)
          )
        ),
        br(),
        hr(),
        br(),
        
        # Compile the command string.
        fluidRow(
          column(2),
          column(8, 
                 wellPanel( verbatimTextOutput("outputCommand")) ),
          column(2)
        )

    )
)