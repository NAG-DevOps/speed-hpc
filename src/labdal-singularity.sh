#!/encs/bin/tcsh

# Serguei Mokhov
# UGE-based job invocation script

# Singulairy container for Lambda Labs Software Stack

##
## Job scheduler options
##

# Run from the current directory where this script is
#$ -cwd

# How many GPUs (currently limit is set 2 max for Speed 5 and 17)
#$-l g16=1
#$-l gpu=2

# High value of memory requeted
#$ -l h_vmem=20G
#$ -ac hv=8

# Number of cores requested (approx).
# Be conservative
#$ -pe smp 16

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
# SINGULARITYENV_CUDA_VISIBLE_DEVICES -- how many GPUs to use in the contaienr,
#   On Speed 5 and 17 it should always be 2 for now as a policy.
# sigularity run -- running the image
# then whatever script you need to run inside the container

time \
	SINGULARITYENV_CUDA_VISIBLE_DEVICES=2 \
	sigularity run --nv /speed-scratch/nag-public/gcs-lambdalabs-stack.sif \
	/usr/bin/python3 -c 'import torch; print(torch.rand(5, 5).cuda()); print("I love Lambda Stack!")' && \
	/usr/bin/python3 -c 'from tensorflow.python.client import device_lib; print(device_lib.list_local_devices())'

echo "$0 : Done!"
date

# EOF
