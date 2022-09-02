#!/encs/bin/tcsh

# Give job a name
#$ -N reid-job

# Send an email when the job starts, finishes or if it is aborted.
#$ -m bea

# Specify the output file name
#$ -o reid-tfk.qlog2

# Set output directory to current
#$ -cwd

# Request CPU
# #$ -pe smp 32
# #$ -l h_vmem=32G

# Request GPU
#$ -l gpu=2

# Execute the script
module load anaconda/default
conda env create -f environment.yml -p /speed-scratch/$USER/reid-venv
conda activate /speed-scratch/$USER/reid-venv
python reid.py
conda deactivate
conda env remove -p /speed-scratch/$USER/reid-venv