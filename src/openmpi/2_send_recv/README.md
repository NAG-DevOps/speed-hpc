# 2. Send and Receive

## Description

This is a basic MPI program that sends from rank 0 to other programs using the
basic MPI_Send and MPI_Recv functions.

## Building

This is built using CMake.

```
cmake -B build -S .
cmake --build build
```

## Running

```
mpirun -n 4 build/send_recv
```
