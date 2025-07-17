import os
import fiftyone.zoo as foz

# here we choose detection and segmentation as our task, and set cute tortoises and lizards which like hiding as the objects to find
foz.load_zoo_dataset(
    "open-images-v7",
    split="train",
    label_types=["detections"],
    classes = ["Tortoise", "Lizard"],
)

foz.load_zoo_dataset(
    "open-images-v7",
    split="validation",
    label_types=["detections"],
    classes = ["Tortoise", "Lizard"],
)

import shutil

src = os.path.expanduser("~/fiftyone/open-images-v7")
dst = "detectron2/dataset"
shutil.move(src, dst)


import pandas as pd
import cv2
import xml.etree.ElementTree as ET

def indent(elem, level=0):
    indent_str = "    " * level
    if len(elem):
        if not elem.text or not elem.text.strip():
            elem.text = "\n" + "    " * (level + 1)
        if not elem.tail or not elem.tail.strip():
            elem.tail = "\n" + indent_str
        for child in elem:
            indent(child, level + 1)
        if not child.tail or not child.tail.strip():
            child.tail = "\n" + indent_str
    else:
        if level and (not elem.tail or not elem.tail.strip()):
            elem.tail = "\n" + indent_str
            
def create_voc_xml(filename, path, width, height, objects):
    annotation = ET.Element("annotation")
    
    ET.SubElement(annotation, "filename").text = filename
    ET.SubElement(annotation, "path").text = path
        
    size = ET.SubElement(annotation, "size")
    ET.SubElement(size, "width").text = str(width)
    ET.SubElement(size, "height").text = str(height)
    ET.SubElement(size, "depth").text = "3"
    
    for obj in objects:
        object_elem = ET.SubElement(annotation, "object")
        ET.SubElement(object_elem, "name").text = obj["name"]
        
        bndbox = ET.SubElement(object_elem, "bndbox")
        ET.SubElement(bndbox, "xmin").text = str(obj["bbox"][0])
        ET.SubElement(bndbox, "ymin").text = str(obj["bbox"][1])
        ET.SubElement(bndbox, "xmax").text = str(obj["bbox"][2])
        ET.SubElement(bndbox, "ymax").text = str(obj["bbox"][3])
    
    indent(annotation)
    return ET.ElementTree(annotation)

def convert_to_voc(path):
    classes = ["Tortoise", "Lizard"]
    class_to_name = {0: "Tortoise", 1: "Lizard"}  # mapping to VOC-style names

    image_path = os.path.join(path, "data/")
    class_path = os.path.join(path, "metadata/classes.csv")
    label_path = os.path.join(path, "labels/detections.csv")

    image_list = [f for f in os.listdir(image_path) if f.lower().endswith(('.png', '.jpg', '.jpeg'))]
    image_list_no_ext = [os.path.splitext(f)[0] for f in image_list]

    class_df = pd.read_csv(class_path, header=None)
    label_df = pd.read_csv(label_path)

    def get_code_by_name(df, name_list):
        return [df.loc[df.loc[:, 1] == val, 0].values[0] for val in name_list]

    class_id = get_code_by_name(class_df, classes)

    label_df = label_df[label_df["ImageID"].isin(image_list_no_ext)]
    label_df = label_df[label_df["LabelName"].isin(class_id)]

    for i, no_ext in zip(image_list, image_list_no_ext):
        filename = os.path.join(image_path, i)
        img = cv2.imread(filename)
        if img is None:
            print(f"Failed to read image {filename}")
            continue

        height, width = img.shape[:2]
        sub_label_df = label_df[label_df["ImageID"] == no_ext]

        objects = []
        for _, row in sub_label_df.iterrows():
            cid = class_id.index(row["LabelName"])
            obj = {
                "name": class_to_name[cid],
                "bbox": [
                    int(row['XMin'] * width),
                    int(row['YMin'] * height),
                    int(row['XMax'] * width),
                    int(row['YMax'] * height),
                ],
            }
            objects.append(obj)

        xml_tree = create_voc_xml(
            filename=i,
            path=filename,
            width=width,
            height=height,
            objects=objects,
        )

        xml_filename = os.path.splitext(filename)[0] + ".xml"
        xml_tree.write(xml_filename, encoding="utf-8", xml_declaration=False)

    print("Finished writing XML annotations.")

# Example usage
convert_to_voc("detectron2/dataset/open-images-v7/train")
convert_to_voc("detectron2/dataset/open-images-v7/validation")


def flatten_and_clean_folder(folder_path):
    """
    Move all files from 'data' subfolder to the given folder, 
    then delete 'data', 'labels', and 'metadata' subfolders.

    Args:
        folder_path (str): Path to the folder containing 'data', 'labels', and 'metadata'
    """
    data_dir = os.path.join(folder_path, 'data')
    target_dir = folder_path

    # Move all files from 'data' to folder_path
    if os.path.isdir(data_dir):
        for filename in os.listdir(data_dir):
            src_path = os.path.join(data_dir, filename)
            dst_path = os.path.join(target_dir, filename)
            if os.path.isfile(src_path):
                shutil.move(src_path, dst_path)
    
    # Remove the subfolders if they exist
    for subfolder in ['data', 'labels', 'metadata']:
        sub_path = os.path.join(folder_path, subfolder)
        if os.path.isdir(sub_path):
            shutil.rmtree(sub_path)

    print(f"Done. Flattened 'data' and removed subfolders in: {folder_path}")

flatten_and_clean_folder("detectron2/dataset/open-images-v7/train")
flatten_and_clean_folder("detectron2/dataset/open-images-v7/validation")
