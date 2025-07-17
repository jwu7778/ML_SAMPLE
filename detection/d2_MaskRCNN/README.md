# 🎈 Detectron2 Instance Segmentation Tutorial (Mask R-CNN Series)

This repository provides a complete tutorial series on using **Mask R-CNN** for instance segmentation with [Detectron2](https://github.com/facebookresearch/detectron2), a modular and flexible object detection framework developed by Facebook AI Research (FAIR).

Mask R-CNN not only detects object bounding boxes but also generates a high-quality segmentation mask for each instance, making it a powerful tool for pixel-level analysis in computer vision.

---

## 📘 Available Notebooks

1. **`Detectron2_Tutorial_Instance_Segmentation.ipynb`**
   - Introduction of Detectron2 package. Demonstration of workflow with a simple dataset. You can fit your dataset and choose your model by revising this script.  
   - Task: Instance segmentation on a custom dataset (balloons)  
   - Dataset: From Matterport’s balloon segmentation demo  
   - Workflow:
     - LabelMe-style annotation loading  
     - Dataset registration for Detectron2  
     - Data augmentation configuration  
     - Mask R-CNN model training and visualization

3. **`Inference PreTrained Instance Segmentation.ipynb`**  
   - Task: Inference using pretrained Mask R-CNN models  
   - Demo: Inference on arbitrary images using built-in weights  
   - Output: Instance masks, class labels, and confidence scores overlayed on images

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

## 📌 Notes & Tips

- Use `DefaultTrainer` or build a custom trainer for flexible training logic
- Use `Visualizer(draw_instance_predictions)` to overlay masks with transparency
- Resize images or limit batch size to reduce memory consumption

---


