#!/bin/bash


# replicate environment
# conda list --export --no-pip -n ng > conda_pkgs.txt
# pip freeze > pip_pkgs.txt


# environment setup on clusters
cd /scratch/$USER
module avail python
module avail conda
module load python/intel/3.8.6
module load anaconda3/2024.02
conda --version


# git
git config --global credential.helper store
git pull


# environment setup
# conda init bash
cd /scratch/$USER/envs
conda create --prefix /scratch/$USER/envs/main python=3.11 -y
conda activate /scratch/$USER/envs/main
# conda install --file conda_pkgs.txt
# pip install -r pip_pkgs.txt


# manually install packages
conda install pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia
pip install numpy scipy matplotlib pandas wandb tqdm
pip cache purge


# clean cache
pip cache info
pip cache list
pip cache purge
pip cache remove *
conda clean --tarballs
conda clean --all


# sbatch
cd /scratch/$USER/neural_galerkin/Random_Neural_Galerkin
squeue -u $USER
sbatch sbatch/run1.s
sbatch sbatch/run2.s
sbatch sbatch/run3.s
sbatch sbatch/run4.s
sbatch sbatch/run5.s
sbatch sbatch/run6.s
sbatch sbatch/run7.s
# scancel

# wandb
wandb artifact cache cleanup 1MB
rm ~/.netrc #deleting the netrc file [hit enter then login as follow:]
wandb login --relogin --cloud