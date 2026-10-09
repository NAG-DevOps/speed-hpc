# 6. Client Server

## Description

This is a pair of MPI programs. The `server` runs a basic server that receives
commands from the `client` program. The `client` sends `Particle` data to the
`server` which prints it out.

## Building

This is built using CMake.

```
cmake -B build -S .
cmake --build build
```

## Running

### OpenMPI 5 or later

```
# Server
prterun --report-uri server.txt -n 1 build/server

# On a different terminal
prun --dvm file:server.txt -n 1 build/client
```

### OpenMPI 4 or earlier

```
# Server
ompi-server --report-uri server.txt &
mpiexec --ompi-server file:server.txt -n 1 build/server

# On a different terminal
mpiexec --ompi-server file:server.txt -n 1 build/client
```
