# 3. Broadcasting

## Description

This is a basic MPI program that uses MPI_Bcast to broadcast a vector of
integers from rank 0.

## Building

This is built using CMake.

```
cmake -B build -S .
cmake --build build
```

## Running

```
mpirun -n 4 build/broadcast
```
