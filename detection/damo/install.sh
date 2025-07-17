#!/bin/bash

# Get the environment name from the first argument
env_name=$1

if [ -z "$env_name" ]; then
  echo "❌ Please provide an environment name. Example: sh install.sh gc10env"
  exit 1
fi

# Load conda
source /opt/miniconda3/etc/profile.d/conda.sh

# Deactivate current env if not base
if [[ "$CONDA_DEFAULT_ENV" != "" && "$CONDA_DEFAULT_ENV" != "base" ]]; then
  echo "⚠️  Deactivating '$CONDA_DEFAULT_ENV'..."
  conda deactivate
fi

# Step 1: Create conda environment
echo "📦 Creating conda environment '$env_name'..."
conda create --name "$env_name" python=3.10 -y

# Step 2: Install Jupyter and register kernel
echo "🧩 Installing Jupyter and registering kernel..."
conda run -n "$env_name" pip install jupyter ipykernel
conda run -n "$env_name" python -m ipykernel install --user --name="$env_name" --display-name="Python ($env_name)"

# Step 3: Upgrade pip
conda run -n "$env_name" pip install --upgrade pip

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


# Step 5: Clone DAMO-YOLO
echo "📥 Cloning DAMO-YOLO repository..."
git clone https://github.com/tinyvision/DAMO-YOLO.git
cd DAMO-YOLO

# Step 6: Install requirements
echo "📦 Installing DAMO-YOLO requirements..."
conda run -n "$env_name" pip install -r requirements.txt

# Step 7: Install Cython
echo "🧬 Installing Cython..."
conda run -n "$env_name" pip install cython
conda run -n "$env_name" pip install scikit-learn==1.6.1
conda run -n "$env_name" pip install seaborn==0.13.2
conda run -n "$env_name" pip install onnx
conda run -n "$env_name" pip install onnxruntime-gpu
conda run -n "$env_name" pip install onnxsim

# Step 8: Install COCO API
echo "🐒 Installing COCO API..."
conda run -n "$env_name" pip install git+https://github.com/cocodataset/cocoapi.git#subdirectory=PythonAPI

cd ..

# Step 9: 解壓 gc10.zip 並搬移為 DAMO-YOLO/datasets/GC10-Det/{img, ann}
echo ""
echo "📂 Unzipping gc10.zip and restructuring to DAMO-YOLO/datasets/GC10-Det/{img, ann} ..."

unzip -q gc10.zip -d tmp_gc10

if [ -d "tmp_gc10/gc10/ds/img" ] && [ -d "tmp_gc10/gc10/ds/ann" ]; then
  rm -rf DAMO-YOLO/datasets/GC10-Det
  mkdir -p DAMO-YOLO/datasets/GC10-Det
  mv tmp_gc10/gc10/ds/img DAMO-YOLO/datasets/GC10-Det/img
  mv tmp_gc10/gc10/ds/ann DAMO-YOLO/datasets/GC10-Det/ann
  echo "✅ Dataset moved to: $(realpath DAMO-YOLO/datasets/GC10-Det)"
  echo "📁 Folder content:"
  ls -l DAMO-YOLO/datasets/GC10-Det
else
  echo "❌ Error: expected folders 'img' and 'ann' not found in gc10.zip"
fi

rm -rf tmp_gc10


cp -fv ./cocoeval.py ~/.conda/envs/$env_name/lib/python3.10/site-packages/pycocotools/cocoeval.py


# ✅ Fin
echo ""
echo "✅ All setup complete!"
echo "🚀 You can now launch Jupyter with:"
echo "conda run -n $env_name jupyter lab"

