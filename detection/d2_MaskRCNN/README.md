# 🎈 Detectron2 Instance Segmentation Tutorial (Mask R-CNN Series)

This repository provides a complete tutorial series on using **Mask R-CNN** for instance segmentation with [Detectron2](https://github.com/facebookresearch/detectron2), a modular and flexible object detection framework developed by Facebook AI Research (FAIR).

Mask R-CNN not only detects object bounding boxes but also generates a high-quality segmentation mask for each instance, making it a powerful tool for pixel-level analysis in computer vision.

---

## 📘 Available Notebooks

1. **`Detectron2_Train_Instance_Segmentation_with_Augmentation_(Balloon).ipynb`**  
   - Task: Instance segmentation on a custom dataset (balloons)  
   - Dataset: From Matterport’s balloon segmentation demo  
   - Workflow:
     - COCO-style annotation loading  
     - Dataset registration for Detectron2  
     - Data augmentation configuration  
     - Mask R-CNN model training and visualization

2. **`Inference PreTrained Instance Segmentation.ipynb`**  
   - Task: Inference using pretrained Mask R-CNN models  
   - Demo: Inference on arbitrary images using built-in weights  
   - Output: Instance masks, class labels, and confidence scores overlayed on images

---

## 🎨 Dataset Setup

### 🎈 Balloon Dataset

- **Source:** [Matterport Balloon Dataset](https://github.com/matterport/Mask_RCNN/tree/master/samples/balloon) provided by Waleed Abdulla
- **Format:** COCO JSON  
- **Structure:** 
  ```
  ├── train/
  │   ├── 123.jpg
  │   ├── ...
  │   └── via_region_data.json
  └── val/
      ├── 456.jpg
      ├── ...
      └── via_region_data.json
  ```
- **Classes:** Single class - `balloon`  
- **Purpose:** Simple but effective dataset to demonstrate instance segmentation tasks with non-rectangular objects.

---

## 📌 Notes & Tips

- Use `DefaultTrainer` or build a custom trainer for flexible training logic
- Masks are automatically matched with class labels using COCO annotation format
- Use `Visualizer(draw_instance_predictions)` to overlay masks with transparency
- Resize images or limit batch size to reduce memory consumption

---

## 🔜 Future Work

- Multi-class instance segmentation examples
- Custom annotation via VGG or LabelMe + conversion
- Combining instance segmentation with classification

