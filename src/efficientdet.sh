#!/encs/bin/tcsh

##
## This script was submitted by a member of Dr. Amer's Research Group
##

##
## Prerequisite: 
##  Efficientdet Virtual Environment (see commit comments)
##

##
## Job Scheduler options 
##

#$ -N efficientdet_pascal
#$ -cwd      
#$ -pe smp 8
#$ -l h_vmem=128G
#$ -l gpu=2

cd /speed-scratch/<encs_username>

module load python/3.8.3
module load cuda/11.5
source envs/tf/bin/activate.csh

cd code/automl/efficientdet

python3 main.py --mode=train_and_eval \
    --train_file_pattern=tfrecord/'pascal-*-of-00100.tfrecord' \
    --val_file_pattern=tfrecord/'val-*-of-00032.tfrecord' \
    --model_name='efficientdet-d0' \
    --model_dir=model_path  \
    --backbone_ckpt='efficientnet-b0' \
    --train_batch_size=4 \
    --eval_batch_size=4 --eval_samples=4952  \
    --num_examples_per_epoch=16551  --num_epochs=300  \
    --hparams="num_classes=20,moving_average_decay=0,mixed_precision=true" \
    --strategy='gpus'
