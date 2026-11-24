# 3. Broadcasting

## Description

This is a basic MPI program that uses `MPI_Bcast` to send a vector of integers from rank 0 to all other processes. In each round, rank 0 sets 3 random positions of a 3×3 grid to 1 and broadcasts it, and the other ranks print the grid before and after receiving it.

## Building

This is built using CMake. The job script `mpi_broadcast.sh` loads the required modules, builds the program, and runs it on 4 nodes with 1 process per node, using `srun`.

## Running

From this folder, submit the job:
```
sbatch mpi_broadcast.sh
```

The program takes the number of rounds as an argument (3 by default). To change it, edit `EXECUTABLE_ARGS` in `mpi_broadcast.sh`.

The output is written to `slurm-<jobid>.out` in this folder.
