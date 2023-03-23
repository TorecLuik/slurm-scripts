#!/bin/bash

##############################
#       Job blueprint        #
##############################
# You can override all of these settings on the commandline, e.g. sbatch <this-script> --job-name=newJob

# Give your job a name, so you can recognize it in the queue overview
#SBATCH --job-name=deepcell

# Define, how many cpus you need. Here we ask for 4 CPU cores.
#SBATCH --cpus-per-task=4

# Define, how long the job will run in real time. This is a hard cap meaning
# that if the job runs longer than what is written here, it will be
# force-stopped by the server. If you make the expected time too long, it will
# take longer for the job to start. Here, we say the job will take 15 minutes.
#              d-hh:mm:ss
#SBATCH --time=00:15:00

# Define, if and what GPU your job requires. 
#SBATCH --gres=gpu:1g.10gb:1

# How much memory you need.
# --mem will define memory per node
#SBATCH --mem=5GB

# Define a name for the logfile of this job. %4j will add the 'j'ob ID variable
#SBATCH --output=deepcell-%4j.log

# Turn on mail notification. There are many possible self-explaining values:
# NONE, BEGIN, END, FAIL, ALL (including all aforementioned)
# For more values, check "man sbatch"
#SBATCH --mail-user=t.t.luik@amsterdamumc.nl
#SBATCH --mail-type=END,FAIL

# You may not place any commands before the last SBATCH directive

##############################
#       Job script 	         #
##############################

# Std out will get parsed into the logfile, so it is useful to log all your steps and variables
echo "Running DeepCell w/ $IMAGE_PATH | $IMAGE_VERSION | $DATA_PATH | \
	$NUCLEI_MIN_SIZE $BOUNDARY_WEIGHT"

# We run a (singularity) container with the provided ENV variables.
# The container is already downloaded as a .simg file at $IMAGE_PATH.
# This specific container is (BiaFlow's) deepcell, with parameters to run it 'locally'.
singularity run --nv $IMAGE_PATH/w_nucleisegmentation-deepcell-$IMAGE_VERSION.simg \
	--infolder $DATA_PATH/data/in \
	--outfolder $DATA_PATH/data/out \
	--gtfolder $DATA_PATH/data/gt \
	--local \
	--nuclei_min_size $NUCLEI_MIN_SIZE --boundary_weight $BOUNDARY_WEIGHT \
	-nmc
