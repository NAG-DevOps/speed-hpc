#!/encs/bin/tcsh

##
## Sample raytraycer batch job launching script.
## Intented primarily for COMP371.
##
## Serguei Mokhov
##
## To launch: sbatch comp371-raytraycer.sh
## do it in:  /speed-scratch/$USER
##
## Configure your email address and possibly a repo to pull from.
## The script pulls the repo if not already pulled and builds
## if not already built.
##

##
## Job Scheduler options 
##

#SBATCH --job-name=c371-raytraycer ## Give the job a name
#SBATCH --mail-type=ALL            ## Receive all email type notifications
#SBATCH --chdir=./                 ## Use currect directory as working directory
#SBATCH --cpus-per-task=2          ## Request 2 cpus
#SBATCH --mem=1G                   ## Assign memory per node 
#SBATCH -p pt                      ## Teaching partition by default; can be ps
#SBATCH -A comp371w14              ## Speed Slurm account 

##
## Job to run
##

# timestamp
echo "$0 : about to run a COMP371 raytraycer job on Speed"
date

# Print debug environment
env

# Pull the sources at the latest commit only to avoid
# downloading all the history. For fun, time the longer
# running commands.
#
# srun allows to run job steps and diagnose errors with
# sacct and showjob commands

if ( ! -d COMP371_all ) then
  echo "Cloning COMP371_all repo..."
  time srun git clone --depth=1 https://github.com/tiperiu/COMP371_all.git
else
  echo "Found COMP371_all already present; pulling in case of updates..."
  cd COMP371_all
  time srun git pull --rebase --autostash
  cd ..
endif

# We need to be in the raytracer directory
cd COMP371_all/COMP371_RaytracerBase/code
pwd

# Create 'build' if the build folder is absent
if ( ! -d build ) then
  mkdir build
else
  echo "Found build already present"
endif

# Compile
echo "About to build..."
cd build
cmake ../
time srun make

# Run and report
echo "$0 : about to run raytraycer!"
pwd
date
time srun ./raytracer
ls -al *.ppm

# Later in the course when implementations become available:
#ln -s ../assets/cornell_box_al.json
#time srun ./raytracer cornell_box_al.json

echo "$0 : Done!"
date

# EOF
