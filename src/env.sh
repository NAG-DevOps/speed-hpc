#!/encs/bin/tcsh

#SBATCH --job-name=envs        ## Give the job a name
#SBATCH --mail-type=ALL        ## Receive all email type notifications
#SBATCH --mail-user=$USER@encs.concordia.ca
#SBATCH --chdir=./             ## Use currect directory as working directory
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1      ## Request 1 cpus
#SBATCH --mem=1G               ## Assign 1G memory per node

# Reset TMPDIR to a larger storage
mkdir -p /speed-scratch/$USER/tmp
setenv TMPDIR /speed-scratch/$USER/tmp

srun date
srun env
srun date
wait
