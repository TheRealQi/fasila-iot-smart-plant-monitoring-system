# Fasila Project

## Overview

**Fasila** is a comprehensive smart agriculture ecosystem designed to modernize plant care through IoT monitoring, AI-driven disease detection, and remote management. It bridges the gap between traditional farming and precision agriculture, enabling users to monitor environmental conditions, automate care routines, and diagnose plant health issues in real-time via a mobile interface.

### Key Features

-   **IoT Monitoring Station**: Real-time tracking of critical environmental metrics:
    -   Soil Moisture
    -   Temperature & Humidity (DHT22)
    -   Soil Nutrients (NPK)
    -   Light Intensity
    -   Water Tank Levels
-   **Intelligent Automation**:
    -   Automated irrigation based on moisture levels.
    -   Smart ventilation (fan control) triggered by temperature/humidity thresholds.
    -   Automated protective shading (motorized cover) responsive to light intensity.
-   **AI Disease Diagnosis**:
    -   Computer vision pipeline using YOLO for leaf detection and ResNet152 for disease classification.
    -   Identifies various diseases in plants like Tomatoes, Cucumbers, and Bell Peppers.
-   **Mobile Command Center**:
    -   Flutter-based mobile app for data visualization.
    -   Push notifications for disease alerts (via Firebase).
    -   Plant encyclopedia and care guides.

---

## System Architecture

The system operates on a decoupled architecture where the IoT components communicate via MQTT, while the AI system interacts with the backend via REST APIs.

```mermaid
graph TD
    subgraph "IoT Node (Raspberry Pi)"
        Sensors[Sensors: Soil, NPK, DHT, Light] -->|Data| IoT_Core[iot_system.py]
        IoT_Core -->|Action| Actuators[Relays, Pumps, Fan, Motor]
        IoT_Core -->|MQTT Pub/Sub| MQTT_Broker[HiveMQ Broker]
    end

    subgraph "AI Diagnostics"
        Camera[Camera] -->|Stream| Capture[capture_images.py]
        Capture -->|Image| Pipeline[detect_and_classify.py]
        Pipeline -->|YOLOv8| Leaf_Det[Leaf Detection]
        Leaf_Det -->|ResNet152| Disease_Clf[Disease Classification]
        Disease_Clf -->|HTTP POST| Backend_API
    end

    subgraph "Backend Infrastructure (Django)"
        MQTT_Broker -->|Daphne/Channels| Django_Service[Django Backend]
        Django_Service -->|Persist| DB[(PostgreSQL)]
        Django_Service -->|Cache/Queue| Redis[Redis]
        Django_Service -->|Store Media| S3[AWS S3]
        Django_Service -->|Push Alerts| FCM[Firebase Cloud Messaging]
    end

    subgraph "User Interface (Mobile)"
        Mobile_App[Flutter App] -->|REST API| Backend_API[DRF API Endpoints]
        Mobile_App -->|WebSocket| Django_Service
        FCM -->|Alerts| Mobile_App
    end
```

---

## Directory Structure

```text
fasila-project/
├── AI-System/                  # Computer Vision & Machine Learning
│   ├── Models/                 # Trained model weights (.pt, .keras)
│   ├── System-Pipeline/        # Detection & Classification scripts
│   └── Train/                  # Training notebooks (Jupyter)
├── Back-End/                   # Server-side Application (Django)
│   ├── api/                    # REST API endpoints & Logic
│   ├── communications/         # MQTT & WebSocket consumers
│   ├── devices/                # IoT Device management
│   ├── fasila/                 # Project Configuration (Settings, URLs)
│   ├── notifications/          # Firebase integration
│   ├── users/                  # Authentication & User mgmt
│   ├── manage.py               # Django entry point
│   └── requirements.txt        # Python dependencies
├── IOT-System/                 # Hardware Logic
│   └── iot_system.py           # Main Raspberry Pi controller script
├── Mobile-Application/         # User Interface
│   ├── lib/                    # Dart code (Screens, Controllers, Models)
│   ├── android/                # Android platform files
│   ├── ios/                    # iOS platform files
│   └── pubspec.yaml            # Flutter dependencies
└── README.md                   # Documentation
```

