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
set ENV_NAME = reid-env
set ENV_DIR = /speed-scratch/$USER/envs
set ENV_PATH = $ENV_DIR/$ENV_NAME

mkdir -p $ENV_DIR/{tmp,pkgs,cache}

setenv TMP $ENV_DIR/tmp
setenv TMPDIR $ENV_DIR/tmp
setenv CONDA_PKGS_DIRS $ENV_DIR/pkgs
setenv PIP_CACHE_DIR $ENV_DIR/cache

# Check if the environment already exists
if ( -d "$ENV_PATH" ) then
    echo "Environment $ENV_NAME already exists at $ENV_PATH. Activating it..."
    echo "======================================================================"
    conda activate "$ENV_PATH"
    if ($status != 0) then
        echo "Error: Failed to activate Conda environment."
        exit 1
	endif
else
    echo "Creating Conda environment $ENV_NAME at $ENV_PATH..."
    echo "======================================================================"
    conda env create -f environment.yml -p $ENV_PATH |& tee conda-create.log

    echo "Activating Conda environment $ENV_NAME..."
	echo "======================================================================"
    conda activate "$ENV_PATH"
    if ($status != 0) then
        echo "Error: Failed to activate Conda environment."
        exit 1
    endif            
endif

date
echo "======================================================================"

echo "Running reid.py..."
srun python reid.py

echo "======================================================================"
date

echo "================================ DONE ================================"
echo "Deactivating Conda environment..."
conda deactivate