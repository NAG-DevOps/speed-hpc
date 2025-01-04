#!/encs/bin/tcsh

#
# Runs GPAW as a Singularity container
#

#SBATCH --nodes 1

# GPAW and MPI seem towork with processes
# change this parameter to 2,4,6,... to see the effect on performance
#SBATCH --tasks-per-node=4
#SBATCH --cpus-per-task=1

# Standard partition, EL9 nodes
#SBATCH -p ps
#SBATCH --constraint=el9

#SBATCH --mem=32G
#SBATCH --output=%N-%j.out

#SBATCH --mail-type=ALL

# GPAW container image
set CONTAINER = "/speed-scratch/nag-public/gpaw-openmpi.sif"

module load singularity/3.10.4/default

# Job env is inside the container
set JOB_ENV = '. /etc/profile.d/modules.sh && module use /usr/share/modulefiles && module load mpi/openmpi && PYTHONPATH=$MPI_PYTHON3_SITEARCH OMP_NUM_THREADS=1 GPAW_SETUP_PATH=/usr/share/gpaw-setups'

echo "About to run gpaw info"
date

# Command to run inside the container
set COMMAND = "gpaw info"

# --bind all the directories you need to be visible in the container
#   $PWD assumes current directory
#   otherwise a comma-separated list

time singularity exec \
	--bind $PWD \
	$CONTAINER \
	bash -c "$JOB_ENV $COMMAND"

echo "About to run Ag.py"
date

# mpiexec for OpenMPI paralleism
# gpaw is for classic GPAW invocation
# Ag.py is a sample script
set COMMAND = "mpiexec -np $SLURM_NTASKS --use-hwthread-cpus python3 Ag.py"
#set COMMAND = "gpaw -P $SLURM_NTASKS python Ag.py"

echo "COMMAND: $COMMAND"

time singularity exec \
	--bind $PWD,/disk/nobackup,/disk/nobackup2 \
	$CONTAINER \
	bash -c "$JOB_ENV $COMMAND"

echo "Done with the job script"
date

# EOF
