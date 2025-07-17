# 🧠 OpenMMLab Object Detection Tutorial (MMDetection, DINO)

This tutorial demonstrates how to train object detection models using **MMDetection**, focusing on the advanced **DINO** detector with transformer-based backbones.

It is designed as a complete and modular pipeline, and can be easily adapted to other models (e.g., **YOLOX**, **Faster R-CNN**) and datasets (e.g., **COCO**, **VOC**, custom datasets).

---

## 📘 Available Notebook

**`MMDet_Detection_Tutorial_DINO.ipynb`**
- Demonstrates how to use the `dino-5scale_r50_8xb2-12e_coco` model from [mmdetection](https://github.com/open-mmlab/mmdetection).
- Includes steps for:
  - Environment setup and model selection.
  - Dataset preparation using Pascal VOC 2012 format.
  - Configuration and training.
  - Inference and visualization of detection results.

> 📝 This tutorial uses a subset of the VOC2012 dataset, converted into COCO format. Custom datasets can be adapted similarly.

---

## 📂 Dataset Setup: Pascal VOC 2012

- **Source:** [http://host.robots.ox.ac.uk/pascal/VOC/voc2012/](http://host.robots.ox.ac.uk/pascal/VOC/voc2012/VOCtrainval_11-May-2012.tar)
- **Steps to prepare:**
  1. Download the VOC2012 dataset and extract it.
  2. Convert it into COCO format using `voc2coco.py` or other scripts (e.g., [mmdetection tools](https://github.com/open-mmlab/mmdetection/tree/main/tools/dataset_converters)).
  3. Organize the dataset directory under `mmdetection/data/VOCdevkit/VOC2012`.

> 🔧 This notebook includes instructions to handle VOC annotations and integrate them into the MMDetection framework.

---

## 🧾 Dataset Description: Pascal VOC

- **Target:** The VOC2012 dataset is a classic object detection benchmark with annotations for 20 object categories.
- **Structure:** XML-based annotations (converted to COCO in this workflow)
- **Data Type:** RGB images
- **Classes (Subset):** Includes 'bicycle', 'bus', 'car', 'motorcycle', 'train'. — the specific subset can be adjusted in `classes`.

---

## 📌 Notes

- Reduce batch size (`samples_per_gpu`) if you encounter CUDA OOM errors.
- Make sure to adjust the dataset path and class list in the config file.
- Use `load_from` to initialize weights from pretrained checkpoints for transfer learning.
- Use `test.py` or `inference_detector()` for evaluation on validation/test data.
