#!/encs/bin/tcsh

## since it is salloc no need to configure cluster setting because
## it would choose the proper computational node  

conda activate /speed-scratch/$USER/YOLO

# Image example 
#python yolo_video.py --model model_data/yolo.h5 --classes model_data/coco_classes.txt --image 

# Video example 
srun python yolo_video.py --input video/v1.avi --output video/003.avi --interactive

conda deactivate
