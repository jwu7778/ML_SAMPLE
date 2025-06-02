#!/bin/bash

env_name=$1
if [ -z "$env_name" ]; then
  echo "Please provide an environment name. Example: sh install.sh myenv"
  exit 1
fi

source /opt/miniconda3/etc/profile.d/conda.sh

if [[ "$CONDA_DEFAULT_ENV" != "" && "$CONDA_DEFAULT_ENV" != "base" ]]; then
  echo "Not in base environment. Deactivating '$CONDA_DEFAULT_ENV'..."
  conda deactivate
fi

# Step 1: Create the conda environment
conda create --name "$env_name" python=3.10 -y
echo "Environment '$env_name' created."


# Step 3: Install Jupyter and register the kernel
conda run -n "$env_name" pip install jupyter ipykernel
conda run -n "$env_name" python -m ipykernel install --user --name="$env_name" --display-name="Python ($env_name)"
echo "Jupyter kernel 'Python ($env_name)' registered."

# Step 3: Upgrade pip and setuptools    
echo "📦 Upgrading pip, setuptools, ninja..."
conda run -n "$env_name" pip install -U pip setuptools ninja 

# Step 4: Check if PyTorch is installed, and install nightly build for RTX 5090 if needed
gpu_model=$(nvidia-smi --query-gpu=name --format=csv,noheader | head -n1)

# Check if PyTorch is already installed


if lspci | grep -i 'nvidia' > /dev/null; then
    echo "NVIDIA"
    conda run -n "$env_name" pip install torch==2.7.0+cu128 torchvision==0.22.0+cu128 torchaudio==2.7.0+cu128 --index-url https://download.pytorch.org/whl/cu128
elif lspci | grep -i 'amd\|ati' > /dev/null; then
    echo "AMD"
    conda run -n "$env_name" pip install torch==2.7.0+rocm6.3 torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm6.3
else
    echo "Other or Unknown"
fi



git clone https://github.com/open-mmlab/mmengine.git
cd mmengine
git checkout v0.10.7
conda run -n "$env_name"  pip install -e .
cd ..


echo "📥 Cloning mmcv..."
git clone https://github.com/open-mmlab/mmcv.git 
cd mmcv 
git checkout v2.2.0 
conda run -n "$env_name" bash -c "MMCV_WITH_OPS=1 pip install -e ."
cd ..


# Step 7: Install additional packages
echo "📦 Installing additional Python packages..."
conda run -n "$env_name" pip install regex==2024.11.6
conda run -n "$env_name" pip install -U openmim importlib_metadata huggingface_hub future tensorboard ftfy


# Clone the mmsegmentation repository
git clone https://github.com/open-mmlab/mmsegmentation.git
cd mmsegmentation
git checkout v1.2.2
# Modify mmcv_maximum_version in mmdet/__init__.py (Ubuntu version)
sed -i "s/^mmcv_maximum_version *= *.*/mmcv_maximum_version = '2.2.1'/" mmseg/__init__.py
conda run -n "$env_name"  pip install -e .
cd ..


# Clone the mmdetection repository
git clone https://github.com/open-mmlab/mmdetection.git
cd mmdetection
git checkout v3.3.0
# Modify mmcv_maximum_version in mmdet/__init__.py (Ubuntu version)
sed -i "s/^mmcv_maximum_version *= *.*/mmcv_maximum_version = '2.2.1'/" mmdet/__init__.py
conda run -n "$env_name"  pip install -e .
# Go back to the original directory if needed
cd ..

cp checkpoint.py mmengine/mmengine/runner/checkpoint.py



echo "✅ Environment setup complete: '$env_name'"
