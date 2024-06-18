<!-- TOC --><a name="README"></a>
# README

This directory has example scripts to using Pytorch with Python virtual environment to run on multiple CPUs (most universal).
Adapted to SPEED from https://docs.alliancecan.ca/wiki/PyTorch

```
(speed-submit)
cd /speed-scratch/$USER
salloc -p ps --mem=20G --mail-type=ALL
(compute node)
time ./firsttime.sh
(takes about 5 mins)
exit
(speed-submit)
sbatch -p ps pytorch-multicpu.sh
tail -f slurm-JOBID.out
```
