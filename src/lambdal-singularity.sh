#!/encs/bin/bash

# Serguei Mokhov
# UGE-based job invocation script

# Singulairy container for Lambda Labs Software Stack

##
## Job scheduler options
##

# Run from the current directory where this script is
#$ -cwd

# How many GPUs (currently limit is set 2 max for Speed 5 and 17)
#$ -l gpu=2

# High value of memory requeted
#$ -l h_vmem=20G
#$ -ac hv=8

# Number of cores requested (approx).
# Be conservative
#$ -pe smp 4

# Email notifications
#$ -m bea

##
## Job to run
##

# 
# Run on GPU nodes like, `qsub -q g.q ...'
#

echo "$0 : about to run gcs-labdalabs-singulairty on Speed..."
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
	$SINGULARITY run --nv /speed-scratch/nag-public/gcs-lambdalabs-stack.sif \
	/usr/bin/python3 -c 'import torch; print(torch.rand(5, 5).cuda()); print(\"I love Lambda Stack!\")'

time \ 
	$SINGULARITY exec touch /my-speed-scratch/test1

echo "$0 : Done!"
date

# EOF
