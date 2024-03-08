#!/encs/bin/tcsh
#SBATCH --job-name=OpenFOAM-test
#SBATCH --nodes=4
#SBATCH --ntasks=10
#SBATCH --time=00:10:00

module load OpenFOAM/v2306/default
setenv PATH /encs/pkg/openmpi-4.1.6/root/bin\:$PATH
setenv LD_LIBRARY_PATH $LD_LIBRARY_PATH\:/encs/pkg/openmpi-4.1.6/root/lib64
setenv CORES $SLURM_NTASKS
setenv OMP_NUM_THREADS $CORES

blockMesh
mpirun -np $CORES redistributePar -decompose -overwrite -parallel
mpirun -np $CORES icoFoam -parallel
mpirun -np $CORES redistributePar -reconstruct -overwrite -parallel