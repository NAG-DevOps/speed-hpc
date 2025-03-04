#!/encs/bin/tcsh

#SBATCH --job-name=poppler
#SBATCH --mail-type=ALL
#SBATCH --chdir=./
#SBATCH --nodes=1
#SBATCH --mem=4G

date
echo "======================================================================"

# Load Anaconda module and Python
module load anaconda3/2023.03/default
module load python/3.11.6/default

echo "Setting some initial vairables..."
set ENV_NAME = poppler_env
set ENV_DIR = /speed-scratch/$USER/envs
set ENV_PATH = $ENV_DIR/$ENV_NAME
set TMP_DIR = $ENV_DIR/tmp
set PKGS_DIR = $ENV_DIR/pkgs
set CACHE_DIR = $ENV_DIR/cache

mkdir -p $ENV_DIR $TMP_DIR $PKGS_DIR $CACHE_DIR

setenv TMP $TMP_DIR
setenv TMPDIR $TMP_DIR
setenv CONDA_PKGS_DIRS $PKGS_DIR
setenv PIP_CACHE_DIR $CACHE_DIR

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
	conda create -y -p "$ENV_PATH"

	echo "Activating Conda environment $ENV_NAME..."
	echo "======================================================================"
    conda activate "$ENV_PATH"
    if ($status != 0) then
        echo "Error: Failed to activate Conda environment."
        exit 1
	endif

	echo "Installing poppler package..."
	echo "======================================================================"
	conda install -c conda-forge poppler -y
	pip install pdf2image
endif

echo "Running Python code..."
echo "======================================================================"
python pdf-to-jpg.py

# Deactivate Conda env
echo "Deactivating Conda environment..."
conda deactivate

echo "================================ DONE ================================"
date
exit
