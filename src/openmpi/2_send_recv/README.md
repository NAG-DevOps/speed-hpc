# 2. Send and Receive

## Description

This is a basic MPI program where rank 0 (the root) sends a number to every other process using `MPI_Send`, and each process receives it with `MPI_Recv`.

## Building

This is built using CMake. The job script `mpi_send_recv.sh` loads the required modules, builds the program, and runs it on 4 nodes with 1 process per node, using `srun`.

## Running

From this folder, submit the job:
```
sbatch mpi_send_recv.sh
```

The output is written to `slurm-<jobid>.out` in this folder. Each line starts with the rank that printed it:
```
0: [ROOT:0] This is rank 0 running on speed-25.encs.concordia.ca!
0: [ROOT:0] sending to 1...
1: [Rank:1] This is rank 1 running on speed-37.encs.concordia.ca!
1: [Rank:1] Received 1 from ROOT!
...
```
