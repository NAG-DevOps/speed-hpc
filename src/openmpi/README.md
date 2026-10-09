# MPI Examples

## List of Examples 

### 1. Hello World

This is a basic MPI program that reports the rank, world size and processor name
of the process.

### 2. Send and Receive

This is a basic MPI program that sends from rank 0 to other programs using the
basic MPI_Send and MPI_Recv functions.

### 3. Broadcasting

This is a basic MPI program that uses MPI_Bcast to broadcast a vector of
integers from rank 0.

### 4. Contiguous MPI Datatype

This is an MPI program that creates a contiguous MPI datatype to transfer a
struct using MPI_Bcast on an instance of the datatype followed by broadcasting
of a vector of the contiguous datatype.

### 5. MPI Struct

This is an MPI program that creates an MPI struct datatype to transfer a
struct with mixed variable types using MPI_Bcast on an instance of the datatype
followed by broadcasting of a vector of that datatype.

### 6. Client Server

This is a pair of MPI programs. The `server` runs a basic server that receives
commands from the `client` program. The `client` sends `Particle` data to the
`server` which prints it out.


## Running examples with slurm on the Speed Cluster

### Clone the Repo

```
git clone --depth https://github.com/NAG-DevOps/speed-hpc.git /speed-scratch/$USER/speed-hpc
```

### Build and Run the example

Basic template for an sbatch script:
```
#!/bin/bash

#SBATCH --mem=2G -t 600 -J MPI_example --mail-type=ALL -p ps -N 4

module load openmpi/default
module load openpmix/default
module load gcc/13.1/default
module load CMake/3.31.8

SPEED_DIR=/speed-scratch/$USER
EXAMPLE=1_hello_world
MPI_SRC_DIR=$SPEED_DIR/speed-hpc/mpi/$EXAMPLE
MPI_BUILD_DIR=/speed-scratch/$USER/mpi_build/$EXAMPLE

rm -rf "$MPI_BUILD_DIR"
cmake -B "$MPI_BUILD_DIR" -S "$MPI_SRC_DIR"
cmake --build "$MPI_BUILD_DIR"

srun --mpi=pmix ${MPI_BUILD_DIR}/hello_world
```

## Author

Jonathan Llewellyn <jonathan.llewellyn@concordia.ca>

