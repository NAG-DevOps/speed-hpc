#!/encs/bin/bash
#SBATCH --job-name=checkpoint_job
#SBATCH --output=job_%j.out
#SBATCH --error=job_%j.err
#SBATCH --open-mode=append
#SBATCH --time=00:05:00              # 5 minute time limit for testing
#SBATCH --signal=B:SIGUSR1@60        # Signal 60 seconds before timeout
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=1G
# See README for more information (https://github.com/NAG-DevOps/speed-hpc/tree/master/src/checkpointing)
#SBATCH --constraint=avx512```

#########################################################################################
# --signal and --time have to be set up in accordance with the simulation's size and load
# Examples: (Referencial values: Change the values to fit the needs of your simulation)
# Large simulations: These are simulations that require at least 4 days to run and use medium-sized or large datasets
#                    --time=24:00:00 --signal=B:SIGUSR1@600
# Very Large simulations: These are simulations that require at least 5 days to run and use big datasets
#                    --time=24:00:00 --signal=B:SIGUSR1@900
# --constraint: DMTCP needs to run on nodes that have same architecture, SPEED has nodes with different architecture
#               so far, avx, avx2, avx512 and AMD (see README for more information)
#########################################################################################

. /encs/pkg/modules-5.3.1/root/init/bash

module load GCCcore/14.2.0
module load DMTCP/4.0.0
module load python/3.12.0/default

# CONFIGURATION - MODIFY THESE
COMMAND="python3"
ARGS=pythonjob.py
CHECKPOINT_INTERVAL=0  

# Setup
CHECKPOINT_DIR="${SLURM_SUBMIT_DIR}/checkpoint_${SLURM_JOB_NAME}"
COORD_PORT=7779

# Logging function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [Job ${SLURM_JOB_ID}] $@"
}

log "Job starting on node ${SLURMD_NODENAME}"
cd "${SLURM_SUBMIT_DIR}"

# Signal handler for timeout
handle_timeout() {
    log "Time limit approaching - creating checkpoint..."
    dmtcp_command --bcheckpoint
    sleep 10  # Wait for checkpoint to complete
    log "Checkpoint complete"

    dmtcp_command -q
    log "Requeueing job..."
    sbatch "${BASH_SOURCE[0]}"

    exit 0
}

trap handle_timeout SIGUSR1

# Setup DMTCP environment
export DMTCP_CHECKPOINT_DIR="${CHECKPOINT_DIR}"
export DMTCP_COORD_PORT="${COORD_PORT}"
export DMTCP_COORD_HOST="$(hostname)"

# Start coordinator
dmtcp_coordinator --daemon --port ${COORD_PORT} --exit-on-last > /dev/null 2>&1
sleep 2

# Create checkpoint directory if needed
mkdir -p "${CHECKPOINT_DIR}"

# Check for restart script
RESTART_SCRIPT="${CHECKPOINT_DIR}/dmtcp_restart_script.sh"

if [ -f "${RESTART_SCRIPT}" ]; then
    log "Resuming from checkpoint"
    ${RESTART_SCRIPT} &
    wait

else
    log "Starting fresh"

    # Launch application with DMTCP
        dmtcp_launch --join-coordinator \
                     --interval ${CHECKPOINT_INTERVAL} \
                     ${COMMAND} ${ARGS} &
    wait
fi

EXIT_CODE=$?
log "Job completed with exit code ${EXIT_CODE}"

# Clean up if successful
if [ ${EXIT_CODE} -eq 0 ]; then
    log "Cleaning up checkpoints"
    rm -rf "${CHECKPOINT_DIR}"
fi

exit ${EXIT_CODE}
