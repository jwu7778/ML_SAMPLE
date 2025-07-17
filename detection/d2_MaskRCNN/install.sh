#!/bin/bash

set -e  # Stop script on error
start_time=$(date +%s)  # Start timing

env_name=$1

# Color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[1;34m"
NC="\033[0m" # No color

# Validate argument
if [ -z "$env_name" ]; then
  echo -e "${RED}[Error]${NC} Please provide an environment name. Example: sh install_detectron2.sh myenv"
  exit 1
fi

# Check if conda is available
if ! command -v conda &> /dev/null; then
  echo -e "${RED}[Error]${NC} Conda not found. Please install Miniconda/Anaconda first."
  exit 1
fi

# Get the script's current directory and switch to it
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "$SCRIPT_DIR"

# Initialize conda
source "$(conda info --base)/etc/profile.d/conda.sh"

# Deactivate current env if not base
if [[ "$CONDA_DEFAULT_ENV" != "" && "$CONDA_DEFAULT_ENV" != "base" ]]; then
  echo "Deactivating current environment '$CONDA_DEFAULT_ENV'..."
  conda deactivate
fi

# Create conda environment if it doesn't exist
if ! conda info --envs | grep -q "^$env_name"; then
  echo -e "${BLUE}Creating environment '$env_name' with Python 3.10...${NC}"
  conda create --name "$env_name" python=3.10 -y
else
  echo -e "${BLUE}Environment '$env_name' already exists. Skipping creation.${NC}"
  conda activate "$env_name"
fi

# Install Jupyter and register the kernel
conda run -n "$env_name" pip install jupyter ipykernel
conda run -n "$env_name" python -m ipykernel install --user --name="$env_name" --display-name="Python ($env_name)"

# Check if the environment is WSL
if grep -qi microsoft /proc/version || uname -r | grep -qi microsoft; then
    echo "Detected WSL environment"

    # Use PowerShell to detect GPU vendor from Windows
    wsl_path=$(command -v wsl.exe)
    if [ -z "$wsl_path" ]; then
        echo "wsl.exe not found. Defaulting to CPU-only PyTorch install."
        gpu_vendor="UNKNOWN"
    else
        gpu_name=$("$wsl_path" powershell.exe -NoLogo -NoProfile -Command \
          "Get-WmiObject Win32_VideoController | Select-Object -ExpandProperty Name" |
          tr -d '\r')
        
        echo "Windows GPU detected from PowerShell: $gpu_name"

        if [[ $gpu_name == *NVIDIA* ]]; then
            gpu_vendor="NVIDIA"
        elif [[ $gpu_name == *AMD* ]]; then
            gpu_vendor="AMD"
        else
            gpu_vendor="UNKNOWN"
        fi
    fi
else
    # Not WSL — detect GPU via Linux tools
    if command -v nvidia-smi &> /dev/null; then
        gpu_vendor="NVIDIA"
    elif command -v rocminfo &> /dev/null; then
        gpu_vendor="AMD"
    else
        gpu_vendor="UNKNOWN"
    fi
fi

# Install PyTorch based on GPU vendor
echo "Installing PyTorch for GPU vendor: $gpu_vendor"
if [[ $gpu_vendor == "NVIDIA" ]]; then
    conda run -n "$env_name" pip install torch==2.7.0+cu128 torchvision==0.22.0+cu128 torchaudio==2.7.0+cu128 --index-url https://download.pytorch.org/whl/cu128
elif [[ $gpu_vendor == "AMD" ]]; then
    conda run -n "$env_name" pip install torch==2.7.0+rocm6.3 torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm6.3
else
    conda run -n "$env_name" pip install torch torchvision torchaudio
fi



# Clone Detectron2 if not already cloned
if [ ! -d "detectron2" ]; then
  echo "Cloning Detectron2 into $SCRIPT_DIR..."
  git clone https://github.com/facebookresearch/detectron2.git detectron2
else
  echo "'detectron2' folder already exists. Skipping clone."
fi

# Install Detectron2 and related dependencies
conda run -n "$env_name" pip install --no-build-isolation "detectron2 @ file://$SCRIPT_DIR/detectron2"
conda run -n "$env_name" pip install opencv-python fvcore cloudpickle
conda run -n "$env_name" pip install scikit-learn==1.6.1
conda run -n "$env_name" pip install seaborn==0.13.2

# Install onnx to export your model
conda run -n "$env_name" pip install onnx onnxruntime-gpu


wget https://github.com/matterport/Mask_RCNN/releases/download/v2.1/balloon_dataset.zip
unzip balloon_dataset.zip -d ./dataset/

# Revise error code in demo.py and postprocessing.py
cp -fv ./demo.py detectron2/demo/demo.py
cp -fv ./mask_ops.py detectron2/detectron2/layers/mask_ops.py


# Done
end_time=$(date +%s)
elapsed=$((end_time - start_time))
minutes=$((elapsed / 60))
seconds=$((elapsed % 60))

echo -e "${GREEN}[Success]${NC} Detectron2 environment '$env_name' installed with Jupyter kernel registered."
echo -e "${BLUE}[Info]${NC} Total installation time: ${minutes} min ${seconds} sec"
