#!/encs/bin/bash

#SBATCH -J bash-test    ## --job-name
#SBATCH --mem=1G        ## memory per node
#SBATCH --chdir=./      ## Set current directory as working directory

sleep 30

# To use the module command, source the following:
. /encs/pkg/modules-5.3.1/root/init/bash

module load python/3.12.0/default
module list