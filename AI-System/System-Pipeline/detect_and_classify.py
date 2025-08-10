from datetime import datetime
import cv2
import os
import numpy as np
import pytz
import requests
import tensorflow
from tensorflow.keras.models import load_model  # type: ignore
from tensorflow.keras.preprocessing.image import img_to_array, load_img  # type: ignore
from ultralytics import YOLO
import shutil
import sys
import mimetypes
class_labels = [
    "Cucumber__Anthracnose",
    "Cucumber__Bacterial Wilt",
    "Cucumber__Downy Mildew",
    "Cucumber__Fresh Leaf",
    "Cucumber__Gummy_Stem_Blight",
    "Pepper_bell__Bacterial_spot",
    "Pepper_bell__healthy",
    "Tomato___Bacterial_spot",
    "Tomato___Early_blight",
    "Tomato___Late_blight",
    "Tomato___Leaf_Mold",
    "Tomato___Septoria_leaf_spot",
    "Tomato___Spider_mites Two-spotted_spider_mite",
    "Tomato___Target_Spot",
    "Tomato___Yellow_Leaf_Curl_Virus",
    "Tomato___healthy",
    "Tomato___mosaic_virus",
]

diseased_labels = [
    "Cucumber__Anthracnose",
    "Cucumber__Bacterial Wilt",
    "Cucumber__Downy Mildew",
    "Cucumber__Gummy_Stem_Blight",
    "Pepper_bell__Bacterial_spot",
    "Tomato___Bacterial_spot",
    "Tomato___Early_blight",
    "Tomato___Late_blight",
    "Tomato___Leaf_Mold",
    "Tomato___Septoria_leaf_spot",
    "Tomato___Spider_mites Two-spotted_spider_mite",
    "Tomato___Target_Spot",
    "Tomato___Yellow_Leaf_Curl_Virus",
    "Tomato___mosaic_virus",
]

disease_map = {
    "Cucumber__Anthracnose": 1,
    "Cucumber__Bacterial Wilt": 2,
    "Cucumber__Downy Mildew": 3,
    "Cucumber__Gummy_Stem_Blight": 4,
    "Pepper_bell__Bacterial_spot": 5,
    "Tomato___Bacterial_spot": 5,
    "Tomato___Early_blight": 6,
    "Tomato___Late_blight": 7,
    "Tomato___Leaf_Mold": 8,
    "Tomato___Septoria_leaf_spot": 9,
    "Tomato___Spider_mites Two-spotted_spider_mite": 10,
    "Tomato___Target_Spot": 10,
    "Tomato___Yellow_Leaf_Curl_Virus": 11,
    "Tomato___mosaic_virus": 12
}

apiURL = "https://fasila-backend-a1087ba3f9a8.herokuapp.com/api"
cropped_images_dir = "Cropped"
original_images_dir = "sample_dataset"


def send_disease_notification(image_file_path, disease_id, device_id, timestamp):
    """
    Send a disease notification with an image to the API endpoint.
    
    Args:
        image_file_path (str): Path to the image file
        disease_id (str): ID of the detected disease
        device_id (str): ID of the device
        timestamp (str): ISO formatted timestamp of the detection
    
    Returns:
        dict: API response data if successful, None if failed
    """
    # Remove trailing comma and use proper string concatenation
    url = apiURL + '/devices/notification/disease/'
    
    # Define the data payload once - removed duplicate definition
    data = {
        "device_id": device_id,
        "title": "Disease Detected",
        "message": "A disease has been detected on the plant.",
        "severity": "high",
        "disease_id": disease_id,
        "timestamp": timestamp
    }

    try:
        # Verify file exists before attempting to open
        if not os.path.exists(image_file_path):
            print(f"Image file not found: {image_file_path}")
            return None

        with open(image_file_path, 'rb') as image_file:
            # Get proper mime type based on file extension
            mime_type = mimetypes.guess_type(image_file_path)[0] or 'image/jpeg'
            
            files = {
                'disease_image': (
                    os.path.basename(image_file_path),
                    image_file,
                    mime_type
                )
            }
            
            response = requests.post(
                url,
                data=data,
                files=files,
                timeout=30
            )
            
            # Check response status before parsing JSON
            response.raise_for_status()
            return response.json()

    except FileNotFoundError as e:
        print(f"Error: Image file not found - {str(e)}")
        return None
    except requests.RequestException as e:
        print(f"Error: Failed to send disease notification - {str(e)}")
        return None
    except ValueError as e:
        print(f"Error: Invalid JSON response from server - {str(e)}")
        return None
    except Exception as e:
        print(f"Error: Unexpected error while sending notification - {str(e)}")
        return None
