# CnOCR Demo for Chinese Text Recognition

This notebook demonstrates how to use [CnOCR](https://github.com/breezedeus/CnOCR) for optical character recognition (OCR) of Chinese characters. It includes loading sample images, initializing a pretrained model, and predicting the text content directly from images.

---

## 🧪 Demo Workflow

1. **Load Image**
   - Example: A test image containing Chinese characters.
   - The image is loaded and displayed to verify its content and format.

2. **Model Initialization**
   - Uses `CnOcr` with default pretrained model for Chinese text.
   - ⚠️ For convenience, the default model is downloaded automatically. If needed, you can switch to another model from CnOCR's available options.

3. **Prediction**
   - The loaded image is passed to the recognizer.
   - Predicted Chinese text is printed as output.

---

## 🖼️ Sample Input Format

Ensure that the input is a `.jpg`, `.png`, or other supported format containing horizontal Chinese text.

Example:

```
data/
└── sample_text.jpg
```

---

## 🧭 Execution Notes

- This notebook is ideal for testing single or a few images.
- For batch processing, consider iterating over a folder of images and collecting results in a list or DataFrame.

---

## 📌 Tips

- Ensure image contrast and resolution are adequate for optimal recognition.
- For vertical text or multiple lines, refer to CnOCR documentation for extended support.
