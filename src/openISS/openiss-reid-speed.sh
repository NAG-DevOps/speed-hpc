#!/encs/bin/tcsh

#SBATCH --job-name openiss-reid
#SBATCH --mail-type=ALL                 ## Receive all email type notifications
#SBATCH --chdir=./                      ## Use currect directory as working directory (default) 
#SBATCH -o openiss-reid-output-%A.log   ## Specify output file name

##
## Request Resources
##

#SBATCH --mem=20G
##SBATCH -c 32      ## Uncomment this line if the job needs CPUs and comment the GPU request section below
#SBATCH --gpus=1

# Load required modules
module load anaconda3/2023.03/default

# Define environment variables
set ENV_DIR = /speed-scratch/$USER/reid-venv
mkdir -p $ENV_DIR/{tmp,pkgs,cache}

setenv TMP $ENV_DIR/tmp
setenv TMPDIR $ENV_DIR/tmp
setenv CONDA_PKGS_DIRS $ENV_DIR/pkgs
setenv PIP_CACHE_DIR $ENV_DIR/cache

echo "Creating Conda environment at $ENV_DIR..."
echo "===================================================="
conda env create -f environment.yml -p $ENV_DIR >& conda-create.log

conda activate $ENV_DIR

date

echo "Running reid.py..."
echo "=================="
srun python reid.py

date

conda deactivate
