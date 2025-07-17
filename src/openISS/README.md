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
### Configuration and execution

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
Training for 10 epochs, the results for different Speed configurations were:

|      Resource     |      Time      |
| ----------------- | -------------- |
|       1 GPU       |    ~29 mins    |
|      32 CPUs      |  ~6h 49 mins   |