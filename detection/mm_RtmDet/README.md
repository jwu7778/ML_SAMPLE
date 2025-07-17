# 🧠 OpenMMLab Object Detection + Deployment Tutorial (MMDetection + MMDeploy, RTMDet)

This tutorial walks through training and deploying object detection models using **MMDetection** and **MMDeploy**, focusing on the lightweight and fast **RTMDet** architecture.

It is suitable for real-time and edge-device applications, and provides a complete pipeline from dataset preparation to model inference.

---

## 📘 Available Notebooks

1. **`MMDet_Detection_Tutorial_RtmDet.ipynb`**  
   - Demonstrates training the `rtmdet_tiny_8xb32-300e_coco` model from [MMDetection](https://github.com/open-mmlab/mmdetection).
   - Uses the **Balloon dataset** for object detection.
   - Covers:
     - Dataset formatting (COCO-style JSON)
     - Model config customization
     - Training and visualization

2. **`MMDeploy_Tutorial.ipynb`**  
   - Shows how to deploy the trained RTMDet model using [MMDeploy](https://github.com/open-mmlab/mmdeploy).
   - Covers:
     - Environment setup
     - Conversion to ONNX or other formats
     - Backend inference (e.g., ONNXRuntime, TensorRT)

> 📝 Train the model first and save a checkpoint file before running deployment steps.

---

## 📂 Dataset Setup: Balloon

- **Source:** [https://github.com/matterport/Mask_RCNN/tree/master/samples/balloon](https://github.com/matterport/Mask_RCNN/tree/master/samples/balloon)
- **Steps to prepare:**
  1. Download and unzip the dataset.
  2. Convert annotations to COCO format if not already.
  3. Place the dataset under `mmdetection/data/balloon`.

> ✅ For this tutorial, the dataset has already been prepared and placed under `mmdetection/data/balloon`.

---

## 🧾 Dataset Description: Balloon

- **Target:** Object detection of balloons in photographs.
- **Classes:**  
  - `balloon`
- **Type:** RGB images with polygon annotations converted to bounding boxes

---

## 📌 Notes

- Adjust `samples_per_gpu` and image scale to fit available memory.
- RTMDet is efficient and fast, suitable for real-time inference.
- Make sure backend engines like ONNXRuntime are correctly installed during deployment.
- Deployment configuration paths must match the training config and checkpoint.
