# 6. Client Server

## Description

This is a pair of MPI programs. The `server` waits for a `client` to connect, and the `client` sends it `Particle` data (a single particle, then a vector of particles), which the server prints. The two programs run as separate jobs and find each other through `ompi-server`.

## Building

This is built using CMake. The server job builds both programs and the client job uses that build.

## Running

From this folder, submit the server:
```
sbatch mpi_client_server.sh server
```

Then run the client as an interactive job:
```
salloc -p pt --ntasks=1 --cpus-per-task=2 --mem=2G
./mpi_client_server.sh client
```

The client shows a menu. Type `P` to send one particle, `V` to send a vector of particles, and `D` to disconnect.

The server's output is in `slurm-<jobid>.out` in this folder.
