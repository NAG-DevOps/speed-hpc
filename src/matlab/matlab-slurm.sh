#!/encs/bin/tcsh

#SBATCH --job-name=matlab-job  ## Give the job a name
#SBATCH --mail-type=ALL        ## Receive all email type notifications
#SBATCH --chdir=./             ## Use currect directory as working directory (default)
#SBATCH --partition=pg-gpu     ## Use the GPU partition (specify here or at command line wirh -p option)
#SBATCH --gpus=1               ## How many GPUs (currently limit is set 2 max for Speed 5 and 17)
#SBATCH --mem=4Gb

# Loads matlab module version
module load matlab/R2022a/default

# Displays to the output file whether the module(s) is(are) loaded correctly <OPTIONAL> 
module list

# Matlab parameters - add/modify/remove them according your script

# -nodesktop -nodisplay: Launches Matlab in the terminal
# -nojvm : Tells Matlab to run without the Java Virtual Machine to reduce overhead
# test.m : Matlab commands file

srun matlab -nodisplay -nodesktop -nojvm < matlab-example.m