---

## Technologies & Frameworks

### Backend
-   **Framework**: Django 5.1, Django REST Framework
-   **Real-time**: Django Channels, Daphne, Redis
-   **Database**: PostgreSQL
-   **Storage**: AWS S3
-   **Protocol**: MQTT (Paho MQTT), HTTP
-   **Hosting**: Heroku (inferred from configuration)

### Mobile Application
-   **Framework**: Flutter (Dart)
-   **State Management**: GetX
-   **Charts/UI**: Syncfusion Charts, GetWidget
-   **Notifications**: Firebase Cloud Messaging (FCM)

### Artificial Intelligence
-   **Object Detection**: YOLO (Ultralytics)
-   **Classification**: TensorFlow/Keras (ResNet152)
-   **Image Processing**: OpenCV

### IoT / Embedded
-   **Hardware**: Raspberry Pi
-   **Sensors**: DHT22 (Temp/Hum), Capacitive Soil Moisture, JXCT NPK, BH1750 (Light), HC-SR04 (Ultrasonic)
-   **Libraries**: `gpiozero`, `spidev`, `adafruit-circuitpython-dht`

---

## Getting Started

Follow these instructions to set up the environment locally.

### Prerequisites
-   Python 3.10+
-   Flutter SDK
-   Redis Server (for Backend/Channels)
-   PostgreSQL
-   Raspberry Pi (for IoT setup)

### 1. Backend Setup (Django)

1.  **Navigate to the backend directory:**
    ```bash
    cd Back-End
    ```

2.  **Create virtual environment & install dependencies:**
    ```bash
    python -m venv venv
    source venv/bin/activate  # Windows: venv\Scripts\activate
    pip install -r requirements.txt
    ```

3.  **Environment Configuration:**
    Create a `.env` file in `Back-End/` with the following keys (see `fasila/settings.py` for reference):
    ```env
    SECRET_KEY=your_secret_key
    DEBUG=True
    DATABASE_URL=postgres://user:password@localhost:5432/fasila_db
    REDIS_URL=redis://localhost:6379/0
    AWS_ACCESS_KEY_ID=...
    AWS_SECRET_ACCESS_KEY=...
    # Add other keys required by settings.py
    ```

4.  **Run Migrations & Server:**
    ```bash
    python manage.py migrate
    python manage.py runserver
    ```

### 2. Mobile App Setup (Flutter)

1.  **Navigate to the mobile app directory:**
    ```bash
    cd Mobile-Application
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run the application:**
    Ensure you have an emulator running or a physical device connected.
    ```bash
    flutter run
    ```

### 3. AI System Setup

1.  **Navigate to the pipeline directory:**
    ```bash
    cd AI-System/System-Pipeline
    ```

2.  **Model Configuration:**
    Ensure the model files are present in `AI-System/Models/` or the root of the pipeline script directory.
    *   **Note**: The script `detect_and_classify.py` expects the classification model to be named `resnet152.keras`. You may need to rename `resnet152_98.16%.keras` to `resnet152.keras`.

3.  **Run the Pipeline:**
    ```bash
    # Install AI dependencies if not already done
    pip install tensorflow ultralytics opencv-python requests

    # Run the detection script
    python detect_and_classify.py
    ```

### 4. IoT System Setup

1.  **Transfer code to Raspberry Pi:**
    Copy `IOT-System/iot_system.py` and create a `.env` file with MQTT credentials.

2.  **Wiring:**
    Connect sensors to the GPIO pins defined in `iot_system.py` (e.g., Relay1: GPIO 17, Relay2: GPIO 27, DHT: GPIO 4).

3.  **Run the Controller:**
    ```bash
    python iot_system.py
    ```