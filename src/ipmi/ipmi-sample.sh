#!/encs/bin/bash

# Sample sensor reader
#
# Assumes execution on speed-submit hosts:
#  queries for an IMPI sensor value on each specified hosts as an srun task
#  submits (or not) an sbatch heavy job if the value is below a treshold

CPU_TEMP_TRESHOLD=50

# magic-node-[01-10] are in pm
for host in magic-node-01 magic-node-02 magic-node-03 ; do

  HOSTTOTEST="$host"

  echo "Processing $HOSTTOTEST"
  shownode $HOSTTOTEST

  # Reads an IMPI value off the node via srun and ipmitool
  CPU1_TEMP="$(srun -w $HOSTTOTEST -p pm --mem=10M --exact ipmitool sensor | grep 02-CPU | sed 's/ //g' | cut -d'|' -f2)"

  echo "CPU1_TEMP=$CPU1_TEMP"

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

done

date
echo "$0: done"

# EOF

