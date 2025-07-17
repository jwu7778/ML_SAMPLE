import os
import requests
import tarfile
from tqdm import tqdm


# URLs for VOC2007 dataset
voc2007_urls = {
    'trainval': 'http://host.robots.ox.ac.uk/pascal/VOC/voc2007/VOCtrainval_06-Nov-2007.tar',
    'test': 'http://host.robots.ox.ac.uk/pascal/VOC/voc2007/VOCtest_06-Nov-2007.tar'
}

# Download and extract datasets
for split, url in voc2007_urls.items():
    # Download file
    filename = os.path.basename(url)
    filepath = os.path.join('mmpretrain/', filename)
    
    print(f"Downloading {filename}...")
    response = requests.get(url, stream=True)
    total_size = int(response.headers.get('content-length', 0))
    
    with open(filepath, 'wb') as f, tqdm(
        total=total_size, unit='B', unit_scale=True, desc=filename
    ) as bar:
        for data in response.iter_content(chunk_size=1024):
            size = f.write(data)
            bar.update(size)
    
    # Extract file
    print(f"Extracting {filename}...")
    with tarfile.open(filepath) as tar:
        tar.extractall('mmpretrain/')
        
    # Clean up tar file to save space
    os.remove(filepath)
    
print("Download and extraction complete!")

# Here, we create directory of the dataset for training
# Only part of the dataset is needed for this task, so we only keep necessary part, that make it easier for you to follow
import shutil

# Create the target structure
os.makedirs('mmpretrain/VOC2007', exist_ok=True)
os.makedirs('mmpretrain/VOC2007/ImageSets', exist_ok=True)

# Check if downloaded data is in the expected location
voc_source = 'mmpretrain/VOCdevkit/VOC2007'
voc_target = 'mmpretrain/VOC2007'

if os.path.exists(voc_source):
    # Link JPEGImages directory
    src_jpeg = os.path.join(voc_source, 'JPEGImages')
    dst_jpeg = os.path.join(voc_target, 'JPEGImages')
    
    if os.path.exists(src_jpeg) and not os.path.exists(dst_jpeg):
        try:
            os.symlink(os.path.abspath(src_jpeg), dst_jpeg)
            print(f"Created symlink from {src_jpeg} to {dst_jpeg}")
        except OSError:
            print(f"Copying {src_jpeg} to {dst_jpeg}")
            shutil.copytree(src_jpeg, dst_jpeg)
    
    # Copy just test.txt and trainval.txt from ImageSets/Main
    src_main = os.path.join(voc_source, 'ImageSets/Main')
    dst_main = os.path.join(voc_target, 'ImageSets/Main')
    
    os.makedirs(dst_main, exist_ok=True)
    
    for file in ['test.txt', 'trainval.txt']:
        src_file = os.path.join(src_main, file)
        dst_file = os.path.join(dst_main, file)
        
        if os.path.exists(src_file) and not os.path.exists(dst_file):
            print(f"Copying {src_file} to {dst_file}")
            #shutil.copy2(src_file, dst_file)
            os.symlink(os.path.abspath(src_file), dst_file)
    
    # Copy Annotations directory
    src_annot = os.path.join(voc_source, 'Annotations')
    dst_annot = os.path.join(voc_target, 'Annotations')
    
    if os.path.exists(src_annot) and not os.path.exists(dst_annot):
        print(f"Copying {src_annot} to {dst_annot}")
        #shutil.copytree(src_annot, dst_annot)
        os.symlink(os.path.abspath(src_annot), dst_annot)
    
    print("Dataset structure prepared successfully!")
else:
    print(f"Error: Source directory {voc_source} not found. Check your download.")


# only part of the info in xml is needed, so we simplify them
# after that, you can create your own dataset mimicking the format
import xml.etree.ElementTree as ET
from glob import glob

def clean_xml(input_path, output_path):
    # Parse the XML file
    tree = ET.parse(input_path)
    root = tree.getroot()
    
    # Keep only necessary elements
    necessary_elements = ['filename', 'size']
    
    # Remove unnecessary elements at the root level
    for child in list(root):
        if child.tag not in necessary_elements and child.tag != 'object':
            root.remove(child)
    
    # Process each object element - keep only name and difficult
    for obj in root.findall('object'):
        # Extract name and difficult flag
        name = obj.find('name')
        difficult = obj.find('difficult')
        
        # Remove all other child elements
        for child in list(obj):
            if child.tag != 'name' and child.tag != 'difficult':
                obj.remove(child)
    
    # Write cleaned XML to output file
    tree.write(output_path)

_dir = 'mmpretrain/VOC2007/Annotations'
    
# Create output directory if it doesn't exist
os.makedirs(_dir, exist_ok=True)

# Find all XML files in the input directory
xml_files = glob(os.path.join(_dir, '*.xml'))

print(f"Found {len(xml_files)} XML files to process")

# Process each XML file
for xml_file in tqdm(xml_files, desc="Cleaning XML files"):
    # Get just the filename
    basename = os.path.basename(xml_file)
    output_path = os.path.join(_dir, basename)
    
    # Clean and save the XML
    clean_xml(xml_file, output_path)

print(f"Processed {len(xml_files)} XML files")
print(f"Cleaned annotations saved to {_dir}")



# Base directories
base_dir = 'mmpretrain/VOC2007'
image_dir = os.path.join(base_dir, 'JPEGImages')
ann_dir = os.path.join(base_dir, 'Annotations')

# Target directories (no subfolders now)
train_dir = os.path.join(base_dir, 'train')
test_dir = os.path.join(base_dir, 'test')

