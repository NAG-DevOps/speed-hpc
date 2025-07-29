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
```
ssh $USER@speed.encs.concordia.ca
cd /speed-scratch/$USER/
```

- Clone the project [GitHub repo](https://github.com/NAG-DevOps/openiss-reid-tfk)

- Navigate to the `datasets/` directory to download the dataset, make the script `get_dataset_market1501.sh` executable, and run it:
```
chmod u+x *.sh && ./get_dataset_market1501.sh
```

- Download `openiss-reid-speed.sh` execution script from Speed [repository](https://github.com/NAG-DevOps/speed-hpc/tree/master/src/openISS)

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
## OpenISS-yolov3

This is a case study example on image classification.

**Project repo**: [OpenISS keras-yolo3](https://github.com/NAG-DevOps/openiss-yolov3).

<!-- TOC --><a name="prerequisites-openiss-yolov3"></a>
### Prerequisites
- **Images and Videos:**
  
  Images and videos can be from any source, but a sample video and images are provided in `video` and `image` folders in the [OpenISS-YOLOv3 Github repository](https://github.com/NAG-DevOps/openiss-yolov3).

- **Images and Videos:**

  The YOLOv3 weights can be downloaded from [YOLO website](http://pjreddie.com/darknet/yolo/). However the script provided includes a command to `wget` the weights from the link above.

- **Environment Setup:**

  To set up the virtual development environment, refer to the Speed manual [Creating Virtual Environments](https://nag-devops.github.io/speed-hpc/#anaconda) for detailed information.

  <!-- TOC --><a name="configuration-and-execution-openiss-yolov3"></a>
### Configuration and Execution
- Log into Speed and navigate to your speed-scratch directory:
```
ssh $USER@speed.encs.concordia.ca
cd /speed-scratch/$USER/
```
  **Note**: To see a live video in an interactive session, enable X11 forwarding. Linux can run X11, however, to run X server on:

  - Windows: use MobaXterm or Putty
  - MacOS: use XQuarz with its xterm

  For more information refer to [How to Launch X11 applications](https://www.concordia.ca/ginacody/aits/support/faq/xserver.html)

- Clone the [GitHub repo](https://github.com/NAG-DevOps/openiss-yolov3)

<!-- TOC --><a id="run-non-interactive-openiss-yolov3"></a>
#### Run Non-interactive Script 

- Download and run `openiss-yolo-speed.sh` execution script from [Speed-HPC Github repository](https://github.com/NAG-DevOps/speed-hpc/tree/master/src/openISS)
```
sbatch ./openiss-yolo-speed.sh
```

The script performs the following:
   - Configures job resources and paths for Conda environments.
   - Creates, or activates the Conda environment, and installs required packages if necessary.
   - Downloads YOLOv3 weights.
   - Converts the Darknet YOLO model to Keras format.      
   - Runs YOLO inference on a sample video.
   - Deactivates the Conda environment and exits.