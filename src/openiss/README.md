# OpenISS Examples on SPEED HPC

This folder contains example scripts to run **OpenISS** case studies on the SPEED HPC cluster at Concordia University.

<!-- TOC --><a name="openiss-reid-tfk"></a>
## OpenISS Person Re-Identification
Case study on re-identifying persons using deep learning.

**Project repo**: [openiss-reid-tfk](https://github.com/NAG-DevOps/openiss-reid-tfk)

<!-- TOC --><a name="prerequisites-openiss-reid"></a>
### Prerequisites

- **Dataset:** `Market1501`
   - Train images: 12,936
   - Query images: 3,368
   - Gallery images: 15,913

- **Environment Setup:**
  
    Use `environment.yml` for dependencies, the file is located [here](https://github.com/NAG-DevOps/openiss-reid-tfk)

<!-- TOC --><a name="configuration-and-execution-openiss-reid"></a>
### Configuration and Execution

- Log into Speed and navigate to your speed-scratch directory:
```shell
ssh $USER@speed.encs.concordia.ca
cd /speed-scratch/$USER/
```

- Clone [openiss-reid-tfk](https://github.com/NAG-DevOps/openiss-reid-tfk) GitHub repo

- Navigate to the `datasets/` directory to download the dataset, make the script `get_dataset_market1501.sh` executable, and run it:
```
chmod u+x *.sh && ./get_dataset_market1501.sh
```

- Download `openiss-reid-speed.sh` execution script from [this repository](https://github.com/NAG-DevOps/speed-hpc/tree/master/src/openiss)

- Adjust the files as needed
  - In `reid.py` set the number of epochs (`g_epochs=120` by default)
  - In `environment.yml` comment/uncomment the TensorFlow section depending on whether you are running on CPU or GPU. GPU is enabled by default.
  - In `openiss-reid-speed.sh` comment/uncomment the resource allocation lines for either CPU or GPU, depending on the target node (GPU is default). Ensure that only one type (CPU or GPU) is requested.

- Submit the job:

    For GPU nodes: `sbatch -p pg ./openiss-reid-speed.sh`
    
    For CPU nodes: `sbatch ./openiss-reid-speed.sh`

<!-- TOC --><a name="performance-openiss-reid"></a>
### Performance
Training for 120 epochs, the results for different Speed configurations were:

|      Resource     |      Time      |
| ----------------- | -------------- |
|       1 GPU       |  ~5h 25 mins   |
|      32 CPUs      |  ~55h 7 mins   |

<!-- TOC --><a id="openiss-yolov3"></a>
## OpenISS keras-yolo3

This is a case study example on image classification.

**Project repo**: [openiss-yolov3](https://github.com/NAG-DevOps/openiss-yolov3)

<!-- TOC --><a name="prerequisites-openiss-yolov3"></a>
### Prerequisites

- **Images and Videos:**
  
    Images and videos can be from any source, but a sample video and images are provided in `video` and `image` folders [here](https://github.com/NAG-DevOps/openiss-yolov3).

- **YOLOv3 weights:**
  
    The YOLOv3 weights can be downloaded from [YOLO website](http://pjreddie.com/darknet/yolo/). However the script provided includes a command to `wget` the weights from the link above.

- **Environment Setup:**

    The script provided includes a Conda environment creation, however, refer to the Speed manual [Creating Virtual Environments](https://nag-devops.github.io/speed-hpc/#anaconda) for detailed information.

<!-- TOC --><a name="configuration-and-execution-openiss-yolov3"></a>
### Configuration and Execution

- Log into Speed and navigate to your speed-scratch directory:
```shell
ssh $USER@speed.encs.concordia.ca
cd /speed-scratch/$USER/
```

**Note**: To see a live video in an interactive session, enable X11 forwarding. Linux can run X11, however, use MobaXterm or Putty on Windows and XQuarz on MacOS.

- Clone [openiss-yolov3](https://github.com/NAG-DevOps/openiss-yolov3) GitHub repo

<!-- TOC --><a id="run-non-interactive-openiss-yolov3"></a>
#### Run Non-interactive Script 

- Download and run `openiss-yolo-speed.sh` execution script from [this repository](https://github.com/NAG-DevOps/speed-hpc/tree/master/src/openiss)

```shell
sbatch ./openiss-yolo-speed.sh
```

The script performs the following:
- Configures job resources and paths for Conda environments.
- Creates, or activates the Conda environment, and installs required packages if necessary.
- Downloads YOLOv3 weights.
- Converts the Darknet YOLO model to Keras format.      
- Runs YOLO inference on a sample video.
- Deactivates the Conda environment.

<!-- TOC --><a id="run-interactive-openiss-yolov3"></a>
#### Run Interactive Script

**Note:** To run interactive job, use `ssh -X` or `ssh -Y`.

- Request resources with `salloc` command
```shell
salloc --mem=8G -n 1 --cpus-per-task=8 --gpus=1 --x11=first
```

- Download and run `openiss-yolo-interactive.sh` execution script from [this repository](https://github.com/NAG-DevOps/speed-hpc/tree/master/src/openiss)
```shell
./openiss-yolo-interactive.sh
```

- A pop up window will show a classifed live video. 

For Tiny YOLOv3, it can be run in the same way, but you will need to specify model path and anchor path with `--model model_file` and `--anchors anchor_file`.