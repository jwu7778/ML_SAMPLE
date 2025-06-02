# 🧠 OpenMMLab Classification + Deployment Tutorial (MMClassification + MMDeploy)

This repository provides a complete workflow for training and deploying image classification models using **MMClassification** and **MMDeploy**, both part of the OpenMMLab ecosystem.

This version demonstrates the pipeline using the **SwinV2** backbone and the **Places365** scene recognition dataset.  

The framework is modular and easily extendable to other backbone architectures (e.g., **ResNet**) and datasets (e.g., **ImageNet**).

---

## 📘 Available Notebooks

1. **`MMClassification_Tutorial_Swinv2.ipynb`**  
   - Demonstrates training a `swinv2-tiny-w8` model using [MMClassification](https://github.com/open-mmlab/mmclassification).
   - Uses the [Places365 dataset](https://www.kaggle.com/datasets/benjaminkz/places365).
   - Includes steps for dataset preparation, config modification, model initialization, and training.

2. **`MMDeploy_Tutorial.ipynb`**  
   - Shows how to convert and deploy the trained model with [MMDeploy](https://github.com/open-mmlab/mmdeploy).
   - Covers deployment config creation, checkpoint conversion (e.g., to ONNX), and inference with backend engines.

> 📝 Run the classification training first to generate a model checkpoint before proceeding to deployment.

---

## 📂 Dataset Setup: Places365

- **Source:** [https://www.kaggle.com/datasets/benjaminkz/places365](https://www.kaggle.com/datasets/benjaminkz/places365)
- **Steps to prepare:**
  1. Download the dataset from Kaggle.
  2. Unzip the archive.
  3. Rename and place it under the data folder structure expected by MMClassification (e.g., `mmpretrain/data/places365/`).

> 🔧 The dataset setup steps above have already been completed for this tutorial.  
> You may refer to them if you plan to switch to a different dataset in the future.

---

## 🧾 Dataset Description: Places365

- **Target:** The Places365 dataset is a large-scale image dataset designed for scene recognition. Developed by researchers at MIT, it is widely used for training and benchmarking models on the task of identifying the type of scene depicted in an image (e.g., "kitchen", "forest", "stadium", etc.). There are around 1.8 million training images, roughly 5,000 images per class.

- **Structure:** Images organized by class folders

- **Data Type:** RGB images

- **Classes:** The full dataset includes 365 scene categories.  
  In this tutorial, we use a subset of 28 categories whose names contain the word **"room"**, specifically:

  - auto_showroom
  - ballroom
  - bathroom
  - bedroom
  - childs_room
  - classroom
  - clean_room
  - computer_room
  - conference_room
  - dining_room
  - dorm_room
  - dressing_room
  - engine_room
  - hospital_room
  - hotel_room
  - kindergarden_classroom
  - lecture_room
  - living_room
  - locker_room
  - operating_room
  - playroom
  - recreation_room
  - server_room
  - storage_room
  - television_room
  - throne_room
  - utility_room
  - waiting_room

---

## 📌 Notes

- Adjust checkpoint saving policy to store only final or best-performing models to save disk space.
- If CUDA memory is limited, reduce `batch size` or use a smaller backbone model.
- Pretrained weights and resources may be cached in `$HOME/.cache/torch` — ensure sufficient disk availability.