os.makedirs(train_dir, exist_ok=True)
os.makedirs(test_dir, exist_ok=True)

# Function to move files based on a txt list
def move_files(txt_path, target_dir):
    with open(txt_path, 'r') as f:
        image_ids = [line.strip() for line in f]

    for img_id in image_ids:
        jpg_src = os.path.join(image_dir, img_id + '.jpg')
        xml_src = os.path.join(ann_dir, img_id + '.xml')

        jpg_dst = os.path.join(target_dir, img_id + '.jpg')
        xml_dst = os.path.join(target_dir, img_id + '.xml')

        if os.path.exists(jpg_src):
            shutil.copy(jpg_src, jpg_dst)
        else:
            print(f"⚠️ Image not found: {jpg_src}")

        if os.path.exists(xml_src):
            shutil.copy(xml_src, xml_dst)
        else:
            print(f"⚠️ Annotation not found: {xml_src}")

# Move training/validation images
move_files(os.path.join(base_dir, 'ImageSets/Main/trainval.txt'), train_dir)

# Move test images
move_files(os.path.join(base_dir, 'ImageSets/Main/test.txt'), test_dir)

print("✅ Relocation complete.")

def convert_xml_to_json(xml_path):
    tree = ET.parse(xml_path)
    root = tree.getroot()

    # Basic image info
    filename = root.find('filename').text
    size = root.find('size')
    width = int(size.find('width').text)
    height = int(size.find('height').text)

    # Collect class names
    flags = {}
    for obj in root.findall('object'):
        name = obj.find('name').text
        flags[name] = True

    json_data = {
        "version": "5.2.1",
        "flags": flags,
        "shapes": [],
        "imagePath": filename,
        "imageHeight": height,
        "imageWidth": width
    }

    return json_data

# Target directories
dirs = [
    "mmpretrain/VOC2007/train",
    "mmpretrain/VOC2007/test"
]
import json
for dir_path in dirs:
    xml_files = glob(os.path.join(dir_path, "*.xml"))

    for xml_file in xml_files:
        json_data = convert_xml_to_json(xml_file)

        json_filename = os.path.splitext(os.path.basename(xml_file))[0] + ".json"
        json_path = os.path.join(dir_path, json_filename)

        with open(json_path, 'w') as f:
            json.dump(json_data, f, indent=2)

        #print(f"✅ Converted: {xml_file} → {json_path}")

print("🎉 All XML files converted to JSON.")

import os
import xml.etree.ElementTree as ET
import json
from collections import defaultdict

# Directories
ann_dir = 'mmpretrain/VOC2007/test' 
img_dir = 'mmpretrain/VOC2007/test'   

# Step 1: Collect all unique classes
class_set = set()
xml_files = [f for f in os.listdir(ann_dir) if f.endswith('.xml')]

for file in xml_files:
    tree = ET.parse(os.path.join(ann_dir, file))
    root = tree.getroot()
    for obj in root.findall('object'):
        class_name = obj.find('name').text.strip()
        class_set.add(class_name)

# Sort class names to get consistent indices
class_list = sorted(list(class_set))
class_to_idx = {cls: idx for idx, cls in enumerate(class_list)}

# Step 2: Convert XMLs to your JSON format
data_list = []

for file in xml_files:
    xml_path = os.path.join(ann_dir, file)
    tree = ET.parse(xml_path)
    root = tree.getroot()
    
    img_filename = root.find('filename').text
    label_set = set()

    for obj in root.findall('object'):
        class_name = obj.find('name').text.strip()
        class_idx = class_to_idx[class_name]
        label_set.add(class_idx)

    data_list.append({
        "img_path": img_filename,
        "gt_label": sorted(list(label_set))  # Sorted for consistency
    })
    os.remove(xml_path)
# Step 3: Save JSON
output = {
    "metainfo": {
        "classes": class_list
    },
    "data_list": data_list
}

with open(os.path.join(ann_dir, 'voc_annotations_test.json'), 'w') as f:
    json.dump(output, f, indent=2)

print("Annotation JSON saved to voc_annotations_test.json")

import os
import xml.etree.ElementTree as ET
import json
from collections import defaultdict

# Directories
ann_dir = 'mmpretrain/VOC2007/train'  
img_dir = 'mmpretrain/VOC2007/train'      

# Step 1: Collect all unique classes
class_set = set()
xml_files = [f for f in os.listdir(ann_dir) if f.endswith('.xml')]

for file in xml_files:
    tree = ET.parse(os.path.join(ann_dir, file))
    root = tree.getroot()
    for obj in root.findall('object'):
        class_name = obj.find('name').text.strip()
        class_set.add(class_name)

# Sort class names to get consistent indices
class_list = sorted(list(class_set))
class_to_idx = {cls: idx for idx, cls in enumerate(class_list)}

# Step 2: Convert XMLs to your JSON format
data_list = []

for file in xml_files:
    xml_path = os.path.join(ann_dir, file)
    tree = ET.parse(xml_path)
    root = tree.getroot()
    
    img_filename = root.find('filename').text
    label_set = set()

    for obj in root.findall('object'):
        class_name = obj.find('name').text.strip()
        class_idx = class_to_idx[class_name]
        label_set.add(class_idx)

    data_list.append({
        "img_path": img_filename,
        "gt_label": sorted(list(label_set))  # Sorted for consistency
    })
    os.remove(xml_path)
# Step 3: Save JSON
output = {
    "metainfo": {
        "classes": class_list
    },
    "data_list": data_list
}

with open(os.path.join(ann_dir, 'voc_annotations_train.json'), 'w') as f:
    json.dump(output, f, indent=2)

print("Annotation JSON saved to voc_annotations_train.json")
