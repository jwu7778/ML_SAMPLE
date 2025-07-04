# 🔍 PaddleOCR Table Structure Recognition Demo

This notebook demonstrates how to use [PaddleOCR](https://github.com/PaddlePaddle/PaddleOCR) for optical character recognition (OCR), and table reading based on the `Table Transformer` model for table reading. Table reading includes loading a sample image, recognizing table structure, and parsing boxes of table to OCR.

---

## 🧪 Demo Workflow (OCR)

1. **Load Image**
   - Example: A test image containing English characters.
   - The image is loaded and displayed to verify its content and format.

2. **Model Initialization**
   - Uses 'PaddleOCR' with default pretrained model for English text.
   - ⚠️ For convenience, the default model is downloaded automatically. If needed, you can switch to another model from PaddleOCR's available options.

3. **Prediction**
   - The loaded image is passed to the recognizer.
   - Predicted text is printed as output.

---

## 🧪 Demo Workflow (Table Reading)

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

5. **Recognition**
   - Parses the grids of the table to OCR
   - Identifies the texts in each grid
   
6. **Exportation**
   - Reformats the recognized texts into a table and saves as xlsx 

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
- Collect predictions and export results as `.md`, `.xlsx`

---

## 📌 Tips

- Padding around images can significantly improve model performance on border-hugging tables.
- Consider integrating with full PaddleOCR pipeline if OCR is needed in addition to structure parsing.