def send_healthy_status(device_id):
    url = apiURL + f"/devices/{device_id}/healthy-status/"
    response = requests.patch(url)  # Change to PATCH
    if response.status_code == 200:
        return {"success": True, "response": response.json()}
    else:
        return {"success": False, "status_code": response.status_code, "response": response.json()}

def detection(directory_path):
    yolo_model = YOLO("best (6).pt")
    if os.path.exists(cropped_images_dir):
        shutil.rmtree(cropped_images_dir)
    results = yolo_model.predict(source=directory_path, conf=0.7)
    for result in results:
        result.save_crop(save_dir=cropped_images_dir)






# Function to preprocess and classify images using tensorflow model
def classify_cropped_images():
    timestamp = datetime.now(pytz.UTC).isoformat()
    # Load TensorFlow classification model
    classifier_model = load_model("resnet152.keras")

    # Create classified images directory
    cropped_images_leaf_dir = os.path.join(cropped_images_dir, "leaf")
    classified_images_dir = "classified_images"

    if os.path.exists(classified_images_dir):
        shutil.rmtree(classified_images_dir)

    os.makedirs(classified_images_dir)
    os.makedirs(os.path.join(classified_images_dir, "healthy"))
    os.makedirs(os.path.join(classified_images_dir, "diseased"))

    # Variable to track if any diseased leaves are detected
    disease_detected = False

    for filename in os.listdir(cropped_images_leaf_dir):
        if filename.endswith(".jpg") or filename.endswith(".png"):
            # Load and preprocess the image
            img_path = os.path.join(cropped_images_leaf_dir, filename)
            image = load_img(img_path, target_size=(256, 256))
            image = img_to_array(image)
            image = np.expand_dims(image, axis=0)

            # Predict the class
            prediction = classifier_model.predict(image)
            predicted_class = class_labels[prediction.argmax()]

            # Print the results
            print(f"Image: {filename}, Predicted class: {predicted_class}")

            # Load the cropped image using OpenCV
            img_cv2 = cv2.imread(img_path)

            # Add predicted class text to the image
            font = cv2.FONT_HERSHEY_SIMPLEX
            cv2.putText(
                img_cv2,
                predicted_class,
                (10, 30),
                font,
                1,
                (0, 255, 0),
                2,
                cv2.LINE_AA,
            )

            # Save the image in the corresponding class directory
            if predicted_class in diseased_labels:
                disease_detected = True  # Mark that a disease has been detected
                disease_id = disease_map.get(predicted_class)
                send_disease_notification(img_path, disease_id, 1, timestamp)
                output_path = os.path.join(
                    classified_images_dir,
                    "diseased",
                    f"{predicted_class}_{filename}.jpg",
                )
            else:
                output_path = os.path.join(
                    classified_images_dir,
                    "healthy",
                    f"{predicted_class}_{filename}.jpg",
                )

            # Save the image to the appropriate directory
            cv2.imwrite(output_path, img_cv2)

    # If no diseased leaves were detected, send a healthy status
    if not disease_detected:
        print("No diseased leaves detected. Sending healthy status.")
        send_healthy_status(1)



def get_latest_image(directory):
    files = [
        os.path.join(directory, f)
        for f in os.listdir(directory)
        if f.lower().endswith((".jpg", ".png"))
    ]
    if not files:
        raise FileNotFoundError("No image files found in the directory.")

    # Get the most recently modified file
    latest_file = max(files, key=os.path.getmtime)
    return latest_file


if __name__ == "__main__":

    try:
        latest_image_path = get_latest_image(original_images_dir)
        print(f"Processing latest image: {latest_image_path}")
        detection(latest_image_path)
        classify_cropped_images()
    except FileNotFoundError as e:
        print(str(e))
