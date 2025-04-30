from flask import Flask, request, jsonify, Response, url_for
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing.image import load_img, img_to_array
import numpy as np
import os
import json
import cv2
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # Enable CORS for Flutter Web

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
threshold = 0.7  # Confidence threshold for classification

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

    img = load_img(filepath, target_size=image_size)
    img = img_to_array(img) / 255.0
    img = np.expand_dims(img, axis=0)

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

@app.route('/video_feed')
def video_feed():
    return Response(generate_frames(),
                    mimetype='multipart/x-mixed-replace; boundary=frame')

def generate_frames():
    cap = cv2.VideoCapture(0)

    while True:
        success, frame = cap.read()
        if not success:
            break

        h, w, _ = frame.shape
        box_size = 200
        x1 = w // 2 - box_size // 2
        y1 = h // 2 - box_size // 2
        x2 = x1 + box_size
        y2 = y1 + box_size
        roi = frame[y1:y2, x1:x2]

        img = cv2.resize(roi, image_size)
        img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        img = img.astype("float32") / 255.0
        img = np.expand_dims(img, axis=0)

        predictions = model.predict(img)
        confidence = np.max(predictions)

        if confidence < threshold:
            label = "No banana detected"
            color = (0, 0, 255)  # Red color
        else:
            predicted_class = class_names[np.argmax(predictions)]
            label = f"{predicted_class}: {confidence * 100:.2f}%"
            color = (0, 255, 0)  # Green color

        cv2.rectangle(frame, (x1, y1), (x2, y2), color, 2)
        cv2.putText(frame, label, (x1, y1 - 10),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.7, color, 2)

        ret, buffer = cv2.imencode('.jpg', frame)
        frame = buffer.tobytes()

        yield (b'--frame\r\n'
               b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')

    cap.release()

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)