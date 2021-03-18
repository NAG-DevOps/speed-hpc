#!/encs/bin/tcsh

#$ -N qsub-test
#$ -cwd
#$ -l h_vmem=1G

sleep 30
module load gurobi/8.1.0
module list
