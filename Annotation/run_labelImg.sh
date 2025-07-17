#!/bin/bash

# Define the path to micromamba binary
MICROMAMBA="$HOME/.local/bin/micromamba"  # Update this path if necessary

# Initialize micromamba shell functions (replaces "source conda.sh")
eval "$($MICROMAMBA shell hook -s bash)"

# Activate the labelImg environment
micromamba activate labelImg

# Set required Qt plugin path for PyQt GUI (adjust Python version if needed)
export QT_QPA_PLATFORM_PLUGIN_PATH="$MAMBA_ROOT_PREFIX/envs/labelImg/lib/python3.8/site-packages/PyQt5/Qt/plugins/platforms"
export LD_LIBRARY_PATH="$MAMBA_ROOT_PREFIX/envs/labelImg/lib"

# Launch labelImg GUI application
labelImg

