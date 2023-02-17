#!/bin/bash
#SBATCH --job-name=w_nucleisegmentation-cellpose-v1.2.2
#SBATCH --cpus-per-task=4
#SBATCH --time=01:00:00
#SBATCH --mem=8GB
#SBATCH --output=/home/sandbox/ttluik/cellpose.log
#SBATCH --mail-user=t.t.luik@amsterdamumc.nl
#SBATCH --mail-type=END,FAIL

singularity run --bind $DATA_PATH/data:/data $IMAGE_PATH/w_nucleisegmentation-cellpose-v1.2.2.simg \
	--infolder /data/in \
	--outfolder /data/out \
	--gtfolder /data/gt \
	--local \
	-nmc \
	--descriptor ~/my-scratch/descriptor.json
