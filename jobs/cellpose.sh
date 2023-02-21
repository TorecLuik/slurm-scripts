#!/bin/bash
#SBATCH --job-name=w_nucleisegmentation-cellpose
#SBATCH --cpus-per-task=4
#SBATCH --time=01:00:00
#SBATCH --mem=8GB
#SBATCH --output=cellpose.log
#SBATCH --mail-user=t.t.luik@amsterdamumc.nl
#SBATCH --mail-type=END,FAIL

singularity run $IMAGE_PATH/w_nucleisegmentation-cellpose-$IMAGE_VERSION.simg \
	--infolder $DATA_PATH/data/in \
	--outfolder $DATA_PATH/data/out \
	--gtfolder $DATA_PATH/data/gt \
	--local \
	-nmc
