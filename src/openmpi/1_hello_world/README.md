# 1. Hello World

## Description

This is a basic MPI program that reports the rank, world size and processor name
of the process.

## Building

This is built using CMake.

```
cmake -B build -S .
cmake --build build
```

## Running

```
mpirun -n 4 build/hello_world
```
