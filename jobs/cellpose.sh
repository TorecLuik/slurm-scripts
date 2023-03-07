#!/bin/bash
#SBATCH --job-name=w_nucleisegmentation-cellpose
#SBATCH --cpus-per-task=4
#SBATCH --time=01:00:00
#SBATCH --mem=8GB
#SBATCH --output=cellpose-%4j.log
#SBATCH --mail-user=t.t.luik@amsterdamumc.nl
#SBATCH --mail-type=END,FAIL

echo "Running CellPose w/ $IMAGE_PATH | $IMAGE_VERSION | $DATA_PATH "

singularity run $IMAGE_PATH/w_nucleisegmentation-cellpose-$IMAGE_VERSION.simg \
	--infolder $DATA_PATH/data/in \
	--outfolder $DATA_PATH/data/out \
	--gtfolder $DATA_PATH/data/gt \
	--local \
	-nmc
