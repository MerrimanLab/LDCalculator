# LDCalculator

Shiny interface to explore patterns of LD. Visualisations include:  

  - a heatmap of all pairwise-LD between SNPs within a user-defined loci  
  - a dendrogram of the same  
  - a customised 'locus zoom-like' plot, which we call LDZoom.  
  
## Operating Instructions  

The Shiny app lives in the LDExplorer directory of this repo. After cloning this 
repo to your own system, you can begin exploring as follows:  

  1. Run the Shiny app (choose your favourite method)  
  2. On the **HOME page** enter the chromosome and region (start, end in base pairs)
  for your region of interest (loci). Click on **Calculate LD**.  
  3. Go to the **Ld Proximity** page. This will begin downloading the 1000 Genomes
  data for your loci, calculate the LD and display the heatmap and dendrogram.  
  4. After (3), you can then go to the **LDZoom** page. Enter a leadSNP, adjust the LD threshold (if required) 
  and click on **Visualise LD**. An LDZoom and summary table will be displayed.  
  
## Dependencies  

Obviously, you will need R and Shiny. In addition you will need the GLIDA package. GLIDA was developed to help
explore patterns of LD, and can be installed from GitHub using devtools:  

```r
library(devtools)
devtools::install_github("glida", "nickb-")
```

GLIDA has a number of dependecies, which should be automatically installed alongside GLIDA.

## Known Issues  

The LDExplorer app is being actively developed. We are working on fixes to the following:  

  ISSUE #1: Currently the "calculate LD" button on the HOME tab does not begin downloading and pre-processing of 1000 Genomes data. Users need to navigate to the LDProximity tab to begin this. Download should happen as soon as the user clicks on "Calculate LD".  
  
  ISSUE #2: Everytime the user restarts the app and enters the details for a loci, this region is downloaded from 1000 Genomes. There should be a check to see if the data already exists and if so, do not download again.  
  
  ISSUE #3: glida::ldPopulation() is throwing an unexpected EOF warning. This needs to be investigated, but is non-critical.  
  
## Contributions & Contacts  

The LDExplorer and GLIDA tools are actively maintained by the Merriman Lab at the University of Otago. We welcome feedback and contributions from users. Please contact nick.burns@otago.ac.nz.  

