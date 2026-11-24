# 5. MPI Struct

## Description

This is an MPI program that creates a custom MPI datatype for a C++ struct with mixed field types (`Particle`: an `int`, a `char` and three `float`s) using `MPI_Type_create_struct`. Rank 0 broadcasts a single `Particle` to all other processes with `MPI_Bcast`, then a vector of two `Particle`s.

## Building

This is built using CMake. The job script `mpi_struct.sh` loads the required modules, builds the program, and runs it on 4 nodes with 1 process per node, using `srun`.

## Running

From this folder, submit the job:
```
sbatch mpi_struct.sh
```

The output is written to `slurm-<jobid>.out` in this folder.
