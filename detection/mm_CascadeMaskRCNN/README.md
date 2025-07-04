# 🧠 OpenMMLab Instance Segmentation + Deployment Tutorial (MMDetection + MMDeploy)

This repository provides a complete workflow for training instance segmentation models using **MMDetection** and deploying them with **MMDeploy**, both part of the OpenMMLab ecosystem.

This version demonstrates the pipeline using the **Mask R-CNN** architecture and the **Balloon** dataset.

The framework is modular and easily extendable to other architectures (e.g., **Cascade Mask R-CNN**, **YOLO** variants) and datasets (e.g., **COCO**, **VOC**).

---

## 📘 Available Notebooks

1. **`MMDet_InstanceSeg_Tutorial.ipynb`**  
   - Demonstrates training a `mask_rcnn_r50_fpn_1x_coco` model using [MMDetection](https://github.com/open-mmlab/mmdetection).
   - Uses the [Balloon dataset](https://github.com/matterport/Mask_RCNN/tree/master/samples/balloon).
   - Includes steps for dataset conversion (to COCO format), config file editing, model training, and visualization of predictions.

2. **`MMDeploy_Tutorial.ipynb`**  
   - Shows how to deploy the trained instance segmentation model with [MMDeploy](https://github.com/open-mmlab/mmdeploy).
   - Covers deployment config generation, model conversion (e.g., to ONNX), and model inference using a backend engine (e.g., ONNXRuntime or TensorRT).

> 📝 You need to complete model training and obtain a checkpoint file before proceeding to deployment.

---

## 📂 Dataset Setup: Balloon

- **Source:** [https://github.com/matterport/Mask_RCNN/tree/master/samples/balloon](https://github.com/matterport/Mask_RCNN/tree/master/samples/balloon)
- **Steps to prepare:**
  1. Download the Balloon dataset JSON annotations and images.
  2. Convert the annotations to COCO format (a helper function is provided in the notebook).
  3. Place the converted dataset under `mmdetection/data/balloon/`.

> 🔧 These preparation steps are included in the training notebook.  
> You may adapt the conversion function for other custom datasets.

---

## 🧾 Dataset Description: Balloon

- **Target:** The Balloon dataset is a small dataset designed to test instance segmentation pipelines. Each image contains one or more balloons with polygon-style instance annotations.
- **Structure:** JSON annotations + image files
- **Data Type:** RGB images
- **Classes:** Single-class (balloon)

---

## 📌 Notes

- Reduce `samples_per_gpu` if CUDA memory is limited.
- Ensure the dataset is properly converted to COCO format to match the model configuration.
- Store only the final or best-performing model checkpoints to save space.
- During deployment, confirm that the backend (e.g., ONNXRuntime, TensorRT) is correctly installed and supported by your hardware.
