#!/encs/bin/tcsh

# Give job a name
#SBATCH -J oi-yolo-batch-cpu

# Set output directory to current
#SBATCH --chdir=./

# Send an email when the job starts, finishes or if it is aborted.
#SBATCH --mail-type=ALL

# Request GPU
# #SBATCH --gpus=2

# Request CPU with maximum memoy size = 80GB
#SBATCH --mem=80G

# Request CPU slots 
#SBATCH -n 16

#sleep 30

# Specify the output file name
#SBATCH -o openiss-yolo-batch-cpu.log

module load anaconda3/2023.03/default

conda activate /speed-scratch/$USER/YOLO

# Image example 
#srun python yolo_video.py --model model_data/yolo.h5 --classes model_data/coco_classes.txt --image  --gpu_num 2

# Video example 
srun python yolo_video.py --input video/v1.avi --output video/001.avi #--gpu_num 2

conda deactivate
