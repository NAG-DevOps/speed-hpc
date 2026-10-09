# 4. Contiguous MPI Datatype

## Description

This is an MPI program that creates a contiguous MPI datatype to transfer a
struct using MPI_Bcast on an instance of the datatype followed by broadcasting
of a vector of the contiguous datatype.

## Building

This is built using CMake.

```
cmake -B build -S .
cmake --build build
```

## Running

```
mpirun -n 4 build/contiguous
```
