# 🦎 Detectron2 Object Detection Tutorial (Faster R-CNN Series)

This repository provides a practical walkthrough for implementing **Faster R-CNN**-based object detection pipelines using [Detectron2](https://github.com/facebookresearch/detectron2), an open-source library developed by Facebook AI Research (FAIR).

The tutorial series focuses on bounding-box object detection using custom datasets. 

---

## 📘 Available Notebooks

1. **`Detectron2_Detection_Tutorial.ipynb`**  
   - Introduction of Detectron2 package. Demonstration of workflow with a simple dataset. You can fit your dataset and choose your model by revising this script.  
   - Dataset: Two animal classes from OpenImagesv7 – tortoise and lizard
   - Format: Pascal VOC dataset

2. **`Detectron2_Train_Detection_of_Chess.ipynb`**  
   - Example of training a model on a custom dataset, evaluating its performance, and running inference on new data.
   - Dataset: Chess pieces (king, queen, bishop, knight, rook, pawn) in black or white 
   - Format: Pascal VOC dataset
   - Highlights: Make train&test split, config adjustments for custom dataset and model

3. **`Inference PreTrained Detection.ipynb`**  
   - Task: Inference using pretrained Faster R-CNN models  
   - Demo: Inference on arbitrary images using built-in weights  
   - Output: Instance boxes, class labels, and confidence scores overlayed on images

---

## 📂 Dataset Setup

### 🐢 Tortoise & Lizard

- **Source:** Custom annotated images, which is a subset of [Open Images v7](https://storage.googleapis.com/openimages/web/download_v7.html)
- **Annotation Format:** unique format, but we have converted it to Pascal VOC when you run the download script
- **Classes:** 
  - `tortoise`  
  - `lizard`  
- **Challenges:** Varying lighting conditions and overlapping
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

### ♟️ Chess Pieces

- **Source:** Manually collected chessboard images by [Gilbert Tanner](https://www.kaggle.com/datasets/tannergi/chess-piece-detection)
- **Annotation Format:** Pascal VOC 
- **Directory Structure:**
  ```
    Chess Detection
    ├── annotations
    │   ├── IMG_1989.xml
    │   ├── IMG_1990.xml
    │   ├── ...
    ├── images
    │   ├── IMG_1989.JPG
    │   ├── IMG_1990.JPG
  ```
- **Classes:** 
  - `king`, `queen`, `bishop`, `knight`, `rook`, `pawn` in black or white  
- **Considerations:** Small object sizes, class imbalance

---

## 📎 Future Extensions

- Mask R-CNN tutorials (instance segmentation)
- Hyperparameter tuning for AP score improvement
- Integration with MMDetection for broader backbone support

