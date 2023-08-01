#!/encs/bin/tcsh

#SBATCH --job-name=sbatch-test
#SBATCH --mem=1G

sleep 30
module load gurobi/8.1.0
module list
