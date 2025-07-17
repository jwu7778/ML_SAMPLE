#!/bin/bash

# Define the path to micromamba binary
MICROMAMBA="$HOME/.local/bin/micromamba"  # Adjust this if micromamba is installed elsewhere

# Initialize micromamba shell support (similar to sourcing conda.sh)
eval "$($MICROMAMBA shell hook -s bash)"

# Activate the 'labelme' environment created by micromamba
micromamba activate ppocrlabel

PPOCRLabel
