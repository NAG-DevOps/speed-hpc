#!/encs/bin/tcsh

# Serguei Mokhov
# SLURM job invocation script
# mac-spoofer-flucid-processor is a Perl script -- the actual job

##
## SLURM SBATCH options
##

#SBATCH --job-name=mac-spoofer-flucid-processor  ## Set the job's name
#SBATCH --mem=20G           ## Set memory per node
#SBATCH --chdir=./          ## Set current directory as working directory
## Export all SLURM_* environment variables and the explicitely defined hv variable
#SBATCH --export=ALL,hv=8   

## Includes 4 Perl/Java processes per claim type
## Note: SLURM default is one task per node.
#SBATCH --cpus-per-task=8   ## Allocate 8 cpus per task

# Notifications
#SBATCH --mail-type=ALL ## Receive all email type notifications

##
## Job to run
##

# 
# The $RT variable is initialized on the command line 
# before calling this script. Example for tcsh 
# setenv RT 123

echo "$0 : about to run mac-spoofer-flucid-processor on Speed"
srun mac-spoofer-flucid-processor $RT

# EOF
