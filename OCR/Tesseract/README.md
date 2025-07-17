# 🔡 Tesseract OCR Demo for Text Extraction

This notebook demonstrates how to use [Tesseract OCR](https://github.com/tesseract-ocr/tesseract) for extracting printed or handwritten text from images. It walks through the process of image preprocessing, applying OCR, and displaying recognized text using Python bindings.

---

## 🧪 Demo Workflow

1. **Load Image**
   - Uses OpenCV or PIL to load and optionally display the image.
   - Converts to grayscale and applies preprocessing (e.g., thresholding) to enhance OCR accuracy.

2. **Run Tesseract OCR**
   - Text is extracted using `pytesseract.image_to_string()`.
   - Result is displayed directly in the notebook.

3. **Optional Preprocessing**
   - Binarization, resizing, and denoising can improve recognition performance, especially for low-quality scans.

---

## 🖼️ Sample Input Format

Use `.png`, `.jpg`, or `.tiff` images containing printed or scanned text.

Example:

```
data/
└── text_scan_sample.jpg
```

---

## 🧭 Execution Notes

- Works best with high-contrast images and clear font.
- Add additional Tesseract configurations using `config` parameter for fine-tuning (e.g., `--psm`, `--oem`).

---

## 📌 Tips

- For multi-language support, install and specify the desired language model (e.g., `lang='chi_sim'` for Simplified Chinese).
- Preprocessing is key to achieving better accuracy on noisy or low-resolution images.
