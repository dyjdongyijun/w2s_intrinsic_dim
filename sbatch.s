#!/bin/bash 
#SBATCH --nodes=1                        # requests 3 compute servers
#SBATCH --ntasks-per-node=1              # runs 2 tasks on each server
#SBATCH --cpus-per-task=1                # uses 1 compute core per task
#SBATCH --time=120:00:00
#SBATCH --mem=4GB
#SBATCH --job-name=run1_%j
#SBATCH --output=run1_%j.out

module purge
module load python/intel/3.8.6
module load anaconda3/2020.07
activate /scratch/$USER/envs/w2s

ENV=/scratch/$USER/envs/w2s/bin
RUN=/scratch/$USER/neural_galerkin/Random_Neural_Galerkin
cd $RUN

TAG=run1
fp_tol=1e-6
pde=burgers
srun $ENV/python $RUN/main.py 