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

# Step 2.5: Check if PyTorch is installed, and install nightly build for RTX 5090 if needed
gpu_model=$(nvidia-smi --query-gpu=name --format=csv,noheader | head -n1)

# Check if PyTorch is already installed
pytorch_installed=$(conda run -n "$env_name" pip show torch)

if [[ "$gpu_model" == *"5090"* && ( -z "$pytorch_installed" || $(echo "$pytorch_installed" | grep -i "torch" | grep -v "cu128") ) ]]; then
  echo "Detected GPU: $gpu_model. Installing PyTorch nightly build with CUDA 12.8 support..."
  conda run -n "$env_name" pip install --pre torch==2.8.0.dev20250319+cu128 torchvision==0.22.0.dev20250319+cu128 torchaudio==2.6.0.dev20250319+cu128 --index-url https://download.pytorch.org/whl/nightly/cu128
else
  echo "Detected GPU: $gpu_model. Installing default PyTorch (or no installation needed)."
  conda run -n "$env_name" pip install torch torchvision torchaudio
fi

# Step 3: Install Jupyter and register the kernel
conda run -n "$env_name" pip install jupyter ipykernel
conda run -n "$env_name" python -m ipykernel install --user --name="$env_name" --display-name="Python ($env_name)"
echo "Jupyter kernel 'Python ($env_name)' registered."

# Step 4: Clone the pytorch-image-models repository at tag v1.0.15 if not exist
if [ ! -d "pytorch-image-models" ]; then
  echo "Cloning pytorch-image-models repository..."
  git clone https://github.com/huggingface/pytorch-image-models.git
  cd pytorch-image-models
  git checkout v1.0.15
  cd ..
else
  echo "Directory 'pytorch-image-models' already exists. Skipping clone."
fi

# Step 5: Install pytorch-image-models in editable mode
cd pytorch-image-models
conda run -n "$env_name" pip install -e .
echo "pytorch-image-models installed in editable mode."
cd ..

# Step 6: Install additional packages
conda run -n "$env_name" pip install huggingface_hub==0.29.3
conda run -n "$env_name" pip install matplotlib==3.9.4
conda run -n "$env_name" pip install pandas
conda run -n "$env_name" pip install scikit-learn
conda run -n "$env_name" pip install onnx
conda run -n "$env_name" pip install onnxruntime-gpu
conda run -n "$env_name" pip install opencv-python
echo "Additional packages installed."

# Step 7: Download datasets to ./dataset/
mkdir -p dataset
cd dataset

# Cassava dataset
if [ ! -d "cassavaleafdata" ]; then
  echo "Downloading cassava dataset..."
  wget -q https://storage.googleapis.com/emcassavadata/cassavaleafdata.zip
  unzip -q cassavaleafdata.zip
  rm cassavaleafdata.zip
  echo "Cassava dataset extracted."
else
  echo "Cassava dataset already exists. Skipping."
fi

# Imagenette dataset
if [ ! -d "imagenette2-320" ]; then
  echo "Downloading imagenette dataset..."
  wget -q https://s3.amazonaws.com/fast-ai-imageclas/imagenette2-320.tgz
  gunzip imagenette2-320.tgz
  tar -xf imagenette2-320.tar
  rm imagenette2-320.tar
  echo "Imagenette dataset extracted."
else
  echo "Imagenette dataset already exists. Skipping."
fi

cd ..

# Revise error code in onnx.py
cp -fv ./onnx.py pytorch-image-models/timm/utils/onnx.py

# Final output: Echo kernel path for programmatic parsing
echo "KERNEL_PATH=$HOME/.local/share/jupyter/kernels/$env_name"

