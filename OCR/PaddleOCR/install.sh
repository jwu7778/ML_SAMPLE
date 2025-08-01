#!/bin/bash

set -e  # Stop script on any error
start_time=$(date +%s)  # Start timing

# Get the environment name from the first argument
env_name=$1

# If no name is provided, show a message and exit
if [ -z "$env_name" ]; then
  echo "\033[0;31m[Error]\033[0m Please provide an environment name. Example: sh install_paddleocr.sh myenv"
  exit 1
fi

# Initialize conda shell
source /opt/miniconda3/etc/profile.d/conda.sh

# Auto-deactivate current env if not base
if [[ "$CONDA_DEFAULT_ENV" != "" && "$CONDA_DEFAULT_ENV" != "base" ]]; then
  echo "Deactivating environment '$CONDA_DEFAULT_ENV'..."
  conda deactivate
fi

# Check if the conda environment exists, create it if it doesn't
if ! conda info --envs | grep -q "^$env_name"; then
  echo "Creating environment '$env_name'..."
  conda create --name "$env_name" python=3.10 -y
else
  echo "Environment '$env_name' already exists."
fi

# Install Jupyter and ipykernel inside the new env
conda run -n "$env_name" pip install jupyter ipykernel

# Install PaddlePaddle
conda run -n "$env_name" pip install paddlepaddle==3.0.0rc0

# Force downgrade numpy to compatible version
conda run -n "$env_name" pip install "numpy<2.0.0"

# Install protobuf to prevent missing error
conda run -n "$env_name" pip install protobuf


# Clone the PaddleOCR repository if not already cloned
if [ ! -d "PaddleOCR" ]; then
  echo "Cloning PaddleOCR..."
  git clone https://github.com/PaddlePaddle/PaddleOCR.git
else
  echo "'PaddleOCR' folder already exists. Skipping clone."
fi

# Enter PaddleOCR directory
cd PaddleOCR || exit 1

# Fetch all branches
echo "Fetching all branches..."
git fetch --all

# Checkout to release/2.9 branch
echo "Checking out release/2.9 branch..."
git checkout release/2.9 || { echo -e "\033[0;31m[Error]\033[0m Git checkout failed!"; exit 1; }

# Install dependencies
echo "Installing dependencies inside '$env_name'..."
conda run -n "$env_name" pip install -r requirements.txt

# Fix missing package: python-bidi
conda run -n "$env_name" pip install python-bidi

# Install PaddleOCR module in editable mode
echo "Installing PaddleOCR module (editable mode)..."
conda run -n "$env_name" pip install -e .

# Remove .git folder to lock version
echo "Removing .git folder to lock version..."
rm -rf .git

# Return to the root directory
cd ..


conda run -n "$env_name" pip install python-docx

conda run -n "$env_name" pip install paddle2onnx

conda run -n "$env_name" pip install imgaug

conda run -n "$env_name" pip install onnxruntime

conda run -n "$env_name" pip install paddleclas

conda run -n "$env_name" pip install premailer

conda run -n "$env_name" pip install openpyxl

conda run -n "$env_name" pip install timm==1.0.15

conda run -n "$env_name" pip install transformers

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
    conda run -n "$env_name" pip install torch==2.7.0+cu128 torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128
elif [[ $gpu_vendor == "AMD" ]]; then
    conda run -n "$env_name" pip install torch==2.7.0+rocm6.3 torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm6.3
else
    conda run -n "$env_name" pip install torch torchvision torchaudio
fi



# Register Jupyter kernel
echo "Registering Jupyter kernel for '$env_name'..."
eval "$(conda shell.bash hook)"
conda activate "$env_name"
python -m ipykernel install --user --name="$env_name" --display-name="Python ($env_name)"

git clone https://huggingface.co/microsoft/table-transformer-structure-recognition.git

echo "Environment setup complete: '$env_name'"
