#!/encs/bin/tcsh

# Navigate to the Jupyter directory
cd /speed-scratch/$USER/Jupyter || exit

# Load Anaconda module if not already loaded
if (! $?CONDA_PREFIX) then
    module load anaconda3/2023.03/default
endif

# Set temporary directories for faster I/O
setenv TMPDIR /speed-scratch/$USER/tmp
setenv TMP /speed-scratch/$USER/tmp
setenv CONDA_PKGS_DIRS /speed-scratch/$USER/Jupyter/pkgs

# Activate the Conda environment
conda activate /speed-scratch/$USER/Jupyter/jupyter-env
if ($status != 0) then
    echo "Failed to activate the conda environment"
    exit 1
endif

# Get the current node and user information
set node = `hostname -s`
set user = `whoami`

# Get an available port for Jupyter
set port = `python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()'`


# Print SSH tunneling instructions
echo "To connect to the compute node ${node} on speed.encs.concordia.ca running your Jupyter notebook server, \n\
use the following SSH command in a new terminal on your workstation/laptop:\n\n\
ssh -L ${port}:${node}:${port} ${user}@speed.encs.concordia.ca\n\n\
Then, copy the URL provided below by the Jupyter server (starting with http://127.0.0.1/...) and paste it into your browser.\n\n\
Remember to close any open notebooks and shut down the Jupyter client in your browser before exiting to avoid manual job cancellation."


# Start the Jupyter server in the background
echo "Starting Jupyter server in background with requested resources"
jupyter lab --no-browser --notebook-dir=$PWD --ip="0.0.0.0" --port=${port} --port-retries=50


