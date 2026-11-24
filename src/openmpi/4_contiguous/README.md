# 4. Contiguous MPI Datatype

## Description

This is an MPI program that creates a custom MPI datatype for a C++ struct (`Coord`, three floats) using `MPI_Type_contiguous`. Rank 0 broadcasts a single `Coord` to all other processes with `MPI_Bcast`, then a vector of two `Coord`s.

## Building

This is built using CMake. The job script `mpi_contiguous.sh` loads the required modules, builds the program, and runs it on 4 nodes with 1 process per node, using `srun`.

## Running

From this folder, submit the job:
```
sbatch mpi_contiguous.sh
```

The output is written to `slurm-<jobid>.out` in this folder.
