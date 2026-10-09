#!/bin/bash

##
## Sample OpenMPI batch job script for Speed.
##
## To launch (from the example directory):
##    sbatch mpi_client_server.sh
##
## The script does a clean build of the example with CMake in
## /speed-scratch/$USER/mpi_build/<example>, then runs it across
## the allocated nodes. The job output (slurm-<jobid>.out) is
## written to the folder you submit from.
##

##
## Job Scheduler options 
##
#SBATCH --job-name=mpi_client_server ## Give the job a name
#SBATCH --mail-type=ALL            ## Receive all email type notifications
#SBATCH --chdir=./                 ## Use current directory as working directory
#SBATCH --nodes=1                  ## Request 2 node
#SBATCH --ntasks=1                 ## 1 processes
#SBATCH --cpus-per-task=2          ## Request 2 CPUs per task
#SBATCH --mem=2G                   ## Assign memory per node 
#SBATCH -p pt                      ## Teaching partition by default; can be ps

##
## Example settings
##
EXAMPLE=6_client_server                ## Example folder name
SERVER_EXE=server                      ## Server program defined in CMakeLists.txt
CLIENT_EXE=client                      ## Client program defined in CMakeLists.txt
SPEED_DIR=/speed-scratch/$USER
MPI_SRC_DIR=$SPEED_DIR/speed-hpc/src/openmpi/$EXAMPLE
MPI_BUILD_DIR=$SPEED_DIR/mpi_build/$EXAMPLE

##
## Job to run
##
date
echo "$SLURM_JOB_NAME : about to run an OpenMPI job on Speed"
echo "$SLURM_JOB_NAME : job $SLURM_JOB_ID starting on $SLURM_JOB_NODELIST"

# Load required modules
. /encs/pkg/modules-5.3.1/root/init/bash
module purge
module load openmpi/default
module load openpmix/default
module load CMake/3.31.8

# Remove any previous build so every run starts from a clean build
if [ -d "$MPI_BUILD_DIR" ]; then
    echo "Found previous build in $MPI_BUILD_DIR, removing it"
    rm -rf "${MPI_BUILD_DIR:?}"
fi
mkdir -p "$MPI_BUILD_DIR"

# Configure and build, once, on the first node
echo "About to build..."
cmake -B "$MPI_BUILD_DIR" -S "$MPI_SRC_DIR" || { echo "CMake configure failed" >&2; exit 1; }
time cmake --build "$MPI_BUILD_DIR"         || { echo "Build failed" >&2; exit 1; }

# Run
export PMIX_MCA_gds=hash # Work around a PMIx component mismatch warning between Slurm and OpenMPI
echo "$1"

if [[ "$1" == "$SERVER_EXE" ]]; then
    echo "$SLURM_JOB_NAME : about to run $SERVER_EXE"
    ompi-server --report-uri server.txt &
    mpiexec --ompi-server file:server.txt -n 1 $MPI_BUILD_DIR/$SERVER_EXE
else
    echo "$SLURM_JOB_NAME : about to run $CLIENT_EXE"
    mpiexec --ompi-server file:server.txt -n 1 $MPI_BUILD_DIR/$CLIENT_EXE
fi

echo "$SLURM_JOB_NAME : Done!"
date

# EOF
