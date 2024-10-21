#!/encs/bin/tcsh

#SBATCH --job-name=multi-mig-test
#SBATCH --output=%j-%N-out.txt
#SBATCH --error=%j-%N-err.txt
#SBATCH --partition=pt
#SBATCH --ntasks=9
#SBATCH --mail-type=all
##SBATCH --mem-per-cpu=4G
#SBATCH --gres=gpu:nvidia_a100_2g.20gb:2

cd /speed-scratch/carlos/gputest/gpu-burn
set pids = ()
foreach i ( `echo $CUDA_VISIBLE_DEVICES | tr ',' ' '` )
    setenv OMP_NUM_THREADS 4
    setenv CUDA_VISIBLE_DEVICES $i
    ./gpu_burn -d 60 &
    set pids = ( $pids $! )
end

sleep 20
nvidia-smi

# wait for all pids
set all_done = 0  
while (! $all_done)  
    set all_done = 1  
    foreach pid ($pids)
        if ( -e /proc/$pid ) then  
            set all_done = 0  
        endif
    end
    sleep 1
end
