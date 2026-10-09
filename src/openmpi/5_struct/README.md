# 5. MPI Struct

## Description

This is an MPI program that creates an MPI struct datatype to transfer a
struct with mixed variable types using MPI_Bcast on an instance of the datatype
followed by broadcasting of a vector of that datatype.

## Building

This is built using CMake.

```
cmake -B build -S .
cmake --build build
```

## Running

```
mpirun -n 4 build/struct
```
