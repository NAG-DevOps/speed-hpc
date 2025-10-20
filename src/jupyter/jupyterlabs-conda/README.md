<!-- TOC --><a name="README"></a>
# Jupyter Lab on HPC Cluster

This folder contains scripts and instructions for setting up and running Jupyter Lab on the HPC cluster Speed using Conda without a container. These scripts are designed to simplify the process of allocating resources, setting up environments, and starting a Jupyter Lab process.

<!-- TOC --><a name="Prerequisites"></a>
## Prerequisites

Before starting, ensure you have [access](https://nag-devops.github.io/speed-hpc/#requesting-access) to the HPC cluster.

<!-- TOC --><a name="Instructions"></a>
## Instructions

### For first time use, we need to

* start an interactive session

        salloc --mem=20G --gpus=1

* load and initilize the environment 

        module load anaconda/2023.03/default
        conda init tcsh
        source ~/.tcshrc

* run `setup-conda.sh` (on the compute node `salloc` brought you to, **not** on `speed-submit`)

        ./setup_conda.sh

    The script will:
    - create a `/speed-scratch/$USER/Jupyter` directory (change Jupyter to any name of your choice in the script)
    - set environment variables for **TMP** directories and for **CONDA_PKGS_DIRS** 
    - create a conda environment named **jupyter-env**
    - install JupyterLabs and pytorch
    - exit the interactive session

## Launching Jupyter Labs Instance

* Run the `start_jupyterlab.sh` script each time you need to launch JupyterLab from the submit node

        ./start_jupyterlab.sh

    The script will:
    - allocate resources for your job on a compute node
    - start jupyter server by running `run_jupyterlab.sh`
    - print the ssh command that you can use to connect to the compute node runnung the jupyter notebook (this is done in a new terminal)
    - print the token/link to the jupyter server to paste in a web browser (starting with `http://127.0.0.1/...`)

## References
* [Speed Manual](https://nag-devops.github.io/speed-hpc/#jupyter-notebooks>
* More ways of running Jupyter notebook
  * Using Python venv [here](https://github.com/NAG-DevOps/speed-hpc/tree/master/src/jupyter/jupyterlabs-pyenv)
  * From containers

<!-- TOC end -->
