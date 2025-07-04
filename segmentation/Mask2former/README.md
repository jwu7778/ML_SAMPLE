# 🧠 OpenMMLab Skin Lesion Segmentation Tutorial (Mask2former)

This tutorial provides a complete workflow for training and deploying image segmentation models using **MMSegmentation** and **MMDeploy**, with the **Mask2former** model.

It uses a **semantic segmentation** setup on skin lesion images, followed by a deployment step via ONNX conversion and backend inference engines.

---

## 📘 Available Notebooks

1. **`MMSegmentation_Tutorial_Mask2former.ipynb`**  
   - Demonstrates training a `Mask2former` model for **semantic segmentation** on the **ISIC Challenge Datasets 2018** dataset.
   - Includes model configuration, dataset registration, training loop, and evaluation metrics.

---

## 📂 Dataset Setup

- **Source:** [https://challenge.isic-archive.com/data/#2018]
- **Directory Placement:**  
  - Download from the above link
  - We use task 1 training and validation dataset, including: 
    Training Data (10.4GB): https://isic-challenge-data.s3.amazonaws.com/2018/ISIC2018_Task1-2_Training_Input.zip
    Training Ground Truth (26MB): https://isic-challenge-data.s3.amazonaws.com/2018/ISIC2018_Task1_Training_GroundTruth.zip
    Validation Data (228MB): https://isic-challenge-data.s3.amazonaws.com/2018/ISIC2018_Task1-2_Validation_Input.zip
    Validation Ground Truth (742KB): https://isic-challenge-data.s3.amazonaws.com/2018/ISIC2018_Task1_Validation_GroundTruth.zip
  - The ground truth are in masks of black and white

```
Reorder the dataset into  
ISIC/ 
├── images/ 
│   ├── training/ 
│   │   ├── 1.jpg 
│   │   ├── 2.jpg 
│   │   └── ... 
│   └── validation/ 
│       └── ... 
└── annotations/ 
    ├── training/ 
    │   ├── 1.png 
    │   ├── 2.png 
    │   └── ... 
    └── validation/ 
        └── ... 

```
  - and place it under the folder 'mmsegmentation'

> 💡 This folder structure is required for the current tutorial to properly organize the dataset for training and evaluation.

---

## 🧾 Dataset Description

- **ISIC Challenge Datasets 2018 Dataset**  
- The dataset contains 2594 (training) + 100 (validation) RBG images and the corresponding mask images. The white area of mask indicates the lesion region. The image are mostly high resolution with at least 500*700 pixels.

---

## 🛠 Configuration Notes

- **Backbone:** `mask2former`  
- **Input Size:** 
  - Resize with rules:
    - Short edge at least 512
    - Long edge at most 2048
    - Keep aspect ratio
- Training configuration includes:
  - Image preprocessing, augmentation
  - Learning rate scheduling
  - Evaluation on validation set per x epoch

---

## 📦 Deployment Notes

- Currently MMdeploy does not support exporting Mask2former to other backends yet. 
- If you need model to export, please refer to https://mmdeploy.readthedocs.io/en/latest/03-benchmark/supported_models.html

---

