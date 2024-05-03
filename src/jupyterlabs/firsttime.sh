mkdir -p /speed-scratch/$USER/Jupyter
module load anaconda3/2023.03/default
setenv TMPDIR /speed-scratch/$USER/tmp
setenv TMP /speed-scratch/$USER/tmp
setenv CONDA_PKGS_DIRS /speed-scratch/$USER/Jupyter/pkgs
conda create -p /speed-scratch/$USER/Jupyter/jupyter-env
conda activate /speed-scratch/$USER/Jupyter/jupyter-env
conda install -c conda-forge jupyterlab
pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
