#!/encs/bin/bash

#SBATCH --job-name=multi-mig-test
#SBATCH --output=%j-%N-out.txt
#SBATCH --error=%j-%N-err.txt
#SBATCH --partition=pt
#SBATCH --ntasks=9
#SBATCH --mail-type=all
##SBATCH --mem-per-cpu=4G
#SBATCH --gres=gpu:nvidia_a100_2g.20gb:2

# module load python/3.9.9-jh
. /encs/pkg/modules-3.2.10/root/Modules/3.2.10/init/bash

cd /speed-scratch/carlos/gputest/gpu-burn
j=0
for i in $(echo $CUDA_VISIBLE_DEVICES | tr ',' ' '); do
    OMP_NUM_THREADS=4 CUDA_VISIBLE_DEVICES=${i} ./gpu_burn -d 60 &
    pids[${j}]=$!
    j=$((j+1))
done

sleep 20
nvidia-smi

# wait for all pids
for pid in ${pids[*]}; do
    wait $pid
done
