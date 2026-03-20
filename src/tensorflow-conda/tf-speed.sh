#!/encs/bin/tcsh

#SBATCH --nodes=1
#SBATCH --mem=10G
#SBATCH --gpus=1

set ENV_NAME = conda-env
set ENV_DIR = /speed-scratch/$USER/envs
set ENV_PATH = $ENV_DIR/$ENV_NAME 
setenv CONDA_PKGS_DIRS $ENV_DIR/pkgs 
# activate the environment created before
conda activate $ENV_PATH
# Directory where the script is located
srun python $PWD/tf-stress.py
conda deactivate