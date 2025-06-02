#!/bin/bash

echo "[1/3] Creating conda environment: labelImg"

# Load conda shell functions
source /opt/miniconda3/etc/profile.d/conda.sh

# Auto-deactivate current environment if not base
if [[ "$CONDA_DEFAULT_ENV" != "" && "$CONDA_DEFAULT_ENV" != "base" ]]; then
  echo "Deactivating current environment: $CONDA_DEFAULT_ENV"
  conda deactivate
fi

# Create labelImg environment
conda create -n labelImg python=3.10 -y
if [ $? -ne 0 ]; then
    echo "[Error] Failed to create conda environment."
    exit 1
fi

echo "[2/3] Installing pyqt and labelImg using conda-forge"
conda install -n labelImg -c conda-forge pyqt labelImg -y
if [ $? -ne 0 ]; then
    echo "[Error] Failed to install pyqt or labelImg."
    exit 1
fi

echo "[3/3] labelImg installation completed successfully."
