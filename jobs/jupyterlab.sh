#!/bin/bash
#SBATCH --job-name=jupyter
#SBATCH --gres=gpu:a100:1
#SBATCH --time=01:00:00
#SBATCH --mem=10GB
#SBATCH --output=/home/sandbox/ttluik/jupyter.log

module load Anaconda3

cat /etc/hosts
conda create --name tf --clone base || :
conda activate tf
jupyter notebook --ip=0.0.0.0 --port=9000
