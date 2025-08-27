#!/encs/bin/tcsh

#SBATCH --nodes=1
#SBATCH --mem=10G
#SBATCH --gpus=1

setenv CONDA_ENVS_PATH /speed-scratch/$USER/condas
setenv CONDA_PKGS_DIRS /speed-scratch/$USER/condas/pkg

# activate the environment created before
conda activate <Environment_Name>
srun python /speed-scratch/$USER/<Directory_where_the_script_is_located>/tf-stress.py
conda deactivate