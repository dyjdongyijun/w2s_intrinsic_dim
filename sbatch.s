#!/bin/bash 
#SBATCH --nodes=1                        # requests 3 compute servers
#SBATCH --ntasks-per-node=1              # runs 2 tasks on each server
#SBATCH --cpus-per-task=1                # uses 1 compute core per task
#SBATCH --time=120:00:00
#SBATCH --mem=4GB
#SBATCH --job-name=run1_%j
#SBATCH --output=run1_%j.out

module purge
activate /scratch/$USER/envs/main

ENV=/scratch/$USER/envs/main/bin
RUN=/scratch/$USER/w2s_intrinsic_dim
cd $RUN

TAG=run1
fp_tol=1e-6
pde=burgers
srun $ENV/python $RUN/main.py 