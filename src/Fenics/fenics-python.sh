#!/encs/bin/bash
#SBATCH --job-name=poisson_fenics        # Job name
#SBATCH --output=poisson_%j.out          # Standard output (%j = job ID)
#SBATCH --error=poisson_%j.err           # Standard error
#SBATCH --mail-type=ALL                  # Email sent to user
#SBATCH --time=24:00:00                  # Wall time limit (HH:MM:SS)
#SBATCH --nodes=1                        # Number of nodes (increase for multi-node)
#SBATCH --ntasks=4                       # Total MPI processes
#SBATCH --ntasks-per-node=4             # MPI processes per node (ntasks / nodes)
#SBATCH --cpus-per-task=1               # CPUs per MPI process
#SBATCH --mem=8G                        # Memory per node
#SBATCH --constraint="avx2|avx512|AMD"  # Exclude AVX-only Sandy Bridge nodes

. /encs/pkg/modules-5.3.1/root/init/bash

# ── Load EB-FEniCSx module ───────────────────────────────────────────────────────
module purge
module load GCC/14.3.0 2>&1
module load OpenMPI/5.0.8 2>&1
module load FEniCS-DOLFINx-Python/0.10.0.post5 2>&1

# ── Print job info ────────────────────────────────────────────────────────────
echo "Job ID:       $SLURM_JOB_ID"
echo "Nodes:        $SLURM_NODELIST"
echo "Num nodes:    $SLURM_NNODES"
echo "MPI tasks:    $SLURM_NTASKS"
echo "Start time:   $(date)"
echo "Working dir:  $SLURM_SUBMIT_DIR"

# ── Environment ───────────────────────────────────────────────────────────────
# Disable HDF5 file locking (required on NFS filesystems)
export HDF5_USE_FILE_LOCKING=FALSE

# ── Run ───────────────────────────────────────────────────────────────────────
cd $SLURM_SUBMIT_DIR
srun --mpi=pmix python3 poisson_dolfinx.py

echo "End time: $(date)"

# ──────────────────────────────────────────────────────────────────────────────
# Multi-node examples:
#
# 2 nodes, 8 total MPI processes (4 per node):
#   #SBATCH --nodes=2
#   #SBATCH --ntasks=8
#   #SBATCH --ntasks-per-node=4
#
# 4 nodes, 16 total MPI processes (4 per node):
#   #SBATCH --nodes=4
#   #SBATCH --ntasks=16
#   #SBATCH --ntasks-per-node=4
#
# Submit with: sbatch run_poisson.sh
# Monitor with: squeue -u $USER
# Output: poisson_<jobid>.out
# ──────────────────────────────────────────────────────────────────────────────
