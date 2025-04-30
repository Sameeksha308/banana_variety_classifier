from flask import Flask, request, jsonify, url_for
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing.image import load_img, img_to_array
import numpy as np
import os
import json
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # Enable CORS for Flutter Web

# Folder to save uploaded images
UPLOAD_FOLDER = 'static/uploaded'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Load the trained model
model = load_model("model/banana_classifier_mobilenet.keras")

# Load class labels
with open("model/class_indices.json", "r") as f:
    class_indices = json.load(f)

class_names = list(class_indices.keys())
image_size = (150, 150)
threshold = 0.7  # Minimum confidence for valid classification

@app.route('/')
def home():
    return jsonify({"message": "Flask API for Banana Classifier is running."})

@app.route('/classify', methods=['POST'])
def classify():
    if 'image' not in request.files:
        return jsonify({"error": "No image part"}), 400

    file = request.files['image']
    if file.filename == '':
        return jsonify({"error": "No selected file"}), 400

    filepath = os.path.join(app.config['UPLOAD_FOLDER'], file.filename)
    file.save(filepath)

    # Preprocess image
    img = load_img(filepath, target_size=image_size)
    img = img_to_array(img) / 255.0
    img = np.expand_dims(img, axis=0)

    # Predict
    predictions = model.predict(img)
    confidence = float(np.max(predictions))
    predicted_class = class_names[np.argmax(predictions)]

    if confidence < threshold:
        return jsonify({
            "classification": "No banana detected",
            "confidence": f"{confidence * 100:.2f}",
            "image_url": ""
        })

    return jsonify({
        "classification": predicted_class,
        "confidence": f"{confidence * 100:.2f}",
        "image_url": url_for('static', filename='uploaded/' + file.filename)
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
