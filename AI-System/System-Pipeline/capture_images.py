import cv2
import os
import subprocess
from datetime import datetime

# Define the directory where the image will be saved
save_dir = "/home/qpi/ai_project_pipeline/sample_dataset"

# Create the directory if it doesn't exist
if not os.path.exists(save_dir):
    os.makedirs(save_dir)

# Initialize the camera
camera = cv2.VideoCapture(0)  # Use 0 for the default camera

if not camera.isOpened():
    print("Error: Could not access the camera.")
    exit()

# Capture a single frame
ret, frame = camera.read()

if ret:
    # Generate a unique filename using the current timestamp
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    filename = f"image_{timestamp}.jpg"
    filepath = os.path.join(save_dir, filename)

    # Save the image to the specified directory
    cv2.imwrite(filepath, frame)
    print(f"Image saved at: {filepath}")

    # Run detect_classify.py after saving the image
    subprocess.run(["python3", "/home/qpi/ai_project_pipeline/captureDetect1.py"])

else:
    print("Error: Could not capture an image.")

# Release the camera
camera.release()
