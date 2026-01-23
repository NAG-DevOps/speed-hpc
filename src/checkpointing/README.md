# Checkpointing on HPC - SPEED

DMTCP: Distributed MultiThreaded Checkpointing, a transparent checkpoint-restart (C/R) tool that can preserve the state of an arbitrary threaded or distributed application to disk for the purpose of resuming it at a later time or in a different location.

#### References:
- [DMTCP](https://dmtcp.sourceforge.io/)
- [DMTCP GitHub](https://https://github.com/dmtcp/dmtcp)

## Instructions
* Copy the file `checkpoint.sh` to your working directory

* Modify the file according to your simulation needs:
   - Disable the output buffering in accordance of the language/script of your simulation (Environment variable or script modification)
     - Python: export PYTHONUNBUFFERED=1
     - C: Modify your script: `fflush(stdout);`
   - Parameters: --time and --signal have to be carefully set-up:
     ```shell
    # --signal and --time have to be set up in accordance with the simulation's size and load
    # Examples: (Referencial values: Change the values to fit the needs of your simulation)
    # Large simulations: These are simulations that require at least 4 days to run and use medium-sized or large datasets
    #                    --time=24:00:00 --signal=B:SIGUSR1@600
    # Very Large simulations: These are simulations that require at least 5 days to run and use big datasets
    #                    --time=24:00:00 --signal=B:SIGUSR1@900
    ```
    - Modify the parameters: Command= and Args=
    ```shell
    COMMAND="python3"          # Your program -- For Python
    ARGS=script.py            # Arguments (or empty) -- .py for Python

    COMMAND="./heavy_simulation" # Example for C, compiled executable
    ARGS=                        # Empty - this C script doesn't need arguments
    ```
* Run the simulation:
      ```shell
      sbatch checkpoint.sh
      ```

* The script will create `job_xxx.out and job_xxx.err` files for each checkpoint.

## Important notes:
* Compatible with the following jobs: Python, C, Go, Rust, Perl, Julia but buffer output has to be disabled
* Not recommendable for GPU/MPI applications, use the native check pointing method for each GPU/MPI application, example:
    - For GPU (PyTorch, TensorFlow, CUDA):
      ```shell
      torch.save(model.state_dict(), 'checkpoint.pt')
      ```
    - For MPI (parallel applications):
      ```shell
      checkpoint(rank, data, size);
      ```