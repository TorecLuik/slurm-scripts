#!/bin/bash
#SBATCH --job-name=w_nucleisegmentation-cellpose
#SBATCH --cpus-per-task=4
#SBATCH --time=01:00:00
#SBATCH --gres=gpu:a100:1
#SBATCH --mem=8GB
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
	$CYTOMINE_HOST $CYTOMINE_PUBLIC_KEY $YTOMINE_PRIVATE_KEY $CYTOMINE_ID_PROJECT $CYTOMINE_ID_SOFTWARE \
	$DIAMETER $PROB_THRESHOLD $NUC_CHANNEL $USE_GPU $CP_MODEL
