<!-- TOC --><a name="README"></a>
# Tensorflow in Conda

Installation and configuration of a Conda environment for tensorflow with Cuda compatibility

<!-- TOC --><a name="Instructions"></a>
## Instructions
* Conda environment creation, tensorflow and cuda packages installation
    * Connect to a node (salloc):
        setenv CONDA_ENVS_PATH /speed-scratch/$USER/condas
        setenv CONDA_PKGS_DIRS /speed-scratch/$USER/condas/pkg
        conda create -n <Environment_Name> python=3.10
        conda activate <Environment_Name>
        conda install -c nvidia cuda-toolkit=12.5
        conda install -c conda-forge tensorflow-gpu matplotlib numpy

* Modify according your needs (path, Environment_Name) the script `tf-speed.sh`
* In a submit node, run the script `tf-speed.sh`
        sbatch -ppg tf-speed.sh
    -p parameter could have any of our GPU partitions: pt,pg,pa,cl,em,pn
        
<!-- TOC end -->