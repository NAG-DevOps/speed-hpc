
This directory has example job scripts and some tips and tricks on how to
run certcain things.

<!-- TOC start -->
# Table of Contents 
- [Table of Contents](#table-of-contents)
- [Sample Jobs](#sample-jobs)
- [Creating Virtual Environments](#creating-virtual-environments)
  - [Procedure](#procedure)
  - [Environments](#environments)
    - [Anaconda](#anaconda)
    - [Python](#python)
  - [Environment Variables](#environment-variables)
      - [pip](#pip)
    - [efficientdet](#efficientdet)
  - [Diviner Tools](#diviner-tools)
  - [OpenFoam-multinode](#openfoam-multinode)
  - [OpenISS-yolov3](#openiss-yolov3)
    - [Prerequisites](#prerequisites)
      - [Images and Videos](#images-and-videos)
      - [YOLOv3 Weights](#yolov3-weights)
      - [Environment Setup](#environment-setup)
    - [Configuration and execution](#configuration-and-execution)
      - [Run Non-interactive Script](#run-non-interactive-script)
      - [Run Interactive Script](#run-interactive-script)
    - [Performance comparison](#performance-comparison)
  - [OpenISS Person Re-Identification Baseline](#openiss-person-re-identification-baseline)
    - [Prerequisites](#prerequisites-1)
      - [Dataset](#dataset)
      - [Environment Setup](#environment-setup-1)
    - [Configuration and execution](#configuration-and-execution-1)
  - [CUDA](#cuda)
    - [Special Notes for sending CUDA jobs to the GPU Partition (`pg`)](#special-notes-for-sending-cuda-jobs-to-the-gpu-partition-pg)
    - [Jupyter notebook example: Jupyter-Pytorch-CUDA](#jupyter-notebook-example-jupyter-pytorch-cuda)
  - [Python Modules](#python-modules)
<!-- TOC end -->

<!-- TOC --><a name="sample-jobs"></a>
# Sample Jobs

This directory contains a range of job script examples. Some are basic, while others showcase advanced or research-specific workflows. Many are discussed in more detail in the Speed [Manual](https://nag-devops.github.io/speed-hpc/), and others are included here to complement it. They were created by the Speed team, contributed by users, or developed as solutions to specific problems.

- Basic Examples:
  - `bash.sh` -- Batch job script using the `bash` shell.
  - `tcsh.sh` -- Batch job script using the default `tcsh` shell.
  - `tmpdir.sh` -- Demonstrates use of `TMPDIR` on a local node.
  - `manual.sh` -- Builds the Speed manual (PDF and HTML) using LaTeX.
  - `env.sh` -- Prints job environment variables for debugging.
  - `poppler/` -- Interactive job example for PDF rendering using poppler and pdf2image. Includes instructions, setup script `poppler.sh`, python code, and example pdf.

- Common Software Packages:
  - `comsol.sh` -- Job script for COMSOL Multiphysics.
  - `fluent.sh` -- Example job for ANSYS Fluent.
  - `matlab/` -- Incluses batch job for MATLAB.
  - `vscode/` -- Incluses instructions on how to run VS Code both locally and as a web-based version.

- Research & Advanced Examples:
  - `efficientdet.sh` -- Runs EfficientDet model using a Conda environment.
  - `gurobi-with-python.sh` -- Uses Gurobi with a Python virtual environment.
  - `lambdal-singularity.sh` -- Uses Singularity container to run LambdaLabs software stack on GPU node. Based on this github repo [Lambda Stack Dockerfiles](https://github.com/NAG-DevOps/lambda-stack-dockerfiles).
  - `msfp-speed-job.sh` -- MAC Spoofer analysis script (see more detailes [here](https://dx.doi.org/10.1145/2641483.2641540) and [here](https://dx.doi.org/10.1007/978-3-319-17040-4_11))
  - `openfoam-multinode.sh` -- Runs OpenFOAM’s icoFoam solver across multiple CPU nodes.
  - `openiss-reid-speed.sh` -- OpenISS for person re-identification. See more [here](https://github.com/NAG-DevOps/speed-hpc/tree/master/src#openiss-reid-tfk).
  - `openiss-yolo-speed.sh`, and `openiss-yolo-interactive.sh` -- OpenISS + YOLO demos; more [here](https://github.com/NAG-DevOps/speed-hpc/tree/master/src#openiss-yolov3).
  - `pytorch-multinode-multigpu.sh` -- Using Pytorch with Python virtual environment to run on multiple GPUs and nodes.

  - `gpaw/` -- Example job scrits for GPAW simulaptions.
  - `jupyter/` -- Hands-on examples for launching JupyterLab using Conda.
  - `llm-examples/` -- Examples for running Large Language Models (LLMs) such as LLaMA or BERT.
  - `pytorch-multicpu/` -- Using Pytorch with Python virtual environment to run on CPUs.
  - `single-job-multi-mig/` -- Demonstrates how to run a single job using multiple MIGs (Multi-Instance GPU).
  
<!-- TOC --><a name="creating-environments"></a>
# Creating Virtual Environments

<!-- TOC --><a name="procedure"></a>
## Procedure
- Do not compile or create environments on `speed-submit{1|2}`

   These are tiny virtual machines intended for job submission only and lack GPU drivers. All work/processes running outside the scheduler will be terminated.

- Start an Interactive session with `salloc` (e.g., `salloc -p pg --gpus=1`)
- Create and activate your environment

   Use `/speed-scratch/$USER` for all environments.

- Compile and test your code within the environment. Once done, exit your `salloc` session.

- Prepare a job script (refer [Job Submission Basics](https://nag-devops.github.io/speed-hpc/#job-submission-basics))

   Use [Job Script Generator](nag-devops.github.io/speed-hpc/generator.html), and make sure you activate your environment and specify the correct resources.

- Submit your job with `sbatch`

<!-- TOC --><a name="environments"></a>
## Environments
The following documentation is specific to **Speed**.

<!-- TOC --><a name="anaconda"></a>
### Anaconda
- **List available modules for Anaconda and load the required version**.
   ```  
   module avail anaconda
   module load anaconda3/2023.03/default
   ```

- **Initialize Conda for your shell** (only done once) **and source it** (or log out and log back in)
   ```
   conda init tcsh
   source ~/.tcshrc
   ```
   The default shell for ENCS accounts is tcsh.

- **Start an interactive session**
   ```
   # For CPU-based environments
   salloc --mem=20G

   # For GPU-based environments
   salloc --mem=20G --gpus=1
   ```

- **Create anaconda environment** (Once per project)

   It is recommended to install the environment in the `/speed-scratch/$USER` directory to avoid quota issues (default conda creates the environment in your home directory), thus we use the `-p` or `--prefix`.
   ```
   conda create -p /speed-scratch/$USER/<env_name> -y
   ```
   `$USER` is a parameter, either replace it by your ENCS username or the system will automatically do the work.

   **NOTE** If you don't want to use the `--prefix` option everytime you create a new environment and you don't want to use the default `$HOME` directory, create a new directory and set CONDA_ENVS_PATH and CONDA_PKGS_DIRS variables to point to the new created directory, e.g:
   ```
   setenv CONDA_ENVS_PATH /speed-scratch/$USER/condas
   setenv CONDA_PKGS_DIRS /speed-scratch/$USER/condas/pkg
   ```
   If you want to make these changes permanent, add the variables to your .tcshrc or .bashrc (depending on the default shell you are using).

- Activate the environment
   ```
   conda activate /speed-scratch/$USER/<env_name>
   ```
   After activating the environment, install the required packages for your environment with `conda install` or `pip install`.

- Verify and list your conda environments
   ```
   conda info --envs
   # conda environments:
   #
   base                 *  /encs/pkg/anaconda3-2023.03/root
                           /speed-scratch/$USER/<env_name>
   ```

- Deactivate the environment
   ```
   conda deactivate
   ```

- To delete/remove the environment (if no longer needed)
   ```
   conda env remove -p /speed-scratch/$USER/<env_name>
   conda clean --all --yes
   ```

   To resolve "Disk Quota Error", check https://nag-devops.github.io/speed-hpc/#how-to-resolve-disk-quota-exceeded-errors

<!-- TOC --><a name="python"></a>
### Python



**Important Note:** pip (and pip3) are used to install modules from the python distribution while `conda install` installs modules from anaconda's repository.


On the node where the interactive session is running:
```
setenv TMPDIR /speed-scratch/$USER/tmp
setenv TMP /speed-scratch/$USER/tmp
module load anaconda3/2023.03/default
setenv CONDA_PKGS_DIRS $TMP/pkgs
conda create -p $TMP/Venv-Name python==3.11
conda activate $TMP/Venv-Name
```


<!-- TOC --><a name="environment-variables"></a>
## Environment Variables
#### pip

By default, `pip` installs packages to a system-wide default location.

Creating environments via `pip` shound NOT be done outside of an Anaconda environment.

Why you should create an Anaconda environment and not use pip directly from the 
command line:
- Using pip directly from the command line affects the system wide environment. If all users
use pip in this way, the packages and versions installed via pip may change while your jobs run.
- Creating Anaconda environments allows you to fully control what python packages, and their versions, are within that environment.
- It is possible to create multiple conda environments for your different projects.

<!-- TOC --><a name="efficientdet"></a>
### efficientdet

The following steps describing how to create an efficientdet environment on speed, were submitted by a member of Dr. Amer's Research Group.

* Enter your ENCS user account's speed-scratch directory `cd /speed-scratch/$USER`
* load python `module load python/3.8.3`
* create virtual environment `python3 -m venv my_env_name`
* activate virtual environment `source my_env_name/bin/activate.csh`
* install DL packages for Efficientdet
```python
pip install tensorflow==2.7.0
pip install lxml>=4.6.1
pip install absl-py>=0.10.0
pip install matplotlib>=3.0.3
pip install numpy>=1.19.4
pip install Pillow>=6.0.0
pip install PyYAML>=5.1
pip install six>=1.15.0
pip install tensorflow-addons>=0.12
pip install tensorflow-hub>=0.11
pip install neural-structured-learning>=1.3.1
pip install tensorflow-model-optimization>=0.5
pip install Cython>=0.29.13
pip install git+https://github.com/cocodataset/cocoapi.git#subdirectory=PythonAPI
```

<!-- TOC --><a name="diviner-tools"></a>
## Diviner Tools

[Diviner Tools](https://github.com/d-chante/diviner-tools) is a custom library for pre-processing Diviner RDR LVL1 Channel 7 data by [Chantelle Dubois](https://github.com/d-chante).

- [Speed-related scripts](https://github.com/d-chante/diviner-tools/tree/development/jobs/speed)

<!-- TOC --><a name="openfoam-multinode"></a>
## OpenFoam-multinode

This example is taken from OpenFoam tutorials section: $FOAM_TUTORIALS/incompressible/icoFoam/cavity/cavity
1. Go to your speed-scratch directory: `cd /speed-scratch/$USER`
2. open a salloc session
3. Load OpenFoam module: `module load OpenFOAM/v2306/default`
4. Copy the cavity example to your speed-scratch space: `cp -r $FOAM_TUTORIALS/incompressible/icoFoam/cavity/cavity/ .`
5. Modify cavity/system/decomposeParDict: 
   Remove coeffs section and modify the following:
         numberOfSubdomains  10;
         method  scotch;
6. Exit the salloc session, go to the cavity directory and run the script: `sbatch --mem=10Gb -pps --constraint=el9 openfoam-multinode.sh`

<!-- TOC --><a id="openiss-yolov3"></a>
## OpenISS-yolov3

This is a case study example on image classification, for more details please visit [OpenISS keras-yolo3](https://github.com/NAG-DevOps/openiss-yolov3).

<!-- TOC --><a id="prerequisites-openiss-yolov3"></a>
### Prerequisites

   #### Images and Videos
   Images and videos can be from any source, but a sample video and images are provided in `video` and `image` folders in the [OpenISS-YOLOv3 Github repository](https://github.com/NAG-DevOps/openiss-yolov3).

   #### YOLOv3 Weights
   The YOLOv3 weights can be downloaded from [YOLO website](http://pjreddie.com/darknet/yolo/). However the script provided includes a command to `wget` the weights from the link above.

   #### Environment Setup
   To set up the virtual development environment, refer to section 2.11 of the Speed manual [Creating Virtual Environments](https://nag-devops.github.io/speed-hpc/#anaconda) for detailed information.

<!-- TOC --><a id="configuration-and-execution-openiss-yolov3"></a>
### Configuration and execution
- Log into SPEED and navigate to your `speed-scratch` directory:

      ssh $USER@speed.encs.concordia.ca
      cd /speed-scratch/$USER/

   **Note**: To see a live video in an interactive session, enable X11 forwarding. Linux can run X11, however, to run X server on:
	- Windows: use MobaXterm or Putty
	- MacOS: use XQuarz with its xterm

   For more information refer to [How to Launch X11 applications](https://www.concordia.ca/ginacody/aits/support/faq/xserver.html)

- Clone the [OpenISS-YOLOv3 Github repository](https://github.com/NAG-DevOps/openiss-yolov3)

      git clone --depth=1 https://github.com/NAG-DevOps/openiss-yolov3.git
      cd /speed-scratch/$USER/openiss-yolov3

<!-- TOC --><a id="run-non-interactive-openiss-yolov3"></a>
#### Run Non-interactive Script 
   - Download and run `openiss-yolo-speed.sh` script from [Speed-HPC Github repository](https://github.com/NAG-DevOps/speed-hpc/tree/master/src).

         sbatch ./openiss-yolo-speed.sh

The script performs the following:
   - Configures job resources and paths for Conda environments.
   - Creates, or activates the Conda environment, and installs required packages if necessary.
   - Downloads YOLOv3 weights.
   - Converts the Darknet YOLO model to Keras format.      
   - Runs YOLO inference on a sample video.
   - Deactivates the Conda environment and exits.

<!-- TOC --><a id="run-interactive-openiss-yolov3"></a>
#### Run Interactive Script
   *Note* To run interactive job we need to use `ssh -X`
   - Request resources with `salloc` command

         salloc --x11=first --mem=60G -n 32 --gpus=1 -p pt

   - Download and run `openiss-yolo-interactive.sh` script from [Speed-HPC Github repository](https://github.com/NAG-DevOps/speed-hpc/tree/master/src). You need to add permission access to the project files.

         chmod u+x *.sh 
         ./openiss-yolo-interactive.sh

   - A pop up window will show a classifed live video. 

The script does the following:
   - Prepare and create Conda environment based on `environment.yml`
   - Download YOLOv3 Weights
   - Convert the Darknet YOLO model into a Keras model using `convert.py`
   - Run YOLO inference on a sample video in an intaractive mode

**Note**: If you need to delete the created virtual environment

      conda deactivate
      conda env remove -p /speed-scratch/$USER/envs/yolo_env

   For Tiny YOLOv3, it can be run in the same way, but you will need to specify model path and anchor path with `--model model_file` and `--anchors anchor_file`.

<!-- TOC --><a name="performance-comparison-openiss-yolov3"></a>
### Performance comparison

Time is in minutes, run Yolo with different hardware configurations GPU types V100 and Tesla P6. Please note that there is an issue to run Yolo project on more than one GPU in case of tesla P6. The project uses keras.utils library calling `multi_gpu_model()` function, which cause hardware faluts and force to restart the server. GPU name for V100 is gpu32, and for P6 is gpu16, you can find that in scripts shell.
|   1GPU-P6     |    1GPU-V100  |    2GPU-V100  |    32CPU       |
| --------------|-------------- |-------------- |----------------|
|    22.45      |   17.15       |   23.33       |     60.42      |
|    22.15      |   17.54       |   23.08       |     60.18      |
|    22.18      |   17.18       |   23.13       |     60.47      |

<!-- TOC --><a name="openiss-reid-tfk"></a>
## OpenISS Person Re-Identification Baseline

The following are the steps required to run the *OpenISS Person Re-Identification Baseline* Project (https://github.com/NAG-DevOps/openiss-reid-tfk) on the *Speed* cluster. This implementatoin is based on tensorflow and keras

<!-- TOC --><a name="prerequisites-openiss-reid"></a>
### Prerequisites

#### Dataset
   Using the Market1501 dataset which consist of 
   - Train images: 12,936
   - Query images: 3,368
   - Gallery images: 15,913

   Running for 10 epochs as an example, the results for different Speed configurations were:
   - Using GPU: 29 minute
   - Using CPUs (32 cores): 6 hours and 49 minute

#### Environment Setup
   The environment setup instructions are located in `environment.yml` (https://github.com/NAG-DevOps/openiss-reid-tfk). Ensure all dependencies are correctly installed.

<!-- TOC --><a name="configuration-and-execution"></a>
### Configuration and execution

- Log into Speed and navigate to your speed-scratch directory:
      
      ssh $USER@speed.encs.concordia.ca
      cd /speed-scratch/$USER/

- Clone the GitHub repo from https://github.com/NAG-DevOps/openiss-reid-tfk

- Download the dataset: Navigate to the `datasets/` directory, make the script executable, and run `get_dataset_market1501.sh`:

      chmod u+x *.sh && ./get_dataset_market1501.sh

- Download `openiss-reid-speed.sh` execution script from this repository.

- In `reid.py` set the number of epochs (`g_epochs=120` by default)

- In `environment.yml` comment/uncomment the TensorFlow section depending on whether you are running on CPU or GPU. GPU is enabled by default.

- In `openiss-reid-speed.sh` comment/uncomment the resource allocation lines for either CPU or GPU, depending on the target node (GPU is default). Ensure that only one type (CPU or GPU) is requested.

- Submit the job:

   For CPU nodes: `sbatch ./openiss-reid-speed.sh`

   For GPU nodes: `sbatch -p pg ./openiss-reid-speed.sh`

<!-- TOC --><a name="cuda"></a>
## CUDA

When calling CUDA within job scripts, it is important to create a link to the desired CUDA libraries and set the runtime link path to the same libraries. For example, to use the `cuda-11.5` libraries, specify the following in your `Makefile`.
```
-L/encs/pkg/cuda-11.5/root/lib64 -Wl,-rpath,/encs/pkg/cuda-11.5/root/lib64
```
In your job script, specify the version of `gcc` to use prior to calling cuda. For example: 
   `module load gcc/8.4`
or
   `module load gcc/9.3`

<!-- TOC --><a name="special-notes-for-sending-cuda-jobs-to-the-gpu-partition-pg"></a>
### Special Notes for sending CUDA jobs to the GPU Partition (`pg`)

Interactive jobs (easier to debug) should be submitted to the **GPU Queue** with `salloc` in order to compile and link CUDA code.

We have several versions of CUDA installed in:
```
/encs/pkg/cuda-11.5/root/
/encs/pkg/cuda-10.2/root/
/encs/pkg/cuda-9.2/root
```

For CUDA to compile properly for the GPU queue, edit your `Makefile` replacing `/usr/local/cuda` with one of the above.

<!-- TOC --><a name="jupyter-example-gpu-pytorch"></a>
### Jupyter notebook example: Jupyter-Pytorch-CUDA

Example prepared to run on speed, extracted from: https://developers.redhat.com/learning/learn:openshift-data-science:configure-jupyter-notebook-use-gpus-aiml-modeling/resource/resources:how-examine-gpu-resources-pytorch

From `speed-submit{1|2}`: 
- Download `gpu-ml-model.ipynb` from this github to your `/speed-scratch/$USER space`
- `salloc --mem=10Gb --gpus=1`

From the node (interactive session):
- `module load singularity/3.10.4/default`
- `srun singularity exec -B $PWD\:/speed-pwd,/speed-scratch/$USER\:/my-speed-scratch,/nettemp --env SHELL=/bin/bash --nv /speed-scratch/nag-public/jupyter-pytorch-cuda.sif /bin/bash -c '/opt/conda/bin/jupyter notebook --no-browser --notebook-dir=/speed-pwd --ip="*" --port=8888 --allow-root'`
- Follow the steps described in: https://nag-devops.github.io/speed-hpc/#jupyter-notebooks
- When Jupyter is running on the browser, open `gpu-ml-model.ipynb` and run each cell

<!-- TOC --><a name="python-modules"></a>
## Python Modules

By default when adding a python module `/tmp` is used for the temporary repository of files downloaded. `/tmp` on speed-submit is too small for pytorch.

To add a python module:

- First create you own tmp directory in /speed-scratch
  - `mkdir /speed-scratch/$USER/tmp`
- Use the tmp direcrtory you created
  - `setenv TMPDIR /speed-scratch/$USER/tmp`
- Attempt the installation of pytorch

Where `$USER` is an environment variable containing your GCS ENCS username
