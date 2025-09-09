#!/encs/bin/tcsh

#SBATCH --job-name=ollama-client
#SBATCH --mem=50G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mail-type=ALL
#SBATCH --output=ollama-%J.out

set ODIR = /speed-scratch/$USER/ollama
setenv PATH /speed-scratch/$USER/ollama/bin:$PATH
setenv OLLAMA_MODELS $ODIR/models
setenv OLLAMA_HOST `cat /speed-scratch/$USER/ollama/.ollama_host`

# Sanity check
ollama -v

# Pull a model
ollama pull llama3.2

# Create a python environment
setenv ENV_DIR /speed-scratch/$USER/envs/python-env

if ( ! -d $ENV_DIR ) then
    echo "Creating python environment..."
    mkdir -p $ENV_DIR/{tmp,pkgs,cache}

    setenv TMP $ENV_DIR/tmp
    setenv TMPDIR $ENV_DIR/tmp
    setenv PIP_CACHE_DIR $ENV_DIR/cache

    python3 -m venv $ENV_DIR
else
    echo "Python environment already exists."
endif

source $ENV_DIR/bin/activate.csh
pip install -U pip ollama

python ollama_demo.py
