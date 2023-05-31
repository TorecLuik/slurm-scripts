#!/bin/bash

##############################
#       Job blueprint        #
##############################
# You can override all of these settings on the commandline, e.g. sbatch <this-script> --job-name=newJob

# Give your job a name, so you can recognize it in the queue overview
#SBATCH --job-name=cellpose

# Define, how many cpus you need. Here we ask for 4 CPU cores.
#SBATCH --cpus-per-task=4

# Define, how long the job will run in real time. This is a hard cap meaning
# that if the job runs longer than what is written here, it will be
# force-stopped by the server. If you make the expected time too long, it will
# take longer for the job to start. Here, we say the job will take 15 minutes.
#              d-hh:mm:ss
# Note that we use the timeout command in the actual script to requeue the job.
#SBATCH --time=00:15:00

# Define, if and what GPU your job requires. 
#SBATCH --gres=gpu:1g.10gb:1

# How much memory you need.
# --mem will define memory per node
#SBATCH --mem=5GB

# Define a name for the logfile of this job. %4j will add the 'j'ob ID variable
# Use append so that we keep the old log when we requeue this job
#SBATCH --output=omero-%4j.log
#SBATCH --open-mode=append

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
echo "Running CellPose w/ $IMAGE_PATH | $SINGULARITY_IMAGE | $DATA_PATH | \
	$DIAMETER $PROB_THRESHOLD $NUC_CHANNEL $USE_GPU $CP_MODEL"

# Set TIMEOUT to 1 min less than the sbatch time
TIMEOUT=$(expr $(scontrol show job $SLURM_JOB_ID | awk '/TimeLimit/ {split($0,a,"="); split(a[3],b,":"); print b[2]}') - 1)
echo "Timeout set to ${TIMEOUT} minutes"

# We run a (singularity) container with the provided ENV variables.
# The container is already downloaded as a .simg file at $IMAGE_PATH.
# This specific container is (BiaFlow's) CellPose, with parameters to run it 'locally'.
# Timeout command will timeout before the job ends, to requeue if we are still busy processing
timeout ${TIMEOUT}m singularity run --nv $IMAGE_PATH/$SINGULARITY_IMAGE \
	--infolder $DATA_PATH/data/in \
	--outfolder $DATA_PATH/data/out \
	--gtfolder $DATA_PATH/data/gt \
	--local \
	--diameter $DIAMETER --prob_threshold $PROB_THRESHOLD \
	--nuc_channel $NUC_CHANNEL \
	--use_gpu $USE_GPU \
	--cp_model $CP_MODEL \
	-nmc
	

# If the command exits due to the time limit, requeue this job
if [ "$?" -eq "124" ]; then
	echo "Job timed out"
	echo "Requeueing job"
	scontrol requeue $SLURM_JOB_ID
else 
	echo "Job completed successfully."
fi
