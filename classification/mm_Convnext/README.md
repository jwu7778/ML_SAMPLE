# 🧠 OpenMMLab OCT Classification + Deployment Tutorial (ConvNeXt + MMDeploy)

This tutorial provides a complete workflow for training and deploying image classification models using **MMClassification** and **MMDeploy**, with the **ConvNeXt** backbone.

It uses a **single-label classification** setup on OCT retinal images, followed by a deployment step via ONNX conversion and backend inference engines.

---

## 📘 Available Notebooks

1. **`MMClassification_Tutorial_Convnext.ipynb`**  
   - Demonstrates training a `convnext-tiny` model for **single-label classification** on a curated subset of the **OCT** dataset.
   - Includes model configuration, dataset registration, training loop, and evaluation metrics.

2. **`MMDeploy_Tutorial.ipynb`**  
   - Converts the trained model into ONNX format using [MMDeploy](https://github.com/open-mmlab/mmdeploy).
   - Provides detailed steps on preparing the deployment config and performing inference with backend engines.

> 📝 Please run the training notebook first to obtain the model checkpoint before executing the deployment notebook.

---

## 📂 Dataset Setup

- **Source:** [https://data.mendeley.com/datasets/rscbjbr9sj/3](https://data.mendeley.com/datasets/rscbjbr9sj/3)  
- **Used Subset:** Only the **OCT** folder from the dataset  
- **Directory Placement:**  
  - After downloading and unzipping the dataset, manually place the `OCT` folder under `mmpretrain/data/`

```
mmpretrain/
└── data/
    └── OCT/
        ├── test/
        │   ├── CNV/
        │   ├── DRUSEN/
        │   ├── NORMAL/
        │   └── DME/
        └── train/
            ├── CNV/
            ├── DRUSEN/
            ├── NORMAL/
            └── DME/
```

> 💡 This folder structure is required for the current tutorial to properly organize the OCT dataset for training and evaluation.

---

## 🧾 Dataset Description

- **OCT Dataset (Retinal Optical Coherence Tomography)**  
- Consists of grayscale eye scan images grouped into 4 classes:  
  - **CNV** (Choroidal Neovascularization):  
    Abnormal growth of blood vessels beneath the retina, commonly associated with wet age-related macular degeneration (AMD).  
  - **DME** (Diabetic Macular Edema):  
    Fluid accumulation in the macula caused by leakage from retinal blood vessels, typically a complication of diabetic retinopathy.  
  - **DRUSEN**:  
    Yellow deposits under the retina, often found in aging eyes and associated with early signs of age-related macular degeneration (AMD).  
  - **NORMAL**:  
    Healthy retinal scans with no apparent signs of pathology.  

- Images are typically grayscale, center-cropped, and resized to fit the input resolution expected by ConvNeXt.


---

## 📦 Deployment Notes

- Deployment is performed via MMDeploy with ONNX export.
- Backend engines such as ONNXRuntime are used for benchmarking.
- Configuration options like input shape, mean/std normalization, and model path are specified in `deploy_cfg.py`.

---

## 📌 Tips

- Ensure `mmpretrain`, `mmengine`, and `mmdeploy` are installed with compatible versions.
- Due to the large dataset size (~7.85 GB), ensure sufficient disk space before training.
- Use smaller batch sizes (e.g., 16) if CUDA memory is insufficient.
- Exported models can be used in real-time inference setups or edge devices.
