#!/bin/bash
set -e

# Specify conda environment name
ENV_NAME="ppocrlabel"

# Create a new conda environment with Python 3.9
conda create -y -n $ENV_NAME python=3.9 pip

# Upgrade pip and essential tools
conda run -n $ENV_NAME pip install --upgrade pip setuptools wheel numpy==1.24.4

# Install PaddlePaddle 3.0.0 (required by PPOCRLabel)
conda run -n $ENV_NAME pip install paddlepaddle==3.0.0

# Install PaddleOCR (latest version with PPStructure)
conda run -n $ENV_NAME pip install git+https://github.com/PaddlePaddle/PaddleOCR

# Install PPOCRLabel (PFCCLab fork)
conda run -n $ENV_NAME pip install git+https://github.com/PFCCLab/PPOCRLabel.git

# Additional GUI dependencies (headless version to avoid Qt issues)
conda run -n $ENV_NAME pip install opencv-python-headless xlrd trash-cli

# Completion message
echo ""
echo "PPOCRLabel installation completed."
