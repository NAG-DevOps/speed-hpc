#!/encs/bin/tcsh

date
echo "==================================="

# Load required modules
module load anaconda/2023.03/default

# Define environment variables
#set ENV_NAME = "llm_env"
set ENV_DIR = "/speed-scratch/$USER/envs"
#set ENV_PATH = "$ENV_DIR/$ENV_NAME"
set ENV_PATH = "/speed-scratch/f_salha/Jupyter/jupyter-env"

mkdir -p $ENV_DIR/{tmp,pkgs,huggingface,cache}

setenv TMP $ENV_DIR/tmp
setenv TMPDIR $ENV_DIR/tmp
setenv CONDA_PKGS_DIRS $ENV_DIR/pkgs
setenv PIP_CACHE_DIR $ENV_DIR/cache
setenv HF_HOME $ENV_DIR/huggingface
setenv HF_HUB_CACHE $ENV_DIR/cache

#echo "Creating Conda environment $ENV_NAME at $ENV_PATH..."
#conda create -p "$ENV_PATH" python=3.11 -y
	
echo "Activating environment..."
conda activate "$ENV_PATH"
	
if ($status != 0) then
    echo "Failed to activate Conda environment."
    exit 1
endif

#pip install torch transformers
	
echo "==================================="
date

echo ""
echo "Running BERT example"
python bert_demo.py

# Deactivate environment
conda deactivate

echo "Done."
# EOF
