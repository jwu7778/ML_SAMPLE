# 🧠 OpenMMLab Classification + Deployment Tutorial (ResNet + MMDeploy)

This tutorial provides a complete workflow for training and deploying image classification models using **MMClassification** and **MMDeploy**, using the **ResNet** backbone.

It includes both **single-label classification** and **multi-label classification** examples, followed by a deployment step with ONNX and backend inference engines.

---

## 📘 Available Notebooks

1. **`MMClassification_Tutorial_Resnet.ipynb`**  
   - Demonstrates training a `resnet50` model for **single-label classification** on a filtered subset of the **Caltech101** dataset.
   - The task is to distinguish between `"airplanes"` and `"Motorbikes"` classes.

2. **`MMClassification_Tutorial_Resnet_MultiLabel.ipynb`**  
   - Demonstrates **multi-label classification** using the **VOC2007** dataset.
   - Shows model configuration, training, and evaluation with metrics like mAP and F1-score.

3. **`MMDeploy_Tutorial.ipynb`**  
   - Converts the trained model into ONNX format using [MMDeploy](https://github.com/open-mmlab/mmdeploy).
   - Covers deployment config creation and inference with backend engines.

> 📝 Please run the training notebooks first to obtain model checkpoints before executing the deployment tutorial.

---

## 📂 Dataset Setup

### Caltech101 (Single-Label Classification)

- **Source:** [https://data.caltech.edu/records/mzrjq-6wc02](https://data.caltech.edu/records/mzrjq-6wc02)
- **Used Classes:**  
  - `"airplanes"`  
  - `"Motorbikes"`  
- **Task:** Single-Label classification (classifying image into one of the categories)  
- **Directory Structure (after filtering):**

### VOC2007 (Multi-Label Classification)

- **Source:** [https://host.robots.ox.ac.uk/pascal/VOC/voc2007/](https://host.robots.ox.ac.uk/pascal/VOC/voc2007/)
- **Task:** Multi-label classification with 20 object categories (whether the image is positive or negative in each of the categories)
- **Data Format:** Pascal VOC XML annotations + JPEG images

---

## 🧾 Dataset Description

- **Caltech101:**  
- Used as a **single-label classification**.
- Images are RGB, organized by class folders.

- **VOC2007:**  
- Used for **multi-label classification**.
- Images can contain multiple objects from 20 categories.
- Custom dataset preparation script is used to generate multi-label image lists and annotations.
- **Structure:** 
  If codes are executed correctly, you should find a folder mmpretrain/data/VOC2007/ having
  ```
  ├── Annotations/
  │   ├── 000001.xml
  │   └── ...
  ├── ImageSets/
  │   └── Main
  │       ├── test.txt
  │       └── trainval.txt
  └── JPEGImages/ (syslink)
      ├── 000001.jpg
      └── ...
  ```

---

## 📦 Deployment Notes

- Deployment is done with MMDeploy using ONNX as the intermediate representation.
- Backend inference engine (e.g., ONNXRuntime) used to evaluate exported model.
- Batch size and input resolution are adjustable in `deploy_cfg.py`.

---

## 📌 Tips

- Save only final or best checkpoints to reduce disk usage.
- Use a smaller batch size if CUDA memory is insufficient.
- Confirm `mmcv`, `mmengine`, and `mmdeploy` versions are compatible to avoid deployment errors.
