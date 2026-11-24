#!/bin/bash

##
## Sample OpenMPI client/server batch job script for Speed. 
##
## This example runs as 2 separate jobs: a server and a client.
## To launch the server (from the example directory):
##    sbatch mpi_client_server.sh server
## Then run the client as an interactive job:
##    salloc -p pt --ntasks=1 --cpus-per-task=2 --mem=2G
##    ./mpi_client_server.sh client
##
## The script does a clean build of the example with CMake in
## /speed-scratch/$USER/mpi_build/<example>, then runs it across
## the allocated nodes. 
##
## The job output (slurm-<jobid>.out) is written to the folder you submit from.
##

##
## Job Scheduler options 
##
#SBATCH --job-name=mpi_client_server ## Give the job a name
#SBATCH --mail-type=ALL            ## Receive all email type notifications
#SBATCH --chdir=./                 ## Use current directory as working directory
#SBATCH --nodes=1                  ## Request 1 node
#SBATCH --ntasks=1                 ## 1 processes
#SBATCH --cpus-per-task=2          ## Request 2 CPUs per task
#SBATCH --mem=2G                   ## Assign memory per node 
#SBATCH -p pt                      ## Teaching partition by default; can be ps
#SBATCH --time=00:30:00            ## Stop the job after 30 minutes

##
## Example settings
##
EXAMPLE=6_client_server                ## Example folder name
SERVER_EXE=server                      ## Server program defined in CMakeLists.txt
CLIENT_EXE=client                      ## Client program defined in CMakeLists.txt
SPEED_DIR=/speed-scratch/$USER
MPI_SRC_DIR=$SLURM_SUBMIT_DIR
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

export PMIX_MCA_gds=hash # Work around a PMIx component mismatch warning between Slurm and OpenMPI
if [[ "$1" == "server" ]]; then
    # Remove any previous build so every run starts from a clean build
    rm -f server.txt
    trap 'rm -f server.txt' EXIT
    if [ -d "$MPI_BUILD_DIR" ]; then
        echo "Found previous build in $MPI_BUILD_DIR, removing it"
        rm -rf "${MPI_BUILD_DIR:?}"
    fi
    mkdir -p "$MPI_BUILD_DIR"

    # Configure and build, once, on the first node
    echo "About to build $MPI_SRC_DIR..."
    cmake -B "$MPI_BUILD_DIR" -S "$MPI_SRC_DIR" || { echo "CMake configure failed" >&2; exit 1; }
    time cmake --build "$MPI_BUILD_DIR"         || { echo "Build failed" >&2; exit 1; }

    echo "$SLURM_JOB_NAME : about to run $SERVER_EXE"
    ompi-server --report-uri server.txt &
    sleep 5
    mpiexec --ompi-server file:server.txt -n 1 $MPI_BUILD_DIR/$SERVER_EXE
elif [[ "$1" == "client" ]]; then
    echo "$SLURM_JOB_NAME : about to run $CLIENT_EXE"
    mpiexec --ompi-server file:server.txt -n 1 $MPI_BUILD_DIR/$CLIENT_EXE
else
    exit 1
fi

echo "$SLURM_JOB_NAME : Done!"
date

# EOF
