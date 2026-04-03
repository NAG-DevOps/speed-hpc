#!/encs/bin/tcsh

#SBATCH --job-name=ollama-client
#SBATCH --mem=4G
#SBATCH --partition=pg
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mail-type=ALL
#SBATCH --output=ollama-%J.out

# Load required modules
module load python/3.12.0/default

# Setup Ollama environment variables
set ODIR = /speed-scratch/$USER/ollama
setenv OLLAMA_MODELS $ODIR/models
setenv OLLAMA_HOST `cat $ODIR/.ollama_host`
setenv PATH $ODIR/bin:$PATH

# Sanity check
echo "============================================================"
ollama -v
echo "ollama server is configured at `cat $ODIR/.ollama_host`"

# Pull a model
echo "============================================================"
echo "Pulling llama3 model:"
ollama pull llama3

# Create a python environment
echo "============================================================"
# Setup Python environment variables
set ENV_NAME = "python_env"
set ENV_HOME_DIR = "/speed-scratch/$USER/envs/ollama"
set ENV_PATH = "$ENV_HOME_DIR/$ENV_NAME"

mkdir -p $ENV_HOME_DIR/{tmp,pkgs,cache}

setenv TMP $ENV_HOME_DIR/tmp
setenv TMPDIR $ENV_HOME_DIR/tmp
setenv PIP_CACHE_DIR $ENV_HOME_DIR/cache

# Check if the environment already exists
if ( -d "$ENV_PATH" ) then
    echo "$ENV_NAME already exists at $ENV_HOME_DIR. Activating it..."    
    source $ENV_PATH/bin/activate.csh

    if ($status != 0) then
        echo "Error: Failed to activate the environment."
        exit 1
    endif
else
    echo "Creating $ENV_NAME environment at $ENV_HOME_DIR..."
    python -m venv $ENV_PATH
    
    echo "Activating $ENV_NAME..."
    source $ENV_PATH/bin/activate.csh

    if ($status != 0) then
        echo "Error: Failed to activate the environment."
        exit 1
    endif
    
    # Install required packages
    pip install --upgrade pip
    pip install ollama
endif

echo "============================================================"
echo "Running ollama_demo.py..."

python ollama_demo.py

echo "Deactivating the environment..."
deactivate
echo "========================= DONE ============================="
