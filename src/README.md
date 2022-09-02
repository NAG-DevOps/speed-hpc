# Environments #
Speed: Gina Cody School HPC Facility: Virtual Environment Creation documentation

The following documentation is specific to **speed**.

## Anaconda ##

### Create an Environment ###
To create an anaconda environment in your speed-scratch directory, use the `--prefix` option when executing `conda create`. 

For example:
`conda create --prefix /speed-scratch/<encs_username>/myconda`

Without the `--prefix` option, `conda create` creates the environment in your home directory by default.

### List Environments ###
To view your conda environments, type 
`conda info --envs`

```
# conda environments:
#
base                  *  /encs/pkg/anaconda3-2019.07/root
                         /speed-scratch/<encs_username>/myconda
```                 

### Activate an Environment ###
Activate the environment `/speed-scratch/<encs_username>/myconda` as follows

`conda activate /speed-scratch/<encs_username>/myconda`

After activating your environment, add pip to your environment by using 

`conda install pip`

This will install pip and pip's dependencies, including python.

**Important Note:** pip (and pip3) are used to install modules from the python distribution while `conda install` installs modules from anaconda's repository.

## efficientdet ##

The following steps describing how to create an efficientdet environment on speed, were submitted by a member of Dr. Amer's Research Group.

* Enter your ENCS user account's speed-scratch directory `cd /speed-scratch/<encs_username>`
* load python `module load python/3.8.3`
* create virtual environment `python3 -m venv <env_name>`
* activate virtual environment `source <env_name>/bin/activate.csh`
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
## Openiss-yolov3 
This is a case study example on image classification, for more details please visit [Openiss-yolov3](https://github.com/tariqghd/speed-hpc).

### Speed Login Configuration 
1. As an interactive option is supported that show live video, you will need to enable ssh login with -X support. Please check this [link](https://www.concordia.ca/ginacody/aits/support/faq/xserver.html) to do that.
2. If you didn't know how to login to speed and prepare the working environment please check the manual in the follwing [link](https://github.com/NAG-DevOps/speed-hpc/blob/master/doc/speed-manual.pdf) section 2.

After you logged in to speed change your working directory to `/speed-scratch/$USER` diectory.
```
cd /speed-scratch/$USER/
```

### Speed Setup and Development Environment Preperation
The pre-requisites to prepare the virtual development environment using anaconda is explained in [speed manual](https://github.com/NAG-DevOps/speed-hpc/blob/master/doc/speed-manual.pdf) section 3, please check that for more inforamtion.
1. Make sure you are in speed-scratch directory. Then Download Yolo project from [Github website](https://github.com/tariqghd/openiss-yolov3) to your speed-scratch proper diectory. 
```
cd /speed-scratch/$USER/
git clone https://github.com/tariqghd/openiss-yolov3.git
```
2. Starting by loading anaconda module 
```
module load anaconda/default
```
3. Switch to the project directoy. Create anaconda virtual environment, and configure development librires. The name of the environment can by any name here as an example named YOLO. Activate the conda environment YOLOInteractive.
```
cd /speed-scratch/$USER/openiss-yolov3
conda create -p /speed-scratch/$USER/YOLO
conda activate /speed-scratch/$USER/YOLO
```
4. Install all required librires you need and upgrade pip to install opencv-contrib-python library 

```
conda install python=3.5
conda install Keras=2.1.5
conda install Pillow
conda install matplotlib
conda install -c menpo opencv
pip install --upgrade pip 
pip install opencv-contrib-python
```

5. Validate conda environemnt and installed packeges using following commands. Make sure the version of python and keras are same as requred.
```
conda info --env
conda list
```
if you need to delete the created virtual environment 
```
conda deactivate
conda env remove -p /speed-scratch/$USER/YOLO
```
### Run Interactive Script 
File `yolo_submit.sh` is the speed script to run video example to run it you follow these steps:
1. Run interactive job we need to keep `ssh -X` option enabled and `xming` server in your windows  working. 
2. The `qsub` is not the proper command since we have to keep direct ssh connection to the computational node, so `qlogin` will be used. 
3. Enter `qlogin` in the `speed-submit`. The `qlogin` will find an approriate  computational node then it will allow you to have direct `ssh -X' login to that node. Make sure you are in the right directory and activate conda environment again.

```
qlogin 
cd /speed-scratch/$USER/openiss-yolov3
conda activate /speed-scratch/$USER/YOLO
```
4. Before you run the script you need to add permission access to the project files, then start run the script `./yolo_submit.sh`    
```
chmod +rwx *
./yolo_submit.sh
```
5. A pop up window will show a classifed live video. 

Please note that since we have limited number of node with GPU support `qlogin` is not allowed to direct you to login to these server you will be directed to the availabel computation nodes in the cluster with CPU support only. 

### Run Non-interactive Script 
Before you run the script you need to add permission access to the project files using `chmod` command.   
```
chmod +rwx *
```
To run the script you will use `qsub`, you can run the task on CPU or gpu computation node as follwoing:
1. For CPU nodes use `yolo_subCPU.sh` file 
```
 qsub ./yolo_subCPU.sh
```

2. For GPU nodes use `yolo_subGPU.sh` file with option -q to specify only gpu queue (g.q) submission.
```
qsub -q g.q ./yolo_subGPU.sh
```

## CUDA ##

When calling CUDA within job scripts, it is important to create a link to the desired CUDA libraries and set the runtime link path to the same libraries. For example, to use the cuda-11.5 libraries, specify the following in your Makefile.
```
-L/encs/pkg/cuda-11.5/root/lib64 -Wl,-rpath,/encs/pkg/cuda-11.5/root/lib64
```
In your job script, specify the version of `gcc` to use prior to calling cuda. For example: 
   `module load gcc/8.4`
or
   `module load gcc/9.3`
 
  
### Special Notes for sending CUDA jobs to the GPU Queue(`g.q`) ###

It is not possible to create an interactive `qlogin` session to **GPU Queue** (`g.q`) nodes. As direct login to these nodes is not available, batch jobs must be submitted to the **GPU Queue** with `qsub` in order to compile and link.

We have several versions of CUDA installed in:
```
/encs/pkg/cuda-11.5/root/
/encs/pkg/cuda-10.2/root/
/encs/pkg/cuda-9.2/root
```

For CUDA to compile properly for the GPU queue, edit your Makefile replacing `/usr/local/cuda` with one of the above.
