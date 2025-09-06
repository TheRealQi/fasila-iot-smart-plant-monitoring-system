# Fasila - Smart Plant Monitoring System

Fasila is an integrated smart plant monitoring solution combining IoT devices, a Django backend, an AI disease detection service, and a Flutter mobile app. It enables real-time telemetry, automated actuation (watering, ventilation), AI-based leaf disease detection, and user notifications.

## System Design

```mermaid
graph TD
    subgraph User
        A[Flutter Mobile App]
    end

    subgraph Cloud Infrastructure
        B[Django Backend]
        C[PostgreSQL Database]
        D[Redis]
        E[AI Disease Detection System]
        I[MQTT Broker]
    end

    subgraph IoT Device
        F[Raspberry Pi]
    G[Soil Moisture, Temp/Humidity, NPK, Light, Water Level]
    H[Water Pump, Fan, Light Cover]
    end

    A -- REST API --> B
    B -- Stores/Retrieves Data --> C
    B -- Caching/WebSockets --> D
    F -- Publishes Sensor Data --> I
    B -- Subscribes to Sensor Data --> I
    E -- Sends Detection Results (REST API) --> B
    F -- Reads --> G
    F -- Controls --> H
```

## Project overview

Purpose: monitor plant conditions, automate actuators (watering/ventilation), detect plant diseases using AI, and notify users through mobile app.

Key features:
- Real-time telemetry from Raspberry Pi sensors (MQTT).
- Central Django backend providing REST API and WebSocket endpoints.
- Redis for caching and channels (websockets) support; Celery for background jobs and scheduled tasks.
- AI service for disease detection (image-based) and model artifacts in `AI-System/Models`.
- Flutter mobile app for user interaction and push notifications (FCM).

## Technology stack

- Backend: Python, Django, Django REST Framework, Django Channels (WebSockets), Celery
- Database: PostgreSQL
- Cache / broker: Redis
- Messaging: MQTT (paho-mqtt on device), Firebase Cloud Messaging (push)
- AI: Python, TensorFlow/Keras, OpenCV, Ultralytics (YOLO) for detection
- Frontend: Flutter (Dart)
- IoT: Raspberry Pi, `paho-mqtt`, `gpiozero`, `adafruit-dht`, `spidev`

Dependencies (primary): see `Back-End/requirements.txt` and `Front-End/pubspec.yaml`.

## Quick start (development)

Prerequisites:
- Python 3.9+ (or matching project's interpreter)
- pip, virtualenv
- PostgreSQL
- Redis
- Flutter SDK (for the mobile app)
- (Optional) Docker if you prefer containerized services

Clone the repo:

```bash
git clone https://github.com/your-username/fasila-project.git
cd fasila-project
```

Backend (Django)

```bash
cd Back-End
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
# create .env with SECRET_KEY, DATABASE_URL, REDIS_URL, and any other env vars
python manage.py migrate
python manage.py runserver
```

Notes:
- If using a local PostgreSQL, set DATABASE_URL to `postgres://USER:PASS@HOST:PORT/DBNAME`.
- Ensure `service-account.json` (Firebase) is placed in `Back-End/fasila/service-account.json` or set appropriate env vars.

Frontend (Flutter)

```bash
cd Front-End
flutter pub get
flutter run
```

AI service

```bash
cd AI-System
python -m venv venv-ai
source venv-ai/bin/activate
pip install -r requirements.txt  # if present, otherwise install tensorflow, opencv, etc.
# run inference server or script used by project (adjust path to the project's entrypoint)
python run_inference_service.py
```

IoT device (Raspberry Pi)

- Install Python packages: `paho-mqtt`, `gpiozero`, `adafruit-dht`, etc.
- Configure MQTT broker address (point to cloud or local broker) in device script at `IOT-System/iot_system.py` or `AI-System/System-Pipeline` as used.
- Run the device script:

```bash
python IOT-System/iot_system.py
```

## Environment variables

- `SECRET_KEY` - Django secret
- `DATABASE_URL` - PostgreSQL connection string
- `REDIS_URL` - Redis connection string
- `FCM_CREDENTIALS` / `GOOGLE_APPLICATION_CREDENTIALS` - path to Firebase service account
- AI-specific vars: model paths under `AI-System/Models`

## Directory structure

Top-level layout (trimmed):

```
fasila-project/
├── AI-System/
│   ├── Models/                # trained model files (.pt, .keras, etc.)
│   ├── System-Pipeline/       # AI processing scripts
│   └── Train/                 # notebooks and training assets
├── Back-End/                  # Django project
│   ├── api/
│   ├── communications/
│   ├── devices/
│   ├── fasila/                # Django settings, ASGI, wsgi
│   ├── guide/
│   ├── notifications/
│   └── users/
├── Front-End/                 # Flutter app
│   ├── android/
│   ├── ios/
│   └── lib/
└── IOT-System/
        └── iot_system.py          # Raspberry Pi client
```

## Testing & quality

- Backend: add Django tests under apps' `tests.py` and run `python manage.py test`.
- Frontend: use Flutter's `flutter test` for unit/widget tests.

## Troubleshooting

- If WebSocket connections fail, confirm Redis and Channels layers are reachable and configured.
- If MQTT telemetry is not received, verify the broker address and network connectivity from the device.

## Next steps / Improvements

- Add Docker Compose to spin up Postgres, Redis, MQTT broker, and the backend locally.
- Add a simple CI workflow to run tests and linting on PRs.

---