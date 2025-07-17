# dataset is not perfect, some pixels are unclassified and left as unknowns (class -1)
# we clean it by assigning unknowns as neighbour class, and drop sample if there are many unknowns
import os
import re
import numpy as np
from scipy import stats
from collections import Counter

os.chdir('mmsegmentation')

def process_file(filepath):
    # Read matrix from file
    with open(filepath, 'r') as f:
        matrix = []
        for line in f:
            row = [float(x) for x in line.strip().split()]
            matrix.append(row)
    
    arr = np.array(matrix)
    total_values = arr.size
    negatives = arr[arr < 0]
    negative_count = len(negatives)
    
    # Case 1: More than 1% negatives - delete file
    if negative_count > 0.01 * total_values:
        os.remove(filepath)
        print(f"Deleted {filepath} ({negative_count/total_values:.2%} negatives)")
        return
    
    # Case 2: Few negatives - replace with mode of nearby values
    if negative_count > 0:
        print(f"Processing {filepath} ({negative_count} negatives)")
        rows, cols = arr.shape
        
        # Create padded array for edge handling
        padded = np.pad(arr, 1, mode='constant', constant_values=np.nan)
        
        for i in range(rows):
            for j in range(cols):
                if arr[i,j] < 0:
                    # Get 3x3 neighborhood (excluding current cell)
                    neighborhood = padded[i:i+3, j:j+3].flatten()
                    neighborhood = neighborhood[~np.isnan(neighborhood)]
                    neighborhood = neighborhood[neighborhood >= 0]  # Exclude other negatives
                    
                    if len(neighborhood) > 0:
                        # Calculate mode of positive neighbors
                        mode = stats.mode(neighborhood, keepdims=False).mode
                        arr[i,j] = mode
                    else:
                        # If no valid neighbors, use global mode
                        global_mode = stats.mode(arr[arr >= 0].flatten()).mode
                        arr[i,j] = global_mode
        
        # Save corrected file
        np.savetxt(filepath, arr, fmt='%.6f')
        print(f"Corrected {filepath}")

# Main processing
label_dir = "iccv09Data/labels/"
for filename in os.listdir(label_dir):
    if filename.endswith(".regions.txt"):
        filepath = os.path.join(label_dir, filename)
        process_file(filepath)

# ensure no more unknown
import os
import re

# Directory containing the label files
label_dir = "iccv09Data/labels/"
negative_files = []

# Regex pattern to match various negative number formats
negative_pattern = re.compile(r'-\d*\.?\d+')  # Matches: -1, -123, -1.23, -.5

for filename in os.listdir(label_dir):
    if filename.endswith(".regions.txt"):
        filepath = os.path.join(label_dir, filename)
        with open(filepath, 'r') as f:
            content = f.read()
            
            # Find all negative numbers in file
            negatives = negative_pattern.findall(content)
            
            if negatives:
                print(f"\nFound {len(negatives)} negative value(s) in {filename}:")
                print("Negative values:", ", ".join(negatives))
                negative_files.append(filename)

print("\n=== Summary ===")
print(f"Total files with negative values: {len(negative_files)}")
if negative_files:
    print("Affected files:")
    for f in negative_files:
        print(f" - {f}")
else:
    print("No files contain negative values.")

# drop the samples of unknown
import os

label_dir = "iccv09Data/labels/"

# Get all PNG files
png_files = [f for f in os.listdir(label_dir) if f.endswith('.png')]

for png in png_files:
    base_name = os.path.splitext(png)[0]  # Get filename without extension
    required_files = [
        f"{base_name}.layers.txt",
        f"{base_name}.regions.txt",
        f"{base_name}.surfaces.txt"
    ]
    
    # Check if all required files exist
    missing_files = [f for f in required_files if not os.path.exists(os.path.join(label_dir, f))]
    
    if missing_files:
        print(f"Deleting incomplete bundle for {base_name}:")
        print(f"  Missing files: {', '.join(missing_files)}")
        
        # Delete PNG
        png_path = os.path.join(label_dir, png)
        os.remove(png_path)
        print(f"  Deleted: {png}")
        
        # Delete any existing TXTs
        for txt in required_files:
            txt_path = os.path.join(label_dir, txt)
            if os.path.exists(txt_path):
                os.remove(txt_path)
                print(f"  Deleted: {txt}")
        
        print("  Bundle removed\n")

print("Cleanup complete")

# define dataset root and directory for images and annotations
data_root = 'iccv09Data'
img_dir = 'images'
ann_dir = 'labels'
# define class and palette for better visualization
classes = ('sky', 'tree', 'road', 'grass', 'water', 'bldg', 'mntn', 'fg obj')
palette = [[128, 128, 128], [129, 127, 38], [120, 69, 125], [53, 125, 34],
           [0, 11, 123], [118, 20, 12], [122, 81, 25], [241, 134, 51]]

import os.path as osp
import numpy as np
from PIL import Image
import mmengine

# convert dataset annotation to semantic segmentation map
for file in mmengine.scandir(osp.join(data_root, ann_dir), suffix='.regions.txt'):
  seg_map = np.loadtxt(osp.join(data_root, ann_dir, file)).astype(np.uint8)
  seg_img = Image.fromarray(seg_map).convert('P')
  seg_img.putpalette(np.array(palette, dtype=np.uint8))
  seg_img.save(osp.join(data_root, ann_dir, file.replace('.regions.txt',
                                                         '.png')))

import os
import shutil
import random
# Save the current working directory
original_dir = os.getcwd()
os.chdir('iccv09Data')

# Original folders
image_dir = 'images'
label_dir = 'labels'

# Output folders
output_dirs = {
    'train_images': 'train/images',
    'train_labels': 'train/labels',
    'val_images': 'val/images',
    'val_labels': 'val/labels'
}

# Create output dirs if they don't exist
for path in output_dirs.values():
    os.makedirs(path, exist_ok=True)

# Get all image files
image_files = [f for f in os.listdir(image_dir) if f.endswith('.jpg')]
image_files.sort()  # Optional: keep deterministic order
random.seed(42)
random.shuffle(image_files)  # Shuffle for randomness

# Split 80/20
split_idx = int(0.8 * len(image_files))
train_files = image_files[:split_idx]
val_files = image_files[split_idx:]

def move_files(file_list, dst_img_dir, dst_lbl_dir):
    count = 0
    for fname in file_list:
        img_src = os.path.join(image_dir, fname)
        lbl_src = os.path.join(label_dir, fname.replace('.jpg', '.png'))

        img_dst = os.path.join(dst_img_dir, fname)
        lbl_dst = os.path.join(dst_lbl_dir, fname.replace('.jpg', '.png'))

        if not os.path.exists(img_src):
            print(f"[Skip] Image not found: {img_src}")
            continue
        if not os.path.exists(lbl_src):
            print(f"[Skip] Label not found: {lbl_src}")
            continue

        shutil.move(img_src, img_dst)
        shutil.move(lbl_src, lbl_dst)
        count+=1
    return count

# Move the files
count = move_files(train_files, output_dirs['train_images'], output_dirs['train_labels'])
print(f"Moved {count} files to train")
count = move_files(val_files, output_dirs['val_images'], output_dirs['val_labels'])
print(f"Moved {count} files to val")

os.chdir('..')
os.chdir('..')