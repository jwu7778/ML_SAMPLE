# 🧠 OpenMMLab Object Detection + Deployment Tutorial (MMDetection + MMDeploy, RTMDet)

This tutorial walks through training and deploying object detection models using **MMDetection** and **MMDeploy**, focusing on the lightweight and fast **RTMDet** architecture.

It is suitable for real-time and edge-device applications, and provides a complete pipeline from dataset preparation to model inference.

---

## 📘 Available Notebooks

1. **`MMDet_Tutorial_Detection.ipynb`**
   - Introduction of MMDetection package. Demonstration of workflow with a simple dataset. You can fit your dataset and choose your model by revising this script.  
   - Task: Object detection on a custom dataset  
   - Dataset: subset of **OpenImagesv7** , including tortoise and lizard
   - Format: Pascal VOC dataset

2. **`MMDet_Tutorial_Detection_balloon_dataset.ipynb`**
   - Example of training a model on a custom dataset, evaluating its performance, and running inference on new data.
   - Dataset: Balloon
   - Format: VGG Json
   - Highlights: Config adjustments for custom dataset
       
3. **`MMDeploy_Tutorial.ipynb`**
   - For the Tortoise & Lizard dataset
   - Shows how to deploy the trained RTMDet model using [MMDeploy](https://github.com/open-mmlab/mmdeploy).
   - Covers:
     - Environment setup
     - Conversion to ONNX or other formats
     - Backend inference (e.g., ONNXRuntime, TensorRT)

4. **`MMDeploy_Tutorial_balloon_dataset.ipynb`**
   - Same as 3, but for balloon dataset

> 📝 Train the model first and save a checkpoint file before running deployment steps.

---
### 🐢 Dataset: Tortoise & Lizard

- **Source:** Custom annotated images, which is a subset of [Open Images v7](https://storage.googleapis.com/openimages/web/download_v7.html)
- **Annotation Format:** unique format, but we have converted it to Pascal VOC when you run the download script
- **Classes:** 
  - `tortoise`  
  - `lizard`  
- **Directory Structure:**
  ```
    ├── train
    │   ├── image1
    │   ├── image1.xml
    │   ├── image2
    │   └── image2.xml
    └── validation
        ├── image1
        ├── image1.xml
        ├── image2
        └── image2.xml
  ```

## 🧾 Dataset: Balloon
- **Source:** [https://github.com/matterport/Mask_RCNN/tree/master/samples/balloon](https://github.com/matterport/Mask_RCNN/tree/master/samples/balloon)
- **Target:** Object detection of balloons in photographs.
- **Classes:**  
  - `balloon`
- **Type:** RGB images with polygon annotations converted to bounding boxes as VGG Json

---

## 📌 Notes

- Adjust `samples_per_gpu` and image scale to fit available memory.
- RTMDet is efficient and fast, suitable for real-time inference.
- Make sure backend engines like ONNXRuntime are correctly installed during deployment.
- Deployment configuration paths must match the training config and checkpoint.
