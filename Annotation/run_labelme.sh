#!/bin/bash

# Define the path to micromamba binary
MICROMAMBA="$HOME/.local/bin/micromamba"  # Adjust this if micromamba is installed elsewhere

# Initialize micromamba shell support (similar to sourcing conda.sh)
eval "$($MICROMAMBA shell hook -s bash)"

# Activate the 'labelme' environment created by micromamba
micromamba activate labelme

# Set Qt plugin path to ensure the PyQt GUI loads properly
export QT_QPA_PLATFORM_PLUGIN_PATH="$MAMBA_ROOT_PREFIX/envs/labelme/lib/python3.8/site-packages/PyQt5/Qt/plugins/platforms"

# Set LD_LIBRARY_PATH to include environment's lib directory (recommended for some shared libraries)
export LD_LIBRARY_PATH="$MAMBA_ROOT_PREFIX/envs/labelme/lib"

# Launch labelme GUI application
labelme

