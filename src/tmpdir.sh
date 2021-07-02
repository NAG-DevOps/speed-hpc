#!/encs/bin/tcsh

#$ -N envs
#$ -cwd
#$ -pe smp 8
#$ -l h_vmem=32G

cd $TMPDIR
mkdir input
rsync -av $SGE_O_WORKDIR/references/ input/
mkdir results
STAR --inFiles $TMPDIR/input --parallel $NSLOTS --outFiles $TMPDIR/results
rsync -av $TMPDIR/results/ $SGE_O_WORKDIR/processed/
