#!/encs/bin/tcsh

# Navigate to the Jupyter directory
cd /speed-scratch/$USER/Jupyter || exit

# Load necessary modules
module load python/3.12.0/default
module load cuda/12.8/default

# Set temporary directories
# (For faster I/O to use /nobackup local disk space comment these out)
setenv TMPDIR /speed-scratch/$USER/tmp
setenv TMP /speed-scratch/$USER/tmp

# Keep shared pip packages on any node
setenv PIP_CACHE_DIR /speed-scratch/$USER/tmp/cache

# Activate the python virtual environment
source /speed-scratch/$USER/.jupyter-venv/bin/activate.csh

if ($status != 0) then
    echo "Failed to activate the python virtual environment"
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
python -m jupyterlab --no-browser --notebook-dir=$PWD --ip="0.0.0.0" --port=${port} --port-retries=50

# EOF
