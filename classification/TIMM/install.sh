#!/bin/bash

env_name=$1
if [ -z "$env_name" ]; then
  echo "Please provide an environment name. Example: sh install.sh myenv"
  exit 1
fi

# Define micromamba binary
MICROMAMBA="$HOME/.local/bin/micromamba"

# Initialize micromamba shell (needed to enable `run`)
eval "$($MICROMAMBA shell hook -s bash)"

# Step 1: Create environment with Python 3.10
$MICROMAMBA create --name "$env_name" -y -c conda-forge python=3.10
echo "Environment '$env_name' created."

# Step 2: Detect GPU vendor
if grep -qi microsoft /proc/version || uname -r | grep -qi microsoft; then
    echo "Detected WSL environment"
    wsl_path=$(command -v wsl.exe)
    if [ -z "$wsl_path" ]; then
        echo "wsl.exe not found. Defaulting to CPU-only PyTorch install."
        gpu_vendor="UNKNOWN"
    else
        gpu_name=$("$wsl_path" powershell.exe -NoLogo -NoProfile -Command \
          "Get-WmiObject Win32_VideoController | Select-Object -ExpandProperty Name" |
          tr -d '\r')
        echo "Windows GPU detected: $gpu_name"
        if [[ $gpu_name == *NVIDIA* ]]; then
            gpu_vendor="NVIDIA"
        elif [[ $gpu_name == *AMD* ]]; then
            gpu_vendor="AMD"
        else
            gpu_vendor="UNKNOWN"
        fi
    fi
else
    if command -v nvidia-smi &> /dev/null; then
        gpu_vendor="NVIDIA"
    elif command -v rocminfo &> /dev/null; then
        gpu_vendor="AMD"
    else
        gpu_vendor="UNKNOWN"
    fi
fi

# Step 3: Install PyTorch
echo "Installing PyTorch for GPU vendor: $gpu_vendor"
if [[ $gpu_vendor == "NVIDIA" ]]; then
    $MICROMAMBA run -n "$env_name" pip install torch==2.7.0+cu128 torchvision==0.22.0+cu128 torchaudio==2.7.0+cu128 --index-url https://download.pytorch.org/whl/cu128
elif [[ $gpu_vendor == "AMD" ]]; then
    $MICROMAMBA run -n "$env_name" pip install torch==2.7.0+rocm6.3 torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm6.3
else
    $MICROMAMBA run -n "$env_name" pip install torch torchvision torchaudio
fi

# Step 4: Install Jupyter kernel
$MICROMAMBA run -n "$env_name" pip install jupyter ipykernel
$MICROMAMBA run -n "$env_name" python -m ipykernel install --user --name="$env_name" --display-name="Python ($env_name)"
echo "Jupyter kernel 'Python ($env_name)' registered."

# Step 5: Clone pytorch-image-models if not exist
if [ ! -d "pytorch-image-models" ]; then
  echo "Cloning pytorch-image-models repository..."
  git clone https://github.com/huggingface/pytorch-image-models.git
  cd pytorch-image-models
  git checkout v1.0.15
  cd ..
else
  echo "Directory 'pytorch-image-models' already exists. Skipping clone."
fi

# Step 6: Install timm repo in editable mode
cd pytorch-image-models
$MICROMAMBA run -n "$env_name" pip install -e .
cd ..
echo "pytorch-image-models installed in editable mode."

# Step 7: Install extra Python packages
$MICROMAMBA run -n "$env_name" pip install \
  huggingface_hub==0.29.3 \
  matplotlib==3.9.4 \
  pandas \
  scikit-learn==1.6.1 \
  seaborn==0.13.2 \
  onnx \
  onnxruntime-gpu \
  opencv-python

echo "Extra packages installed."

# Step 8: Download datasets
mkdir -p dataset
cd dataset

if [ ! -d "cassavaleafdata" ]; then
  echo "Downloading cassava dataset..."
  wget -q https://storage.googleapis.com/emcassavadata/cassavaleafdata.zip
  unzip -q cassavaleafdata.zip
  rm cassavaleafdata.zip
  echo "Cassava dataset extracted."
else
  echo "Cassava dataset already exists. Skipping."
fi

if [ ! -d "imagenette2-320" ]; then
  echo "Downloading imagenette dataset..."
  wget -q https://s3.amazonaws.com/fast-ai-imageclas/imagenette2-320.tgz
  tar -xzf imagenette2-320.tgz
  rm imagenette2-320.tgz
  echo "Imagenette dataset extracted."
else
  echo "Imagenette dataset already exists. Skipping."
fi
cd ..

# Step 9: Patch ONNX utility file
cp -fv ./onnx.py pytorch-image-models/timm/utils/onnx.py

# Step 10: Output final Jupyter kernel path
echo "KERNEL_PATH=$HOME/.local/share/jupyter/kernels/$env_name"
