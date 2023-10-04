#!/encs/bin/bash

# Serguei Mokhov
# Slurm invocation script

# Singulairy container for Lambda Labs Software Stack

##
## Job scheduler options
##

#SBATCH --job-name=envs        ## Give the job a name
#SBATCH --mail-type=ALL        ## Receive all email type notifications
#SBATCH --mail-user=$USER@encs.concordia.ca
#SBATCH --chdir=./             ## Use currect directory as working directory (default)
#SBATCH --partition=pg-gpu     ## Use the GPU partition (specify here or at command line wirh -p option)
#SBATCH --gpus=2               ## How many GPUs (currently limit is set 2 max for Speed 5 and 17)
#SBATCH --mem=20G              ## Assign memory
#SBATCH --export=ALL,hv=8      ## Export all environment variables and set a value for the hv variable

##
## Job to run
##

echo "$0 : about to run gcs-lambdalabs-singularity on Speed..."
date

# time will simply measure and print runtime
# sigularity run -- running the image
# then whatever script you need to run inside the container

SINGULARITY=/encs/pkg/singularity-3.7.0/root/bin/singularity

# bind mount the current directory, the user's speed-scratch
#           directory, nettemp
# Note: $HOME, /tmp, /proc, /sys, /dev are bound by default
#
SINGULARITY_BIND=$PWD:/speed-pwd,/speed-scratch/$USER:/my-speed-scratch,/nettemp

echo "Singularity will bind mount: $SINGULARITY_BIND for user: $USER"


time \
	srun $SINGULARITY run --nv /speed-scratch/nag-public/gcs-lambdalabs-stack.sif \
	/usr/bin/python3 -c 'import torch; print(torch.rand(5, 5).cuda()); print(\"I love Lambda Stack!\")'

time \ 
	srun $SINGULARITY exec touch /my-speed-scratch/test1

echo "$0 : Done!"
date

# EOF
