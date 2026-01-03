# RSAdb — Single-cell omics big data platform for recurrent spontaneous abortion

RSAdb is a comprehensive open-access resource for investigating transcriptomic alterations associated with gene expression patterns within single-cell omics datasets at the maternal-fetal interface in human recurrent spontaneous abortion (RSA).

## Overview

The database comprises 73,025 cells and 25,858 genes spanning 28 distinct cell types derived from the maternal-fetal interface of both normal pregnancy (NP) and recurrent spontaneous abortion (RSA), generated through unified standardized data analysis workflows with systematic cell type annotation protocols.

## Features

- Interactive exploration of 25,858 genes across 32 distinct cellular subpopulations
- Publication-ready visualizations including:
  - Dimensionality reduction (DimPlot)
  - Differentiation trajectory (AlluvialPlot)
  - Cellular preference mapping (GroupPreferencePlot)
  - Expression distribution (VlnPlot)
  - Spatial localization (FeaturePlot/DensityPlot)
- Flexible gene set scoring on 5,809 curated datasets
- Reproducible results with one-click access to datasets

## Installation

### Prerequisites
- R 4.5.0 or higher
- Required R packages:
  - shiny
  - htmltools
  - htmlwidgets
  - base64enc
  - Seurat
  - tidyverse
  - qs
  - gridExtra
  - ggpubr
  - ggplot2
  - reshape2
  - Nebulosa
  - DT

### Install Dependencies

```R
install.packages(c("shiny", "htmltools", "htmlwidgets", "base64enc", "Seurat", "tidyverse", "qs", "gridExtra", "ggpubr", "ggplot2", "reshape2", "Nebulosa", "DT"))
```

## Running the Application

```R
library(shiny)
runApp("app.R", host="0.0.0.0", port=3838)
```

The application will be available at `http://localhost:3838`

## Deployment Options

### Option 1: Shinyapps.io

1. Install the `rsconnect` package:
   ```R
   install.packages("rsconnect")
   ```

2. Connect to your Shinyapps.io account:
   ```R
   rsconnect::setAccountInfo(name='your-account', token='your-token', secret='your-secret')
   ```

3. Deploy the app:
   ```R
   rsconnect::deployApp("app.R")
   ```

### Option 2: Docker

Create a Dockerfile:

```dockerfile
FROM r-base:4.5.2

RUN apt-get update && apt-get install -y \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    libpng-dev \
    libjpeg-dev \
    libgif-dev \
    && rm -rf /var/lib/apt/lists/*

RUN R -e "install.packages(c('shiny', 'htmltools', 'htmlwidgets', 'base64enc', 'Seurat', 'tidyverse', 'qs', 'gridExtra', 'ggpubr', 'ggplot2', 'reshape2', 'Nebulosa', 'DT'))"

COPY . /app
WORKDIR /app

EXPOSE 3838

CMD ["Rscript", "-e", "library(shiny); runApp('app.R', host='0.0.0.0', port=3838)"]
```

### Option 3: GitHub Pages (Static Version)

For a static version of the documentation, you can build and deploy to GitHub Pages.

## Project Structure

```
.
├── app.R              # Main Shiny application file
├── input.data.qs      # Single-cell data file (not included in repo due to size)
├── group.png          # Group visualization
├── percentage.png     # Percentage visualization
├── t-SNE.png          # t-SNE visualization
├── voilin.png         # Violin plot visualization
├── .gitignore         # Git ignore file
└── README.md          # This file
```

## Usage

1. Navigate to the application URL
2. Use the "Query" tab to search for genes of interest
3. Enter a gene name and click "Update Plots"
4. Explore the different visualization tabs:
   - Violin Plot
   - Feature Plot
   - Density Plot
   - Expression Binary

## Data Source

The single-cell RNA-seq data was collected from the maternal-fetal interface of both normal pregnancy (NP) and recurrent spontaneous abortion (RSA) samples. The data was processed using Seurat and normalized with standardized workflows.

## Citation

If you use this database in your research, please cite our publication (in preparation).

## License

© 2025 RSAdb — Single-cell omics big data platform for recurrent spontaneous abortion. All rights reserved.

## Contact

For questions or feedback, please contact the development team.
