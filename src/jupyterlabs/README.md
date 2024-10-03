<!-- TOC --><a name="README"></a>
# Jupyter Lab on HPC Cluster

This folder contains scripts and instructions for setting up and running Jupyter Lab on the HPC cluster using Conda without container. These scripts are designed to simplify the process of allocating resources, setting up environments, and starting Jupyter Lab.

<!-- TOC --><a name="Prerequisites"></a>
## Prerequisites
Before starting, ensure you have access to the HPC cluster.

<!-- TOC --><a name="Instructions"></a>
## Instructions
### For first time use, we need to

* start an interactive session

        salloc --mem=20G --gpus=1

* load and initilize the environment 

        module load anaconda/2023.03/default
        conda init tcsh
        source ~/.tcshrc

* run `setup-conda.sh`

        ./setup-conda.sh

    The script will:
    - create a `/speed-scratch/$USER/Jupyter` directory (change Jupyter to any name of your choice)
    - set environment variables for **TMP** directories and for **CONDA_PKGS_DIRS** 
    - create a conda environment named **jupyter-env**
    - install JupyterLabs and pytorch
    - exit the interactive session

## Launching Jupeter
* Run the `start_jupyterlab.sh` script each time you need to launch Jupyterlab

        ./start_jupyterlab.sh

    The script will:
    - allocate resources for your job
    - start jupyter server by running `run_jupyterlab.sh`
    - print the ssh command that you can use to connect to the compute node runnung the jupyter notebook (this is done in a new terminal)
    - print the token/link to the jupyter server to paste in a web browser (starting with `http://127.0.0.1/...`)

<!-- TOC end -->