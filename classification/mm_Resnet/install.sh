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
echo "Upgrading pip, setuptools, ninja..."
conda run -n "$env_name" pip install -U pip setuptools ninja 

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



# Step 5: Other dependencies
echo "Installing additional dependencies..."
conda run -n "$env_name" pip install opencv-python==4.11.0.86 
conda run -n "$env_name" pip install -U openmim 
conda run -n "$env_name" pip install requests==2.31 
conda run -n "$env_name" pip install -U importlib_metadata huggingface_hub future tensorboard ftfy 
conda run -n "$env_name" pip install scikit-learn==1.6.1
conda run -n "$env_name" pip install seaborn==0.13.2
conda run -n "$env_name" pip install albumentations==2.0.8

# Step 6: Clone and install mmcv
echo "Cloning mmcv..."
git clone https://github.com/open-mmlab/mmcv.git 
cd mmcv 
git checkout v2.1.0 
conda run -n "$env_name" bash -c "MMCV_WITH_OPS=1 pip install -e ."
cd ..

git clone https://github.com/open-mmlab/mmengine.git
cd mmengine
git checkout v0.10.7
conda run -n "$env_name"  pip install -e .
cd ..

git clone https://github.com/open-mmlab/mmpretrain.git
cd mmpretrain
git checkout v1.2.0 
conda run -n "$env_name"  pip install -e .
cd ..

git clone https://github.com/open-mmlab/mmdeploy.git
cd mmdeploy
git checkout v1.3.1 
conda run -n "$env_name"  pip install -e .
cd ..


unzip -o caltech101.zip -d mmpretrain/

cp checkpoint.py mmengine/mmengine/runner/checkpoint.py
cp analyze_logs.py mmpretrain/tools/analysis_tools/analyze_logs.py
cp photometric.py mmcv/mmcv/image/photometric.py

conda run -n "$env_name" pip install onnxruntime-gpu
PYTHON_PATH=$(conda run -n "$env_name" which python)
"$PYTHON_PATH" -u downloadVOC.py 
echo "Environment '$env_name' setup complete!"
