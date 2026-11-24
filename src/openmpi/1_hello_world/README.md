# 1. Hello World

## Description

This is a basic MPI program that reports the rank, world size and processor name of each process. Use it to check that an MPI job runs correctly across several nodes.

## Building

This is built using CMake. The job script `mpi_hello_world.sh` loads the required modules, builds the program, and runs it on 4 nodes with 1 process per node, using `srun`.

## Running

From this folder, submit the job:
```
sbatch mpi_hello_world.sh
```

The output is written to `slurm-<jobid>.out` in this folder. Each line starts with the rank that printed it:
```
0: Hello World from 0/4 on speed-03.encs.concordia.ca!
1: Hello World from 1/4 on speed-25.encs.concordia.ca!
...
```
