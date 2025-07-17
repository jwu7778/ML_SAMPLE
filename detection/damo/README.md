# 🚀 DAMO-YOLO Defect Detection Pipeline

This repository demonstrates how to train and evaluate object detection models using [DAMO-YOLO](https://github.com/tinyvision/DAMO-YOLO).  
It is specifically configured to work with the [GC10-Det](https://datasetninja.com/gc10-det) industrial surface defect dataset.

---

## 📘 Available Notebooks

1. **`DAMO_Training.ipynb`**  
   Sets up the environment and trains a DAMO-YOLO model using a lightweight **subset of the GC10-Det dataset**.  
   Useful for verifying model structure, training flow, and initial performance on defect detection.

2. **`DAMO_Inference.ipynb`**  
   Loads a trained model and performs inference on new images.  
   Demonstrates how to visualize detection results and interpret model performance.

> 📝 Each notebook is self-contained but logically ordered.  
> Start from training, then proceed to inference.

---

## 🧾 Dataset Description: GC10-Det
- **Source:** [https://datasetninja.com/gc10-det](https://datasetninja.com/gc10-det)
- **Target:** The GC10-Det dataset is a benchmark dataset for surface defect detection on industrial metal components. It was collected from real-world production lines to facilitate the development of machine vision solutions for automated quality inspection.
- **Structure:** Images organized by class folders with bounding box annotations
- **Data Type:** RGB images with annotated bounding boxes for defects
- **Classes:**
  - crease
  - crescent_gap
  - inclusion
  - oil_spot
  - punching_hole
  - rolled_pit
  - silk_spot
  - waist folding
  - water_spot
  - welding_line

This dataset is widely used in quality control and predictive maintenance in smart manufacturing.

---

## 📂 Dataset Setup: GC10-Det
  The dataset should have been downloaded in `DAMO-YOLO/datasets/`, or you may download manually.
- **Preparation Steps:**
  1. Download the dataset from the source link above.
  2. Unzip the archive.
  3. Place the folder named `dc` under `DAMO-YOLO/datasets/`.
  4. Rename it to: `GC10-Det`

Our .ipynb script will continue the reformating of dataset. When the dataset is ready for training, it should have structure:
```
GC10-Det
    ├── train
    │   ├── img
    │   │   ├── image1
    │   │   └── image2
    │   └── ann
    │        └── annotations.json
    └── valid
        ├── img
        │   ├── image1
        │   └── image2
        └── ann
             └── annotations.json
```
---

## 📌 Notes

- Make sure to install all dependencies from DAMO-YOLO and verify your environment is properly set.
- If you want to use your own dataset, please convert it to the **COCO format**, or adapt the loader accordingly.

