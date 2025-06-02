#!/bin/bash

env_name=$1

if [ -z "$env_name" ]; then
  echo "Please provide an environment name. Example: sh install_tesseract.sh myenv"
  exit 1
fi

source /opt/miniconda3/etc/profile.d/conda.sh

if [[ "$CONDA_DEFAULT_ENV" != "" && "$CONDA_DEFAULT_ENV" != "base" ]]; then
  echo "Deactivating '$CONDA_DEFAULT_ENV'..."
  conda deactivate
fi

echo "Creating environment '$env_name'..."
conda create --name "$env_name" python=3.10 -y

echo "Installing Tesseract and Python packages..."
conda run -n "$env_name" conda install -c conda-forge tesseract -y
conda run -n "$env_name" pip install pytesseract numpy jupyter ipykernel

echo "Registering Jupyter kernel..."
conda run -n "$env_name" python -m ipykernel install --user --name="$env_name" --display-name="Python ($env_name)"

echo "Downloading language packs into ./tessdata/ ..."
mkdir -p tessdata
wget -q -P tessdata https://github.com/tesseract-ocr/tessdata/raw/main/rus.traineddata
wget -q -P tessdata https://github.com/tesseract-ocr/tessdata/raw/main/pol.traineddata

echo ""
echo "✅ Installation complete!"
echo "In your notebook, add this before using OCR:"

