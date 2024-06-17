#!/encs/bin/tcsh
#SBATCH --nodes 1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=4 # change this parameter to 2,4,6,... to see the effect on performance

#SBATCH --mem=24G
#SBATCH --time=0:05:00
#SBATCH --output=%N-%j.out

source /speed-scratch/$USER/tmp/pytorchcpu/bin/activate.csh
echo "starting training..."

time python torch-multicpu.py