# 🧠 TIMM-based Image Classification Pipeline

This repository contains a modular deep learning pipeline using [PyTorch Image Models (timm)](https://github.com/huggingface/pytorch-image-models) for image classification tasks. It is structured into three stages, each with its own Jupyter notebook for clarity and flexibility.

---

## 🔗 Workflow Overview

1. **`TIMM_Install&Train.ipynb`**
   - 🔧 **Purpose**: Install dependencies and train a baseline model.
   - 📚 **Dataset**: [Imagenette](https://github.com/fastai/imagenette) — a 10-class subset of ImageNet designed for fast experimentation.
   - 🏗️ **Example Use Case**: Quick validation of training workflows or model behavior.

2. **`TIMM_CustomedTrain.ipynb`**
   - 🔧 **Purpose**: Train a model using a custom dataset.
   - 📚 **Dataset Example**: [Cassava Leaf Disease](https://www.kaggle.com/competitions/cassava-leaf-disease-classification) — 5-class classification of cassava plant leaf diseases (e.g., blight, mosaic).
   - 🌱 **Example Use Case**: Agricultural disease detection using real-world crop images.

3. **`TIMM_Validate&Inference.ipynb`**
   - 🔧 **Purpose**: Evaluate the model and run inference on new data.
   - 📚 **Dataset**: Same as training or unseen test images.
   - 📈 **Example Use Case**: Batch prediction and performance measurement.

---


## 🖼️ Dataset Format

All datasets should follow the standard folder structure:

```
dataset/
├── train/
│   ├── class1/
│   ├── class2/
│   └── ...
└── val/
    ├── class1/
    ├── class2/
    └── ...
```

You can use any dataset with this format. For example:
- Imagenette: https://github.com/fastai/imagenette
- Cassava Leaf Disease: https://www.kaggle.com/competitions/cassava-leaf-disease-classification

---

## 🧭 Execution Order

It is recommended to run the notebooks in the following order:

```text
1. TIMM_Install&Train.ipynb
2. TIMM_CustomedTrain.ipynb
3. TIMM_Validate&Inference.ipynb
```

Each notebook is self-contained and can be run independently if paths are properly set.


