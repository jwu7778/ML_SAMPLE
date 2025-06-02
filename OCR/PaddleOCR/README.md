# 🔍 PaddleOCR Table Structure Recognition Demo

This notebook demonstrates how to use [PaddleOCR](https://github.com/PaddlePaddle/PaddleOCR) for table structure recognition based on the `Table Transformer` model provided by Microsoft. It includes loading a sample image, preprocessing it with optional padding, and running structure recognition using pretrained weights.

---

## 🧪 Demo Workflow

1. **Load Image**
   - Example: `PMC1064076_table_0.jpg`
   - Adds optional white edge padding to improve detection accuracy.

2. **Model Initialization**
   - Uses `microsoft/table-transformer-structure-recognition` from Hugging Face.
   - For convenience, the model is downloaded in this demo. If needed, you can replace it by downloading updated weights directly from Hugging Face: https://huggingface.co/microsoft/table-transformer-structure-recognition

3. **Prediction**
   - Detects table structure from image.
   - Outputs bounding boxes and tag sequence information.

4. **(Optional)**: Add margin with the `add_edge_padding` function to improve recognition if the image is tightly cropped.

---

## 🖼️ Sample Input Format

Make sure the input is a `.jpg` or `.png` image of a document table.

Example:

```
PubTables-1M-Structure_Images_Val/
└── PMC1064076_table_0.jpg
```

---

## 🧭 Execution Notes

The notebook is self-contained and designed for demonstration purposes. If adapting to batch processing or datasets:
- Loop over folder of images
- Collect predictions and export results as `.json`, `.csv`, etc.

---

## 📌 Tips

- Padding around images can significantly improve model performance on border-hugging tables.
- Consider integrating with full PaddleOCR pipeline if OCR is needed in addition to structure parsing.
