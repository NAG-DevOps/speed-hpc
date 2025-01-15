#!/encs/bin/tcsh

mkdir -p /speed-scratch/$USER/Jupyter

setenv TMPDIR /speed-scratch/$USER/tmp
setenv TMP /speed-scratch/$USER/tmp
setenv CONDA_PKGS_DIRS /speed-scratch/$USER/Jupyter/pkgs

module load anaconda3/2023.03/default

conda create -p /speed-scratch/$USER/Jupyter/jupyter-env -y
conda activate /speed-scratch/$USER/Jupyter/jupyter-env

conda install -c conda-forge jupyterlab -y

# pip3 install --quiet torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
pip3 install --quiet torch --index-url https://download.pytorch.org/whl/cu118

exit
