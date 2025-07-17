# 🦎 Detectron2 Object Detection Tutorial (Faster R-CNN Series)

This repository provides a practical walkthrough for implementing **Faster R-CNN**-based object detection pipelines using [Detectron2](https://github.com/facebookresearch/detectron2), an open-source library developed by Facebook AI Research (FAIR).

The tutorial series focuses on bounding-box object detection using custom datasets. It includes **multi-class detection** (e.g., chess pieces), as well as how to run inference using pretrained models.

---

## 📘 Available Notebooks

1. **`Detectron2_Set_up_and_Train_Detection_(Tortoise_and_Lizard).ipynb`**  
   - Task: Multi-class detection  
   - Dataset: Two animal classes – tortoise and lizard  
   - Format: Annotated via **VGG Image Annotator (VIA)** and converted to Detectron2 JSON  
   - Workflow: Data registration → Config setup → Model training → Result visualization

2. **`Detectron2_Train_Detection_of_Multiclasses_(Chess).ipynb`**  
   - Task: Multi-class object detection  
   - Dataset: Chess pieces (king, queen, bishop, knight, rook, pawn)  
   - Format: COCO-style JSON format  
   - Highlights: Class-balanced setup, config adjustment for multi-class support

3. **`Inference PreTrained Detection.ipynb`**  
   - Task: Inference using pretrained Faster R-CNN models  
   - Demo: Inference on arbitrary images using built-in weights  
   - Output: Instance boxes, class labels, and confidence scores overlayed on images

---

## 📂 Dataset Setup

### 🐢 Tortoise & Lizard

- **Source:** Custom annotated images, which is a subset of [Open Images v7](https://storage.googleapis.com/openimages/web/download_v7.html)
- **Tool:** [VGG Image Annotator (VIA)](http://www.robots.ox.ac.uk/~vgg/software/via/)
- **Annotation Format:** VIA JSON converted to Detectron2-compatible format
- **Image Characteristics:** Natural outdoor scenes with two animal species  
- **Classes:** 
  - `tortoise`  
  - `lizard`  
- **Challenges:** Varying lighting conditions and overlapping species

### ♟️ Chess Pieces

- **Source:** Manually collected chessboard images by [Gilbert Tanner](https://www.kaggle.com/datasets/tannergi/chess-piece-detection)
- **Annotation Format:** COCO JSON  
- **Directory Structure:**
  ```
  ├── images/
  │   ├── chess_001.jpg
  │   └── ...
  └── annotations/
      └── instances_chess.json
  ```
- **Classes:** 
  - `king`, `queen`, `bishop`, `knight`, `rook`, `pawn`  
- **Considerations:** Small object sizes, class imbalance

---

## 📎 Future Extensions

- Mask R-CNN tutorials (instance segmentation)
- Hyperparameter tuning for AP score improvement
- Integration with MMDetection for broader backbone support

