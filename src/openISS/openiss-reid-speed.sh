#!/encs/bin/tcsh

# Job name
#SBATCH --job-name openiss-reid

# Recieve email notifications when the job starts, finishes or fails.
#SBATCH --mail-type=ALL

# Set output directory to current
#SBATCH --chdir=./

# Specify the output file name
#SBATCH -o openiss-reid-output-%A.log

# Request Memory
#SBATCH --mem=20G

# Request CPU - comment this section if the job needs GPUs 
##SBATCH -c 32

# Request GPU - comment this section if the job needs CPUs and uncomment the previous section
#SBATCH --gpus=1

# Execute the script
module load anaconda3/2023.03/default

# Define the environment directory
set ENV_DIR = /speed-scratch/$USER/reid-venv
mkdir -p $ENV_DIR/{tmp,pkgs,cache}

setenv TMPDIR $ENV_DIR/tmp
setenv TMP $ENV_DIR/tmp
setenv CONDA_PKGS_DIRS $ENV_DIR/pkgs
setenv PIP_CACHE_DIR $ENV_DIR/cache

conda env create -f environment.yml -p $ENV_DIR >& conda-create.log
conda activate $ENV_DIR

date
srun python reid.py
date

conda deactivate
