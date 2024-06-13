#!/encs/bin/tcsh

# Give job a name
#SBATCH -J openiss-reid

# Send an email when the job starts, finishes or if it is aborted.
#SBATCH --mail-type=ALL

# Specify the output file name
#SBATCH -o openiss-reid-tfk.log

# Set output directory to current
#SBATCH --chdir=./

# Request Memory
#SBATCH --mem=32G

# Request CPU - comment this section if the job needs GPUs 
##SBATCH -n 32

# Request GPU - comment this section if the job needs CPUs and uncomment the previous section
#SBATCH --gpus=1

# Execute the script
module load anaconda3/2023.03/default
conda env create -f environment.yml -p /speed-scratch/$USER/reid-venv
conda activate /speed-scratch/$USER/reid-venv
srun python reid.py
conda deactivate
conda env remove -p /speed-scratch/$USER/reid-venv
