#!/encs/bin/tcsh
#SBATCH --job-name=pytorch_multinode_multigpu_train

#SBATCH --nodes=2
#SBATCH --gpus-per-node=1 #On P6 cards this value MUST be: 1
#SBATCH --cpus-per-task=8
#SBATCH --ntasks-per-node=1
#SBATCH --mem=128G             ## Assign memory per node

if ( $?SLURM_CPUS_PER_TASK ) then
   setenv omp_threads $SLURM_CPUS_PER_TASK
else
   setenv omp_threads 1
endif
setenv OMP_NUM_THREADS $omp_threads

setenv RDZV_HOST `hostname -s`
setenv RDZV_PORT 29400
setenv endpoint ${RDZV_HOST}:${RDZV_PORT}
setenv CUDA_LAUNCH_BLOCKING 1
setenv NCCL_BLOCKING_WAIT 1
#setenv NCCL_DEBUG INFO
setenv NCCL_P2P_DISABLE 1
setenv NCCL_IB_DISABLE 1
source /speed-scratch/$USER/tmp/Venv-Name/bin/activate.csh #path where you have created your python venv
unsetenv CUDA_VISIBLE_DEVICES
# nproc_per_node=1 On P6 cards
srun torchrun --nnodes=$SLURM_JOB_NUM_NODES --nproc_per_node=1 --rdzv_id=$SLURM_JOB_ID --rdzv_backend=c10d --rdzv_endpoint=$endpoint main_multinode.py
deactivate
