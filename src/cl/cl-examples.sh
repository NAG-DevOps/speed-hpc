#!/encs/bin/tcsh

#
# Runs a set of OpenCL examples from a repo
#

#SBATCH -J cl-examples
#SBATCH --mem=50G
#SBATCH -p cl
#SBATCH -n 1
#SBATCH -c 8
#SBATCH -w speed-19
#SBATCH --mail-type=ALL
#SBATCH --gres=gpu:amdgpu:1
#SBATCH --constraint=amdgpu

echo "cl-examples START"
date

if (! $?SLURM_JOB_ID ) then
  echo "Did not detect Slurm job ID... running on"
  hostname
  echo "Will spin a job to a compute node..."
  sbatch $0
  exit 0
else
  echo -n "Running on "
  hostname
endif

set REPO = "opencl-examples"
set GHBASE = "https://github.com/NAG-DevOps"

if ( ! -d $REPO ) then
  echo "Cloning $REPO repo..."
  time srun git clone --depth=1 "$GHBASE"/"$REPO".git
else
  echo "Found $REPO already present; pulling in case of updates..."
  pushd $REPO
    time srun git pull --rebase --autostash
  popd
endif

echo "$0 rocm-smi..."
date
#rocm-smi -a

echo "$0 clinfo..."
date
#/opt/amdgpu-pro/bin/clinfo

echo "$0 compiling and running..."
date
pushd $REPO
  module load gcc/7.3/default
  which gcc
  gcc -v
  set CC = `which gcc`
  set CCX = `which g++`

  foreach example ( \
      add_numbers \
      Hello_World \
      mandelbrot \
      square_array \
      sum_array \
      waste \
      )
    pushd $example
      date
      pwd
      time srun make run  
    popd
  end
popd

date
echo "cl-examples DONE"
