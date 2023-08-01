#!/encs/bin/tcsh

#SBATCH --job-name=flu10000    ## Give the job a name
#SBATCH --mail-type=ALL        ## Receive all email type notifications
#SBATCH --mail-user=$USER@encs.concordia.ca
#SBATCH --chdir=./             ## Use currect directory as working directory
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8      ## Request 8 cpus
#SBATCH --mem=160G             ## Assign 160G memory per node 


module load ansys/19.0/default
cd $TMPDIR

fluent 3ddp -g -i $SGE_O_WORKDIR/fluentdata/info.jou -sgepe smp > call.txt

rsync -av $TMPDIR/ $SGE_O_WORKDIR/fluentparallel/