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
conda run -n "$env_name" pip install paddlepaddle

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

# Checkout to release/2.10 branch
echo "Checking out release/2.6 branch..."
git checkout release/2.10 || { echo -e "\033[0;31m[Error]\033[0m Git checkout failed!"; exit 1; }

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

# Download and extract models into a models/ directory
mkdir -p models
cd models

# Detection model
wget -nc https://paddleocr.bj.bcebos.com/PP-OCRv4/chinese/ch_PP-OCRv4_det_infer.tar
if [ -f "ch_PP-OCRv4_det_infer.tar" ]; then
  tar -xf ch_PP-OCRv4_det_infer.tar
fi

# Recognition model
wget -nc https://paddleocr.bj.bcebos.com/PP-OCRv4/chinese/ch_PP-OCRv4_rec_infer.tar
if [ -f "ch_PP-OCRv4_rec_infer.tar" ]; then
  tar -xf ch_PP-OCRv4_rec_infer.tar
fi

# Classification model
wget -nc https://paddleocr.bj.bcebos.com/dygraph_v2.0/ch/ch_ppocr_mobile_v2.0_cls_infer.tar
if [ -f "ch_ppocr_mobile_v2.0_cls_infer.tar" ]; then
  tar -xf ch_ppocr_mobile_v2.0_cls_infer.tar
fi

cd ..

# Register Jupyter kernel
echo "Registering Jupyter kernel for '$env_name'..."
eval "$(conda shell.bash hook)"
conda activate "$env_name"
python -m ipykernel install --user --name="$env_name" --display-name="Python ($env_name)"

# Done
end_time=$(date +%s)
elapsed=$((end_time - start_time))
minutes=$((elapsed / 60))
seconds=$((elapsed % 60))
echo "\033[0;32m[Success]\033[0m PaddleOCR environment '$env_name' installed and Jupyter kernel registered successfully."
echo "\033[1;34m[Info]\033[0m Total installation time: ${minutes} min ${seconds} sec"

