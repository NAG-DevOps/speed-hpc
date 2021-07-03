#!/encs/bin/tcsh

#$ -N flu10000
#$ -cwd
#$ -m bea
#$ -pe smp 32
#$ -l h_vmem=160G

module load ansys/19.0/default
cd $TMPDIR

fluent 3ddp -g -i $SGE_O_WORKDIR/fluentdata/info.jou -sgepe smp > call.txt

rsync -av $TMPDIR/ $SGE_O_WORKDIR/fluentparallel/
