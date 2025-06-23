#!/encs/bin/tcsh

#
# Runs an AMDGPU benchmark
#

#SBATCH -J cl-bench
#SBATCH --mem=50G
#SBATCH -p cl
#SBATCH -n 1
#SBATCH -c 8
#SBATCH -w speed-19
#SBATCH --mail-type=ALL
#SBATCH --gres=gpu:amdgpu:1
#SBATCH --constraint=amdgpu

echo "cl-bench START"
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

set REPO = "amd-gpu-benchmark"
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
rocm-smi -a

echo "$0 clinfo..."
date
/opt/amdgpu-pro/bin/clinfo

echo "$0 compiling..."
date
pushd $REPO
  module load gcc/7.3/default
  which gcc
  gcc -v
  set CC = `which gcc`
  set CCX = `which g++`
  make  
popd

echo "$0 cl-info"
date
time srun ./$REPO/cl-info

echo "$0 main"
date
time srun ./$REPO/main
#srun strace ./$REPO/main
#strace ./$REPO/main

echo "$0 main-cpu"
date
time srun ./$REPO/main-cpu

date
echo "cl-bench DONE"
