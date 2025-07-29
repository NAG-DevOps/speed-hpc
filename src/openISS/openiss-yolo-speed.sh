#!/encs/bin/tcsh

#SBATCH --job-name openiss-yolo
#SBATCH --mail-type=ALL                 ## Receive all email type notifications
#SBATCH --chdir=./                      ## Use currect directory as working directory (default) 
#SBATCH -o openiss-yolo-output-%A.log   ## Specify output file name

##
## Request Resources
##

#SBATCH --mem=60G
#SBATCH -n 32
#SBATCH --gpus=1
#SBATCH -p pt

# Load required modules
module load anaconda3/2023.03/default
module load cuda/9.2/default

# Define environment variables
set ENV_DIR = "/speed-scratch/$USER/yolo-venv"
mkdir -p $ENV_DIR/{tmp,pkgs,cache}

setenv TMP $ENV_DIR/tmp
setenv TMPDIR $ENV_DIR/tmp 
setenv CONDA_PKGS_DIRS $ENV_DIR/pkgs
setenv PIP_CACHE_DIR $ENV_DIR/cache

echo "Creating Conda environment at $ENV_DIR..."
echo "===================================================="
conda create -y -p "$ENV_DIR" python=3.5 keras=2.1.5 -c conda-forge

conda activate "$ENV_DIR"

echo "Installing required packages..."
echo "==============================="
pip install --upgrade pip
pip install pillow matplotlib h5py
#pip install tensorflow-gpu==1.8
pip install opencv-python==4.1.2.30
pip install opencv-contrib-python==4.1.2.30

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

date

# Run YOLO video processing - image example
#echo "Running non-interactive YOLO image processing..."
#echo "================================================"
#srun python yolo_video.py --model model_data/yolo.h5 --classes model_data/coco_classes.txt --image

# Run YOLO video processing - video example (non-interactive)
echo "Running non-interactive YOLO video processing..."
echo "================================================"
srun python yolo_video.py --input video/v1.avi --output video/001.avi #--gpu_num 1

date

conda deactivate