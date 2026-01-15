#!/encs/bin/tcsh

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
	conda create -y -p "$ENV_PATH"
	
	echo "Activating environment $ENV_NAME..."
    echo "==================================="
	conda activate "$ENV_PATH"
	
	if ($status != 0) then
		echo "Error: Failed to activate Conda environment."
		exit 1
	endif
	
	echo "Installing required packages..."
    echo "==============================="
	conda install -y -c conda-forge python=3.5.6
	conda install -y Keras=2.1.5
	conda install -y pillow matplotlib h5py
	pip install --upgrade pip
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

# Run YOLO video processing - video example (interactive)
echo "Running interactive YOLO video processing..."
echo "============================================"
srun python yolo_video.py --input video/v1.avi --output video/002.avi --interactive

conda deactivate
exit