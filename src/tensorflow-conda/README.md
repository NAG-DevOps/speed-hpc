# Tensorflow in Conda
Installation and configuration of a Conda environment for tensorflow with Cuda compatibility

## Instructions
* Conda environment creation, tensorflow and cuda packages installation

    * Connect to a node (salloc):
```bash
mkdir -p /speed-scratch/$USER/envs/{tmp,pkgs,cache}
setenv ENV_DIR /speed-scratch/$USER/envs
setenv CONDA_PKGS_DIRS /speed-scratch/$USER/envs/pkgs
conda create -y -p $ENV_DIR/conda-env python=3.10
conda activate $ENV_DIR/conda-env
conda install -c nvidia cuda-toolkit=12.5
conda install -c conda-forge tensorflow-gpu matplotlib numpy
```
* Modify according your needs (path, Environment_Name) the script `tf-speed.sh`
* In a submit node, run the script `tf-speed.sh`
```bash
sbatch -ppg tf-speed.sh
```
The `-p` parameter could have any of our GPU partitions: `pt`, `pg`, `pa`, `cl`, `em`, `pn`
        