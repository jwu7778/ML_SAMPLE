# 🧠 OpenMMLab Outdoor Scenes Segmentation + Deployment Tutorial (PSPNet + MMDeploy)

This tutorial provides a complete workflow for training and deploying image segmentation models using **MMSegmentation** and **MMDeploy**, with the **PSPNet** model.

It uses a **semantic segmentation** setup on outdoor scene images, followed by a deployment step via ONNX conversion and backend inference engines.

---

## 📘 Available Notebooks

1. **`MMSegmentation_Tutorial_PSPNet.ipynb`**  
   - Demonstrates training a `PSPNet` model for **semantic segmentation** on the **Stanford Background** dataset.
   - Includes model configuration, dataset registration, training loop, and evaluation metrics.

2. **`MMDeploy_Tutorial.ipynb`**  
   - Converts the trained model into ONNX format using [MMDeploy](https://github.com/open-mmlab/mmdeploy).
   - Provides detailed steps on preparing the deployment config and performing inference with backend engines.

> 📝 Please run the training notebook first to obtain the model checkpoint before executing the deployment notebook.

---

## 📂 Dataset Setup

- **Source:** [http://dags.stanford.edu/data/iccv09Data.tar.gz -O stanford_background.tar.gz]
- **Directory Placement:**  
  - Our script should have automatically downloaded the dataset and saved at mmsegmentation as 'iccv09Data'
  - If you cannot find it, download from the above link or unzip the attached 'iccv09Data.zip'
  - Unzip the file
  - Put folder 'iccv09Data' under folder 'mmsegmentation'

```
mmsegmentation/
└── iccv09Data/
    ├── images/
    ├── labels/
    └── splits/
```

> 💡 This folder structure is required for the current tutorial to properly organize the dataset for training and evaluation.

---

## 🧾 Dataset Description

- **Stanford Background Dataset**  
- The dataset contains 715 RGB images and the corresponding label images. Images are approximately 240×320 pixels in size and pixels are classified into eight different categories 
  - sky
  - tree
  - road
  - grass
  - water
  - building
  - mountain
  - foreground object


---

## 🛠 Configuration Notes

- **Backbone:** `pspnet`  
- **Input Size:** 240×320
- Training configuration includes:
  - Image preprocessing, augmentation
  - Learning rate scheduling
  - Evaluation on validation set per x epoch

---

## 📦 Deployment Notes

- Deployment is performed via MMDeploy with ONNX export.
- Backend engines such as ONNXRuntime are used for benchmarking.
- Configuration options like input shape, mean/std normalization, and model path are specified in `deploy_cfg.py`.

---

