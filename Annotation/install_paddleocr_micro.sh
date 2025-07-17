#!/bin/bash
set -e

# Path to micromamba binary (adjust if necessary)
MICROMAMBA="$HOME/.local/bin/micromamba"

echo "[1/3] Creating micromamba environment: ppocrlabel"

# Set environment name
ENV_NAME="ppocrlabel"

# Initialize micromamba shell environment
eval "$($MICROMAMBA shell hook -s bash)"


# Create a new conda environment with Python 3.9
$MICROMAMBA create -y -n $ENV_NAME python=3.9 pip

# Upgrade pip and essential tools
$MICROMAMBA  run -n $ENV_NAME pip install --upgrade pip setuptools wheel numpy==1.24.4

# Install PaddlePaddle 3.0.0 (required by PPOCRLabel)
$MICROMAMBA  run -n $ENV_NAME pip install paddlepaddle==3.0.0

# Install PaddleOCR (latest version with PPStructure)
$MICROMAMBA  run -n $ENV_NAME pip install git+https://github.com/PaddlePaddle/PaddleOCR

# Install PPOCRLabel (PFCCLab fork)
$MICROMAMBA  run -n $ENV_NAME pip install git+https://github.com/PFCCLab/PPOCRLabel.git

# Additional GUI dependencies (headless version to avoid Qt issues)
$MICROMAMBA  run -n $ENV_NAME pip install opencv-python-headless xlrd trash-cli

# Completion message
echo ""
echo "PPOCRLabel installation completed."
