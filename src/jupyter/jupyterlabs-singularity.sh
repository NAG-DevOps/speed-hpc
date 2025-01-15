#!/encs/bin/tcsh

## Script for https://nag-devops.github.io/speed-hpc/#jupyter-notebooks
## since it is salloc (or srun) (e.g salloc -p ps --mem=4000 --x11 -t 0-06:00) no need to configure cluster settings because
## it would choose the proper computational node  

module load singularity/3.10.4/default

# Executing singularity image 
srun singularity exec -B $PWD\:/speed-pwd,/speed-scratch/$USER\:/my-speed-scratch,/nettemp --env SHELL=/bin/bash --nv /speed-scratch/nag-public/jupyter-pytorch-cuda.sif /bin/bash -c '/opt/conda/bin/jupyter notebook --no-browser --notebook-dir=/speed-pwd --ip="0.0.0.0" --port=8888 --allow-root'

## If you receive an error like:   FATAL:container creation failed: exec: "/usr/bin/nvidia-container-cli"
## remove the parameter: --nv and execute again srun singularity ...

# A token is generated when execution is successful

## [I 09:10:49.547 NotebookApp] Jupyter Notebook 6.5.2 is running at:
## [I 09:10:49.547 NotebookApp] http://speed-xx.encs.concordia.ca:8888/?token=xxxxxxxxxxxxxxxxxxxx
## [I 09:10:49.547 NotebookApp]  or http://127.0.0.1:8888/?token=xxxxxxxxxxxxxxxxxxxx
## [I 09:10:49.547 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).

# Continue with the ssh tunnel creation as described in: https://nag-devops.github.io/speed-hpc/#jupyter-notebooks
