# Start either a part of interactive or batch sesions
# Hardcoded assumptions to adjust as necessary:
#  path:          /speed-scratch/$USER/speed-hpc/src/jupyter/jupyterlabs-conda
#  memory:        16GB
#  GPUs:          1
#  partition:     pt
#  CPUs:          8
#  notifications: ALL
# If calling from sbatch, make sure these don't exceed those from sbatch
srun \
  --mem=16G --gpus=1 -p pt -c 8 --mail-type=ALL \
  /speed-scratch/$USER/speed-hpc/src/jupyter/jupyterlabs-conda/run_jupyterlab.sh
