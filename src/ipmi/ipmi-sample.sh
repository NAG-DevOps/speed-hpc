#!/encs/bin/bash

CPU_TEMP_TRESHOLD=50

HOSTTOTEST="magic-node-01"

# Reads an IMPI value off the node via srun and ipmitool
CPU1_TEMP="$(srun -w $HOSTTOTEST -p pm --mem=10M --exact ipmitool sensor | grep 02-CPU | sed 's/ //g' | cut -d'|' -f2)"

echo "CPU1_TEMP=$CPU1_TEMP"

#if [[ $CPU1_TEMP -gt $CPU_TEMP_TRESHOLD ]]; then
if (( $(echo "$CPU1_TEMP > $CPU_TEMP_TRESHOLD" | bc -l) )); then
  echo "$HOSTTOTEST is too hot, $CPU1_TEMP > $CPU_TEMP_TRESHOLD, skipping load..."
  shownode $HOSTTOTEST
else
  echo "$CPU1_TEMP <= $CPU_TEMP_TRESHOLD"
  echo "Allocating some workload..."
  # Assuming the $USER clone the sample repo in /speed-scratch/$USER
  pushd /speed-scratch/$USER/speed-hpc/src/gpaw
    sbatch -p pm -w $HOSTTOTEST gpaw-container-less-constraints.sh
    squeue -la -u $USER
    shownode $HOSTTOTEST
    CPU1_TEMP="$(srun -w $HOSTTOTEST -p pm --mem=10M --exact ipmitool sensor | grep 02-CPU | sed 's/ //g' | cut -d'|' -f2)"
    echo "NOW CPU1_TEMP=$CPU1_TEMP"
  popd
fi

# EOF

