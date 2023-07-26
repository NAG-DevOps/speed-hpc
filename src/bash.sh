#!/encs/bin/bash

#SBATCH -J sbatch-test  ## --job-name
#SBATCH --mem=1G        ## memory per node
#SBATCH --chdir=./      ## Set current directory as working directory

sleep 30

# To use the module command, source the following:
. /encs/pkg/modules-3.2.10/root/Modules/3.2.10/init/bash

module load gurobi/8.1.0
module list 