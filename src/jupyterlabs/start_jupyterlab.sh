# Start either a part of interactive or batch sesions
# Hardcoded assumption: /speed-scratch/$USER/speed-hpc/src/jupyterlabs
srun --mem=16G --gpus=1 -p pt --mail-type=ALL /speed-scratch/$USER/speed-hpc/src/jupyterlabs/run_jupyterlab.sh
