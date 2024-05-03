<!-- TOC --><a name="README"></a>
# README

This directory has example scripts to run Jupyter Labs+conda+python without containers

<!-- TOC --><a name="Preparation"></a>
## Preparation
After opening an interactive session (salloc)

Run the script `firsttime.sh`, ONLY 1 time, it will
- Create a /speed-scratch/$USER/Jupyter directory: change Jupyter to any name of your choice
- Set environment variables for tmp directories and for CONDA_PKGS_DIRS 
- Create a conda environmen named: jupyter-env (change it to any name of your choice)
- Install JupyterLabs + pytorch
- exit the interactive session

## Execution
After opening an interactive session (salloc)

Run the script `run.sh`, everytime you want to execute jupyterlabs

## Browsing
After Execution, create an ssh tunnel (read https://nag-devops.github.io/speed-hpc/#jupyter-notebooks-in-singularity)

Open a browser: http://localhost:XXXX/lab?token=XXXXXXXXXX

## REMINDER
Don't forget to setup the 2 scripts with the parameters of your choice
Jupyter: directory, jupiter-env: environment name

<!-- TOC end -->