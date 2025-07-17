# 🧠 OpenMMLab Instance Segmentation + Deployment Tutorial (MMDetection + MMDeploy)

This repository provides a complete workflow for training instance segmentation models using **MMDetection** and deploying them with **MMDeploy**, both part of the OpenMMLab ecosystem.

This version demonstrates the pipeline using the **Mask R-CNN** architecture and the **Balloon** dataset.

The framework is modular and easily extendable to other architectures (e.g., **Cascade Mask R-CNN**, **YOLO** variants) and datasets (e.g., **COCO**).

---

## 📘 Available Notebooks

1. **`MMDet_Tutorial_Instance_Segmentation.ipynb`**
   - Introduction of MMDetection package. Demonstration of workflow with a simple dataset. You can fit your dataset and choose your model by revising this script.  
   - Demonstrates training a `mask_rcnn_r50_fpn_1x_coco` model on a balloon dataset.
   - Includes steps for dataset conversion (to COCO format), config file editing, model training, and visualization of predictions.

2. **`MMDeploy_Tutorial.ipynb`**  
   - Shows how to deploy the trained instance segmentation model with [MMDeploy](https://github.com/open-mmlab/mmdeploy).
   - Covers deployment config generation, model conversion (e.g., to ONNX), and model inference using a backend engine (e.g., ONNXRuntime or TensorRT).

> 📝 You need to complete model training and obtain a checkpoint file before proceeding to deployment.

---

## 🎈 Dataset Description: Balloon
- **Source:** [Matterport Balloon Dataset](https://github.com/matterport/Mask_RCNN/tree/master/samples/balloon) provided by Waleed Abdulla
- **Target:** Simple but effective dataset to demonstrate instance segmentation tasks with non-rectangular objects. Each image contains one or more balloons with polygon-style instance annotations.
- **Format:**  LabelMe JSON  
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

## 📌 Notes

- Reduce `samples_per_gpu` if CUDA memory is limited.
- Ensure the dataset is properly converted to COCO format to match the model configuration.
- Store only the final or best-performing model checkpoints to save space.
- During deployment, confirm that the backend (e.g., ONNXRuntime, TensorRT) is correctly installed and supported by your hardware.
