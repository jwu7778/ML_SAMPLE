# 🧠 TIMM-based Image Classification Pipeline

This repository contains a modular deep learning pipeline using [PyTorch Image Models (timm)](https://github.com/huggingface/pytorch-image-models) for image classification tasks. It is structured into three stages, each with its own Jupyter notebook for clarity and flexibility.

---

## 🔗 Workflow Overview

1. **`TIMM_Tutorial.ipynb`**
   - 🔧 **Purpose**: This script demonstrates a basic workflow using a simple dataset. You can adapt it to your own dataset and select a model by modifying the script accordingly.
   - 📚 **Dataset**: [Imagenette](https://github.com/fastai/imagenette) — a 10-class subset of ImageNet designed for fast experimentation.
   - 🏗️ **Example Use Case**: Quick start of training workflows or model behavior.

2. **`TIMM_CustomedTrain.ipynb`**
   - 🔧 **Purpose**: Example of training a model on a custom dataset, evaluating its performance, and running inference on new data.
   - 📚 **Dataset Example**: [Cassava Leaf Disease](https://www.kaggle.com/competitions/cassava-leaf-disease-classification) — 5-class classification of cassava plant leaf diseases (e.g., blight, mosaic).
   - 🌱 **Example Use Case**: Agricultural disease detection using real-world crop images.

---


## 🖼️ Dataset Format

All datasets should follow the standard folder structure:

```
├── train
│   ├── class1
│   │   ├── image1
│   │   └── image2
│   ├── class2
│   └── class3
└── val
    ├── class1
    ├── class2
    └── class3
```

You can use any dataset with this format. For example:
- Imagenette: https://github.com/fastai/imagenette
- Cassava Leaf Disease: https://www.kaggle.com/competitions/cassava-leaf-disease-classification

---

## 🧭 Execution Order

It is recommended to run the notebooks in the following order:

```text
1. TIMM_Tutorial.ipynb
2. TIMM_CustomedTrain.ipynb
```

Each notebook is self-contained and can be run independently if paths are properly set.


