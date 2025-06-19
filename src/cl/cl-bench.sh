#!/encs/bin/tcsh

#SBATCH -J cl-bench
#SBATCH -A root
#SBATCH --mem=50G
#SBATCH -p cl
#SBATCH -n 1
#SBATCH -c 8
#SBATCH -w speed-19
#SBATCH --mail-type=ALL
#SBATCH --mail-user=serguei
## SBATCH --gpus=amdgpu:1
## SBATCH --gres=gpu:amdgpu:1
#SBATCH --constraint=amdgpu

echo "cl-bench START"

date
time srun /speed-scratch/serguei/cl/amd-gpu-benchmark/cl-info
date
time srun /speed-scratch/serguei/cl/amd-gpu-benchmark/main
#srun strace /speed-scratch/serguei/cl/amd-gpu-benchmark/main
#strace /speed-scratch/serguei/cl/amd-gpu-benchmark/main
date
time srun /speed-scratch/serguei/cl/amd-gpu-benchmark/main-cpu
date


echo "cl-bench DONE"
