#!/encs/bin/tcsh

# Job name
#SBATCH --job-name openiss-reid

# Recieve email notifications when the job starts, finishes or fails.
#SBATCH --mail-type=ALL

# Set output directory to current
#SBATCH --chdir=./

# Specify the output file name
#SBATCH -o openiss-reid-output-%A.log

# Request Memory
#SBATCH --mem=20G

# Request CPU - comment this section if the job needs GPUs 
##SBATCH -c 32

# Request GPU - comment this section if the job needs CPUs and uncomment the previous section
#SBATCH --gpus=1

# Execute the script
module load anaconda3/2023.03/default
conda env create -f environment.yml -p ../reid-venv
conda activate ../reid-venv
srun python reid.py
conda deactivate
conda env remove -p ../reid-venv
