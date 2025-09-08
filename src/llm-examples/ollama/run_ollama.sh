#!/encs/bin/tcsh

set ODIR = /speed-scratch/$USER/ollama
setenv PATH /speed-scratch/$USER/ollama/bin:$PATH
setenv OLLAMA_MODELS $ODIR/models
setenv OLLAMA_HOST "`cat $ODIR/.ollama_host`"

# Sanity check
ollama -v

# Pull a model
ollama pull llama3.2

# Create a python environment
setenv ENV_DIR /speed-scratch/$USER/envs/python-env
mkdir -p $ENV_DIR/{tmp,pkgs,cache}

setenv TMP $ENV_DIR/tmp
setenv TMPDIR $ENV_DIR/tmp
setenv PIP_CACHE_DIR $ENV_DIR/cache

python3 -m venv $ENV_DIR
source $ENV_DIR/bin/activate.csh
pip install -U pip ollama

python ollama_demo.py