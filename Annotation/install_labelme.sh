#!/bin/bash

# Path to micromamba executable
MICROMAMBA_BIN="$HOME/.local/bin/micromamba"  # Adjust if your micromamba path is different

echo "[1/3] Initializing micromamba shell environment"

# Initialize shell functions for micromamba (equivalent to conda.sh)
eval "$($MICROMAMBA_BIN shell hook -s bash)"

echo "[2/3] Creating environment: labelme (Python 3.8 + pyqt + labelme)"

# Create the environment and install all packages in one command using conda-forge
$MICROMAMBA_BIN create -y -n labelme -c conda-forge python=3.8 pyqt labelme

# Check if the environment was successfully created
if [ $? -ne 0 ]; then
    echo "[Error] Failed to create micromamba environment or install packages."
    exit 1
fi

echo "[3/3] Activating environment: labelme"
micromamba activate labelme

echo "✅ Labelme environment setup completed successfully."
