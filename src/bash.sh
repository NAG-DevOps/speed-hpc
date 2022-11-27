#!/encs/bin/bash

#$ -N qsub-test
#$ -cwd
#$ -l h_vmem=1G

sleep 30

# To use the module command, source the following:
. /encs/pkg/modules-3.2.10/root/Modules/3.2.10/init/bash

module load gurobi/8.1.0
module list