<!-- TOC --><a name="README"></a>
# Poppler on HPC (Speed) Cluster

Poppler is an open-source PDF rendering library that provides tools and utilities for working with PDF documents. It is used in many projects for converting, manipulating, and rendering PDFs.

<!-- TOC --><a name="Prerequisites"></a>
## Prerequisites

Before starting, ensure you have [access](https://nag-devops.github.io/speed-hpc/#requesting-access) to the HPC (Speed) cluster.

<!-- TOC --><a name="Instructions"></a>
## Instructions
* Clone the Github repository

        git clone --depth=1 https://github.com/NAG-DevOps/speed-hpc.git

* Navigate to the poppler directory in `src`
* Run `poppler.sh`

        sbatch poppler.sh

    The script will:
    - Load Anaconda and Python modules.
    - Set up enviromnent variables so all the packages and cache files are stored on `/speed-scratch`
    - Create Conda environment if it does not exist otherwise it skips the creation process.
    - Activate the environment and install the required packages such as poppler, poppler-utils, and pdf2image
    - Run python file `pdf-to-jpg.py`

`pdf-to-jpg.py`
imports all the required modules, finds the specified pdf to convert, and saves the pdf pages as JPEG files into output folder in the same directory.

**Note**: replace speed-workshop.pdf with a pdf of your choice, and update the variable `pdf_file = "speed-workshop.pdf"` with the name of your file.

<!-- TOC end -->