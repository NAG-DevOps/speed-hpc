#!/encs/bin/tcsh

echo "Setting some initial vairables..."
date

set JUPYTER_DATA_DIR = /speed-scratch/$USER/Jupyter

mkdir -p $JUPYTER_DATA_DIR

# Set these if want to share
setenv TMPDIR /speed-scratch/$USER/tmp
setenv TMP /speed-scratch/$USER/tmp

setenv CONDA_PKGS_DIRS $JUPYTER_DATA_DIR/pkgs

echo "Setting conda env..."
date

module load anaconda3/2023.03/default

conda create -p $JUPYTER_DATA_DIR/jupyter-env -y
conda activate $JUPYTER_DATA_DIR/jupyter-env

conda install -c conda-forge jupyterlab -y

echo "Installing initial Python packages..."
date

# pip3 install --quiet torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
pip3 install --quiet torch --index-url https://download.pytorch.org/whl/cu118

echo "Peparin some notebooks..."
date

# Get some initial notebooks up
cp ../*.ipynb $JUPYTER_DATA_DIR
wget --directory-prefix=$JUPYTER_DATA_DIR \
  https://raw.githubusercontent.com/NAG-DevOps/formation_cpu-gpu/refs/heads/master/GPU_Workshop.ipynb

echo "Done."
date

# EOF
