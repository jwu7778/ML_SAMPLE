#!/bin/bash

# Get the environment name from the first argument
env_name=$1

# If no name is provided, exit with a message
if [ -z "$env_name" ]; then
  echo "Please provide an environment name. Example: sh install_cnocr.sh myenv"
  exit 1
fi

# Ensure conda is available in this shell
source /opt/miniconda3/etc/profile.d/conda.sh

# Auto-deactivate current env (if not base)
if [[ "$CONDA_DEFAULT_ENV" != "" && "$CONDA_DEFAULT_ENV" != "base" ]]; then
  echo "Not in base environment. Deactivating '$CONDA_DEFAULT_ENV'..."
  conda deactivate
fi

# Step 1: Create the conda environment
echo "Creating environment '$env_name'..."
conda create --name "$env_name" python=3.10 -y
echo "Environment '$env_name' created."

# Step 2: Install Jupyter and ipykernel inside the new env
conda run -n "$env_name" pip install jupyter ipykernel

# Step 3: Clone CnOCR repo if not exists
if [ ! -d "CnOCR" ]; then
  echo "Cloning CnOCR repository..."
  git clone https://github.com/breezedeus/CnOCR.git
else
  echo "'CnOCR' folder already exists. Skipping clone."
fi

# Step 4: Move into the CnOCR directory
cd CnOCR || exit 1

# Step 5: Filter out 'ultralytics' from requirements.txt
echo "Filtering 'ultralytics' from requirements.txt..."
conda run -n "$env_name" python -c "
with open('requirements.txt') as infile:
    lines = infile.readlines()
filtered = [line for line in lines if 'ultralytics' not in line]
with open('temp_requirements.txt', 'w') as outfile:
    outfile.writelines(filtered)
"
echo "Filtered requirements written to temp_requirements.txt."

# Step 6: Install filtered dependencies
echo "Installing dependencies inside '$env_name'..."
conda run -n "$env_name" pip install -r temp_requirements.txt

# Step 7: Install CnOCR as a Python package (editable mode)
echo "Installing CnOCR as a package..."
conda run -n "$env_name" pip install -e .

# Step 8: Register the Jupyter kernel
echo "Registering Jupyter kernel for '$env_name'..."
eval "$(conda shell.bash hook)"
conda activate "$env_name"
python -m ipykernel install --user --name="$env_name" --display-name="Python ($env_name)"

# Step 9: Finish
echo "CnOCR environment '$env_name' installed and kernel registered successfully."

