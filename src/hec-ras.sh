#!/encs/bin/tcsh

# Example adapted to Slurm from:
# https://www.hec.usace.army.mil/software/hec-ras/documentation/HEC-RAS_66_Linux_Build_Release_Notes.pdf
#

#SBATCH --job-name=Hec-Ras   ## Give the job a name
#SBATCH --mail-type=ALL      ## Receive all email type notifications
#SBATCH --nodes=1            ## 1 node (default)
#SBATCH --ntasks=1           ## 1 task (default)
#SBATCH --cpus-per-task=2    ## Request 2 cpus
#SBATCH --mem=1G             ## Assign 1G memory

module load hec-ras/6.6/default
cd $SLURM_SUBMIT_DIR

## Copy example files to current directory
cp $RAS_EXAMPLE/* .

# Preprocessor run
srun RasGeomPreprocess Muncie.p04.tmp.hdf x04

#Unsteady run
srun RasUnsteady Muncie.p04.tmp.hdf x04
mv Muncie.p04.tmp.hdf Muncie.p04.hdf

#Steady run
srun RasSteady Muncie.r04