# Introduction

FEniCS is a popular open-source computing platform for solving partial differential equations (PDEs) with the finite element method (FEM).

[Fenics Website](https://fenicsproject.org/)

## Modules required to load FEniCS

```bash
    module load GCC/14.3.0
    module load OpenMPI/5.0.8
    module load FEniCS-DOLFINx-Python/0.10.0.post5
```

## Instructions to run the example 

* Based on the official FEniCS demo and adapted to Slurm: https://github.com/FEniCS/dolfinx/blob/main/python/demo/demo_poisson.py

* From the **submit** node, go to the directory where `fenics-python.sh` and `poisson_dolfinx.py` were saved.
* Modify the parameters to run on single or multi-node
* Send the job to the scheduler

```bash
    sbatch fenics-python.sh
```
* The file **poisson_xxxxx.out** contains the result of the simulation execution.
* The subdirectory **out_poisson** contains the h5 and xdmf, solution files.

