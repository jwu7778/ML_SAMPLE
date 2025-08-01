#!/bin/bash

# Load conda shell functions
source /opt/miniconda3/etc/profile.d/conda.sh

# Activate labelme environment
conda activate labelme

# Set required Qt plugin path for GUI
export QT_QPA_PLATFORM_PLUGIN_PATH="$CONDA_PREFIX/lib/python3.8/site-packages/PyQt5/Qt/plugins/platforms"
export LD_LIBRARY_PATH="$CONDA_PREFIX/lib"

# Launch labelme
labelme