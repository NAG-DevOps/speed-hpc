#!/encs/bin/tcsh

#####################################################################################################################
## Gurobi brings its own version of Python but that one does not contain any 3rd-party Python packages except Gurobi. 
## In order to use Gurobi together with popular Python packages like multiprocessing and others, we need to create a
## virtual Python environment, in which we can install gurobipy and other pakages.
##
## You can create the new virtual Python environment inside your home directory before scheduling your job,
## or create it inside $TMPDIR on fly as a part of your job
#####################################################################################################################

## SLURM options

#SBATCH --job-name=gurobi-with-python ## Give the job a name
#SBATCH --mail-type=ALL               ## Receive all email type notifications
#SBATCH --chdir=./                    ## Use currect directory as working directory (default) 
                                      ## stored as $SLURM_SUBMIT_DIR
#SBATCH --cpus-per-task=8             ## Request 8 cpus
#SBATCH --mem=150G                    ## Assign memory per node 

##PUT YOUR MODULE LOADS HERE
module load gurobi/9.0.2/default
module load python/3.7.7/default
## Create environment variables 
setenv workdir $PWD

## Activate the new environment, created before (see Virtual Environment details, below)
source /speed-scratch/$USER/tmp/YOUR_VENV_NAME/bin/activate.csh
## Install gurobipy module
cd $GUROBI_HOME
srun python setup.py build --build-base /tmp/${USER} install

## return to working directory
cd $workdir

## Now, instead of using 'gurobi.sh MY_PYTHON_SCRIPT.py', you can use
srun python MY_PYTHON_SCRIPT.py
## inside MY_PYTHON_SCRIPT.py, you can use
## from gurobipy import *
## import multiprocessing as mp

####### Virtual Environment ####### 
# - Normally is installed once, before creating the .sh batch file
# 
# cd /speed-scratch/$USER
# 
# if using GPUs
#     srun --partition=pg --mem=10Gb --gpus=1 --pty /encs/bin/tcsh
# if using CPUs only
#     srun --partition=ps --mem=10Gb --pty /encs/bin/tcsh
# module load python/3.7.7/default
# mkdir -p /speed-scratch/$USER/tmp 
# setenv TMPDIR /speed-scratch/$USER/tmp
# setenv TMP /speed-scratch/$USER/tmp
# python -m venv $TMPDIR/testenv (testenv=name of the virtualEnv)
# source $TMPDIR/testenv/bin/activate.csh
# pip install modules…
# deactivate
# exit
#
