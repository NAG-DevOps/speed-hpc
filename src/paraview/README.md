# Paraview 

ParaView is an open source post-processing visualization engine.

[Source](https://www.paraview.org/)

## Instructions

* Open an interactive session
* Execute the following commands:
```bash
module load GCC/12.3.0
module load OpenMPI/4.1.5
module load ParaView/5.13.2

setenv PSM3_DEVICES 'self,shm'
srun --mpi=pmix paraview
```