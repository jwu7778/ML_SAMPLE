#!/bin/bash

env_name=$1
if [ -z "$env_name" ]; then
  echo "Please provide an environment name. Example: sh install.sh myenv"
  exit 1
fi

MICROMAMBA="$HOME/.local/bin/micromamba"

# Initialize micromamba shell support
eval "$($MICROMAMBA shell hook -s bash)"

# Step 1: Create environment
$MICROMAMBA create -y -n "$env_name" -c conda-forge python=3.10
echo "Environment '$env_name' created."

# Step 2: Install Jupyter and register kernel
$MICROMAMBA run -n "$env_name" pip install jupyter ipykernel
$MICROMAMBA run -n "$env_name" python -m ipykernel install --user --name="$env_name" --display-name="Python ($env_name)"
echo "Jupyter kernel 'Python ($env_name)' registered."

# Step 3: Upgrade pip, setuptools, ninja
echo "Upgrading pip, setuptools, and ninja..."
$MICROMAMBA run -n "$env_name" pip install -U pip setuptools ninja

# Step 4: Detect GPU vendor
echo "Detecting GPU..."
if grep -qi microsoft /proc/version || uname -r | grep -qi microsoft; then
    echo "Detected WSL environment"
    wsl_path=$(command -v wsl.exe)
    if [ -z "$wsl_path" ]; then
        echo "wsl.exe not found. Using CPU-only."
        gpu_vendor="UNKNOWN"
    else
        gpu_name=$("$wsl_path" powershell.exe -NoLogo -NoProfile -Command \
          "Get-WmiObject Win32_VideoController | Select-Object -ExpandProperty Name" |
          tr -d '\r')
        echo "Detected Windows GPU: $gpu_name"
        [[ $gpu_name == *NVIDIA* ]] && gpu_vendor="NVIDIA"
        [[ $gpu_name == *AMD* ]] && gpu_vendor="AMD"
        [[ -z "$gpu_vendor" ]] && gpu_vendor="UNKNOWN"
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

# Step 5: Install PyTorch
echo "Installing PyTorch for GPU vendor: $gpu_vendor"
if [[ $gpu_vendor == "NVIDIA" ]]; then
    $MICROMAMBA run -n "$env_name" pip install torch==2.7.0+cu128 torchvision==0.22.0+cu128 torchaudio==2.7.0+cu128 --index-url https://download.pytorch.org/whl/cu128
elif [[ $gpu_vendor == "AMD" ]]; then
    $MICROMAMBA run -n "$env_name" pip install torch==2.7.0+rocm6.3 torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm6.3
else
    $MICROMAMBA run -n "$env_name" pip install torch torchvision torchaudio
fi

# Step 6: Install additional packages
echo "Installing Python packages..."
$MICROMAMBA run -n "$env_name" pip install \
  opencv-python==4.11.0.86 \
  openmim \
  requests==2.31 \
  importlib_metadata \
  huggingface_hub \
  future \
  tensorboard \
  ftfy \
  scikit-learn==1.6.1 \
  seaborn==0.13.2

# Step 7: Clone and install OpenMMLab repos
echo "Cloning and installing mmcv..."
git clone https://github.com/open-mmlab/mmcv.git
cd mmcv && git checkout v2.1.0
$MICROMAMBA run -n "$env_name" bash -c "MMCV_WITH_OPS=1 pip install -e ."
cd ..

git clone https://github.com/open-mmlab/mmengine.git
cd mmengine && git checkout v0.10.7
$MICROMAMBA run -n "$env_name" pip install -e .
cd ..

git clone https://github.com/open-mmlab/mmpretrain.git
cd mmpretrain && git checkout v1.2.0
$MICROMAMBA run -n "$env_name" pip install -e .
cd ..

git clone https://github.com/open-mmlab/mmdeploy.git
cd mmdeploy && git checkout v1.3.1
$MICROMAMBA run -n "$env_name" pip install -e .
cd ..

mkdir -p mmpretrain/data

# Step 8: Install onnxruntime + patch checkpoint
$MICROMAMBA run -n "$env_name" pip install onnxruntime-gpu
cp -fv ./checkpoint.py mmengine/mmengine/runner/checkpoint.py

echo "Environment '$env_name' setup complete."
