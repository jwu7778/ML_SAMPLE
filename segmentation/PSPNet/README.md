# 🧠 OpenMMLab Outdoor Scenes Segmentation + Deployment Tutorial (PSPNet + MMDeploy)

This tutorial provides a complete workflow for training and deploying image segmentation models using **MMSegmentation** and **MMDeploy**, with the **PSPNet** model.

It uses a **semantic segmentation** setup on outdoor scene images, followed by a deployment step via ONNX conversion and backend inference engines.

---

## 📘 Available Notebooks

1. **`MMSegmentation_Tutorial.ipynb`**  
   - Demonstrates training a `PSPNet` model for **semantic segmentation** on the **Stanford Background** dataset.
   - Includes model configuration, dataset registration, training loop, and evaluation metrics.

2. **`MMDeploy_Tutorial.ipynb`**  
   - Converts the trained model into ONNX format using [MMDeploy](https://github.com/open-mmlab/mmdeploy).
   - Provides detailed steps on preparing the deployment config and performing inference with backend engines.

> 📝 Please run the notebooks in order to obtain the model checkpoint before executing the deployment notebook.

---
## 🧾 Dataset Description

- **Stanford Background Dataset**
- **Source:** [http://dags.stanford.edu/data/iccv09Data.tar.gz -O stanford_background.tar.gz]
- **About:** The dataset contains 715 RGB images and the corresponding label images of outdoor scenes. Images are approximately 240×320 pixels in size and pixels are classified into eight different categories 
  - sky
  - tree
  - road
  - grass
  - water
  - building
  - mountain
  - foreground object
- **Structure:** 
```
├── train
│   ├── image1
│   ├── image1.json
│   ├── image2
│   └── image2.json
└── val
    ├── image1
    ├── image1.json
    ├── image2
    └── image2.json
```

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

