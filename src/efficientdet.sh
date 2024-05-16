#!/encs/bin/tcsh

##
## This script was initially submitted by a member of Dr. Amer's Research Group
##

##
## Prerequisite: 
##  Efficientdet Virtual Environment (see commit comments)
##

##
## SLURM options 
##

#SBATCH --job-name=efficientdet_pascal
#SBATCH --mail-type=ALL        ## Receive all email type notifications

# Request GPU in Dr. Amer's partition pa
#SBATCH --partition=pa
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8      
#SBATCH --ntasks=1
#SBATCH --gpus-per-node=2

#SBATCH --mem=128G             ## Assign memory per node 

cd /speed-scratch/$USER

module load python/3.8.3
module load cuda/11.5
source envs/tf/bin/activate.csh

cd code/automl/efficientdet

srun python3 main.py --mode=train_and_eval \
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
