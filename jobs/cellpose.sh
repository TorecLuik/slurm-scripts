#!/bin/bash
#SBATCH --job-name=cellpose
#SBATCH --cpus-per-task=4
#SBATCH --time=00:15:00
#SBATCH --gres=gpu:1g.10gb:1
#SBATCH --mem=5GB
#SBATCH --output=cellpose-%4j.log
#SBATCH --mail-user=t.t.luik@amsterdamumc.nl
#SBATCH --mail-type=END,FAIL

echo "Running CellPose w/ $IMAGE_PATH | $IMAGE_VERSION | $DATA_PATH | $CYTOMINE_HOST $CYTOMINE_PUBLIC_KEY $YTOMINE_PRIVATE_KEY $CYTOMINE_ID_PROJECT $CYTOMINE_ID_SOFTWARE \
	$DIAMETER $PROB_THRESHOLD $NUC_CHANNEL $USE_GPU $CP_MODEL"

singularity run --nv $IMAGE_PATH/w_nucleisegmentation-cellpose-$IMAGE_VERSION.simg \
	--infolder $DATA_PATH/data/in \
	--outfolder $DATA_PATH/data/out \
	--gtfolder $DATA_PATH/data/gt \
	--local \
	-nmc \
	--diameter $DIAMETER \ 
	--prob_threshold $PROB_THRESHOLD \
	--nuc_channel $NUC_CHANNEL \
	--use_gpu $USE_GPU \
	--cp_model $CP_MODEL
