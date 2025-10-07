#!/encs/bin/tcsh

echo "Loading modules"
module load GCC/12.3.0 -s
module load OpenMPI/4.1.5 -s
module load ParaView/5.13.2 -s

mkdir -p /speed-scratch/$USER/run-user
chmod 700 /speed-scratch/$USER/run-user
setenv XDG_RUNTIME_DIR /speed-scratch/$USER/run-user
setenv PSM3_DEVICES 'self,shm'
echo "Loading Paraview GUI ..."
srun --mpi=pmix paraview

