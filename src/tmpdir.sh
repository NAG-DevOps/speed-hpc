#!/encs/bin/tcsh

#SBATCH --job-name=tmpdir      ## Give the job a name
#SBATCH --mail-type=ALL        ## Receive all email type notifications
#SBATCH --chdir=./             ## Use currect directory as working directory
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8      ## Request 8 cores
#SBATCH --mem=32G              ## Assign 32G memory per node 

cd $TMPDIR
mkdir input
rsync -av $SLURM_SUBMIT_DIR/references/ input/
mkdir results
srun STAR --inFiles $TMPDIR/input --parallel $SRUN_CPUS_PER_TASK --outFiles $TMPDIR/results
rsync -av $TMPDIR/results/ $SLURM_SUBMIT_DIR/processed/
