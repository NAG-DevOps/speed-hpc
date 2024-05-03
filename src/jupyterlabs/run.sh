cd /speed-scratch/$USER/Jupyter
module load anaconda3/2023.03/default
setenv TMPDIR /speed-scratch/$USER/tmp
setenv TMP /speed-scratch/$USER/tmp
setenv CONDA_PKGS_DIRS /speed-scratch/$USER/Jupyter/pkgs
conda activate /speed-scratch/$USER/Jupyter/jupyter-env
jupyter lab --no-browser --notebook-dir=$PWD --ip="0.0.0.0" --port=8888 --port-retries=50

