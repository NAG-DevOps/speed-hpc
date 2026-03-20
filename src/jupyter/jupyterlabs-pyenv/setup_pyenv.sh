#!/encs/bin/tcsh

# Prevent running on submit nodes
if ( `hostname -s` =~ *submit* ) then
    echo "String 'submit' found in hostname. This script should be run in srun or salloc. Exiting."
    exit 1
endif

echo "Setting some initial variables..."
date

set JUPYTER_DATA_DIR = /speed-scratch/$USER/Jupyter

mkdir -p $JUPYTER_DATA_DIR

# Set these if want to share
setenv TMPDIR /speed-scratch/$USER/tmp
setenv TMP /speed-scratch/$USER/tmp

setenv PIP_CACHE_DIR /speed-scratch/$USER/tmp/cache

echo "Setting python env..."
date

module load python/3.12.0/default
module load cuda/12.8/default

python -m venv /speed-scratch/$USER/.jupyter-venv

source /speed-scratch/$USER/.jupyter-venv/bin/activate.csh

echo "Installing jupyterlab..."
date

pip install jupyterlab

echo "Installing initial Python packages..."
date

# locking to cuda 12.8 for compatibility with loaded cuda module
pip3 install torch torchvision --index-url https://download.pytorch.org/whl/cu128
pip3 install transformers

echo "Preparing some notebooks..."
date

# Get some initial notebooks up
cp -f ../*.ipynb $JUPYTER_DATA_DIR

git clone --depth=1 https://github.com/NAG-DevOps/formation_cpu-gpu
cd formation_cpu-gpu
  mv -f GPU_Workshop.ipynb images get_cifar10.sh "$JUPYTER_DATA_DIR/"
  cd ..
rm -rf formation_cpu-gpu

echo "Done."
date

# EOF
