<!-- TOC --><a name="README"></a>
# One Job With Multiple MIG Devices - SAME NODE

This document only shows how to run multiple independent CUDA processes in a single slurm job. Distributed training with pytorch, tensorflow or any other common ML/DL framework is not currently possible using MIG devices

* We will use 2 MIGs:

        --gres=gpu:nvidia_a100_2g.20gb:2

* We will execute the program `gpu_burn` twice in the background (`./gpu_burn -d 60 &`), one for each MIG.
* The job will be executed until the processes in the background finish. (`# wait for all pids` section)

<!-- TOC end -->