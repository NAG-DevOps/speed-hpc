#!/encs/bin/tcsh

#SBATCH --job-name=flu10000    ## Give the job a name
#SBATCH --mail-type=ALL        ## Receive all email type notifications
#SBATCH --chdir=./             ## Use currect directory as working directory
#SBATCH --nodes=1              ## Number of nodes to run on
#SBATCH --ntasks-per-node=32   ## Number of cores
#SBATCH --cpus-per-task=1      ## Number of MPI threads
#SBATCH --mem=160G             ## Assign 160G memory per node 

date

module avail ansys

module load ansys/19.2/default
cd $TMPDIR

set FLUENTNODES = "`scontrol show hostnames`"
set FLUENTNODES = `echo $FLUENTNODES | tr ' ' ','`

date

srun fluent 3ddp \
	-g -t$SLURM_NTASKS \
	-g-cnf=$FLUENTNODES \
	-i $SLURM_SUBMIT_DIR/fluentdata/info.jou > call.txt

date

srun rsync -av $TMPDIR/ $SLURM_SUBMIT_DIR/fluentparallel/

date
