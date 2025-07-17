#!/bin/bash

# Path to micromamba binary (adjust this if necessary)
MICROMAMBA="$HOME/.local/bin/micromamba"

echo "[1/3] Creating micromamba environment: labelImg"

# Initialize micromamba shell environment
eval "$($MICROMAMBA shell hook -s bash)"

# Remove existing environment if it already exists (optional)
# $MICROMAMBA env remove -n labelImg -y

# Create the environment with Python 3.8 and install packages in one step
$MICROMAMBA create -y -n labelImg -c conda-forge python=3.8 pyqt labelImg
if [ $? -ne 0 ]; then
    echo "[Error] Failed to create micromamba environment or install packages."
    exit 1
fi

echo "[2/3] Activating environment: labelImg"
micromamba activate labelImg

echo "[3/3] labelImg installation completed successfully."

