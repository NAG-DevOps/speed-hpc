#!/encs/bin/tcsh

# Give job a name
#$ -N yoloNonInteractiveGPU

# Set output directory to current
#$ -cwd

# Send an email when the job starts, finishes or if it is aborted.
#$ -m bea

# Request GPU
#$ -l gpu=2

# Request CPU with maximum memoy size = 40GB
# #$ -l h_vmem=40G

#sleep 30

# Specify the output file name in our case we commntes that system will genreate file with the same name of the job
# -o name.qlog


conda activate /speed-scratch/$USER/YOLO

# Image example 
#python yolo_video.py --model model_data/yolo.h5 --classes model_data/coco_classes.txt --image  --gpu_num 2

# Video example 
python yolo_video.py --input video/v1.avi --output video/002.avi --gpu_num 2

conda deactivate
