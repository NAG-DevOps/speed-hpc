# Jupyter Lab on HPC Cluster

This folder contains scripts and instructions for setting up and running Jupyter Lab on the HPC cluster Speed using Conda without a container. These scripts are designed to simplify the process of allocating resources, setting up environments, and starting a Jupyter Lab process.

## Prerequisites

Before starting, ensure you have [access](https://nag-devops.github.io/speed-hpc/#requesting-access) to the HPC cluster.

## Instructions

### For first time use, we need to

* start an interactive session

        salloc --mem=20G --gpus=1

* load and initialize the environment 

        module load python/3.12.0/default
        # The default file is ~/.cshrc, use that if you don't have ~/.tcshrc configured
        source ~/.tcshrc

* run `setup-pyenv.sh` (on the compute node `salloc` brought you to, **not** on `speed-submit`)

        ./setup_pyenv.sh

    The script will do the following operations:
    - create a `/speed-scratch/$USER/Jupyter` directory (change Jupyter to any name of your choice in the script)
    - load Python 3.12 and cuda 12.8 modules
    - set environment variables for **TMP** directories and for **PIP_CACHE_DIR** 
    - create a python virtual environment named **.jupyter-venv** in the Jupyter directory
    - install JupyterLabs and pytorch
    - exit the interactive session

## Launching Jupyter Labs Instance

* Run the `start_jupyterlab.sh` script each time you need to launch JupyterLab from the submit node

        ./start_jupyterlab.sh

    The script will:
    - allocate resources for your job on a compute node
    - start jupyter server by running `run_jupyterlab.sh`
    - print the `ssh` command that you can use to connect to the compute node running the jupyter notebook (this is done in a new terminal)
    - print the token/link to the jupyter server to paste in a web browser (starting with `http://127.0.0.1/...`)

## References

* [More ways of running Jupyter notebooks are documented in our manual](https://nag-devops.github.io/speed-hpc/#jupyter-notebooks)
  * Using Python venv (like here)
  * Using Conda venv 
  * From containers
  