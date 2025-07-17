#!/encs/bin/tcsh

#SBATCH --job-name openiss-yolo
#SBATCH --mail-type=ALL
#SBATCH --chdir=./
#SBATCH -o output-%A.log

# Request Resources
#SBATCH --mem=60G
#SBATCH -n 32
#SBATCH --gpus=1
#SBATCH -p pt

# Load required modules
module load anaconda3/2023.03/default
module load cuda/9.2/default

# Define environment name and path 
set ENV_NAME = "yolo_env"
set ENV_DIR = "/speed-scratch/$USER/envs"
set ENV_PATH = "$ENV_DIR/$ENV_NAME"
set TMP_DIR = "/speed-scratch/$USER/envs/tmp"
set PKGS_DIR = "/speed-scratch/$USER/envs/pkgs"

mkdir -p $ENV_DIR
mkdir -p $TMP_DIR
mkdir -p $PKGS_DIR

setenv TMP $TMP_DIR
setenv TMPDIR $TMP_DIR
setenv CONDA_PKGS_DIRS $PKGS_DIR

# Check if the environment exists
conda env list | grep "$ENV_NAME"
if ($status == 0) then
    echo "Environment $ENV_NAME already exists. Activating it..."
    echo "======================================================"
    conda activate "$ENV_PATH"

    if ($status != 0) then
        echo "Error: Failed to activate Conda environment."
        exit 1
	endif
else
	echo "Creating Conda environment $ENV_NAME at $ENV_PATH..."
    echo "===================================================="
	conda create -y -p "$ENV_PATH" python=3.5 keras=2.1.5 -c conda-forge

	echo "Activating environment $ENV_NAME..."
    echo "==================================="
	conda activate "$ENV_PATH"

	if ($status != 0) then
	    echo "Error: Failed to activate Conda environment."
	    exit 1
	endif
	
	echo "Installing required packages..."
    echo "==============================="
	pip install --upgrade pip
    pip install pillow matplotlib h5py
    #pip install tensorflow-gpu==1.8
	pip install opencv-python==4.1.2.30
	pip install opencv-contrib-python==4.1.2.30
endif

echo "Conda environemnt summary..."
echo "============================"
conda info --envs
conda list

# Download YOLOv3 weights
if (! -e yolov3.weights || -z yolov3.weights) then
    echo "Downloading YOLOv3 weights..."
    echo "============================="
    wget https://pjreddie.com/media/files/yolov3.weights
else
    echo "YOLOv3 weights already exist. Skipping download..."
    echo "=================================================="
endif

sleep 30

# Convert the Darknet YOLO model to a Keras model
if (! -e model_data/yolo.h5 || -z model_data/yolo.h5) then
    echo "Keras model NOT found. Converting Darknet YOLO model to Keras format..."
    echo "======================================================================="
    srun python convert.py yolov3.cfg yolov3.weights model_data/yolo.h5
else
    echo "Keras model already exists. Skipping conversion..."
    echo "=================================================="
endif

# Run YOLO video processing - image example
#srun python yolo_video.py --model model_data/yolo.h5 --classes model_data/coco_classes.txt --image

# Run YOLO video processing - video example (non-interactive)
echo "Running non-interactive YOLO video processing..."
echo "================================================"
srun python yolo_video.py --input video/v1.avi --output video/001.avi #--gpu_num 1

conda deactivate
exit