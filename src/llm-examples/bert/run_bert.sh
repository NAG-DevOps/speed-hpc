[speed-submit2] [/speed-scratch/f_salha/projects/bert] > cat run_bert.sh 
#!/encs/bin/tcsh

#SBATCH --job-name=bert
#SBATCH --mail-type=ALL
#SBATCH --chdir=./
#SBATCH --output=bert-%J.out

## Request Resources
#SBATCH --mem=10G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --gpus=1

# Load required modules
module load anaconda/2023.03/default

# Define environment variables
set ENV_NAME = "bert_env"
set ENV_HOME_DIR = "/speed-scratch/$USER/envs/bert"
set ENV_PATH = "$ENV_HOME_DIR/$ENV_NAME"

mkdir -p $ENV_HOME_DIR/{tmp,pkgs,huggingface,cache}

setenv TMP $ENV_HOME_DIR/tmp
setenv TMPDIR $ENV_HOME_DIR/tmp
setenv CONDA_PKGS_DIRS $ENV_HOME_DIR/pkgs
setenv PIP_CACHE_DIR $ENV_HOME_DIR/cache
setenv HF_HOME $ENV_HOME_DIR/huggingface
setenv HF_HUB_CACHE $ENV_HOME_DIR/cache

# Check if the environment already exists
if ( -d "$ENV_PATH" ) then
    echo "Environment $ENV_NAME already exists at $ENV_HOME_DIR. Activating it..."
    echo "======================================================================"
    conda activate "$ENV_PATH"
    if ($status != 0) then
        echo "Error: Failed to activate Conda environment."
        exit 1
    endif
else
    echo "Creating Conda environment $ENV_NAME at $ENV_HOME_DIR..."
    echo "======================================================================"
    conda create -p "$ENV_PATH" -y python=3.12

    echo "Activating Conda environment $ENV_NAME..."
    conda activate "$ENV_PATH"
	
    if ($status != 0) then
        echo "Error: Failed to activate Conda environment."
        exit 1
    endif

    pip install --upgrade pip
    pip install torch transformers
endif

date
echo "======================================================================"
echo "Running bert_demo.py..."
python bert_demo.py

echo "======================================================================"
date

# Deactivate Conda env
echo "Deactivating Conda environment..."
conda deactivate
echo "================================ DONE ================================"