#!/bin/bash

echo "[1/3] Creating conda environment: labelme"

# Load conda shell functions
source /opt/miniconda3/etc/profile.d/conda.sh

# Auto-deactivate current environment if not base
if [[ "$CONDA_DEFAULT_ENV" != "" && "$CONDA_DEFAULT_ENV" != "base" ]]; then
  echo "Deactivating current environment: $CONDA_DEFAULT_ENV"
  conda deactivate
fi

# Create labelme environment
conda create -n labelme python=3.8 -y
if [ $? -ne 0 ]; then
    echo "[Error] Failed to create conda environment."
    exit 1
fi

echo "[2/3] Installing pyqt and labelme using conda-forge"
conda install -n labelme -c conda-forge pyqt labelme -y
if [ $? -ne 0 ]; then
    echo "[Error] Failed to install pyqt or labelme."
    exit 1
fi

echo "[3/3] Labelme installation completed successfully."
