import json
from celery import shared_task
from datetime import datetime
from devices.models import Device, TemperatureSensor, HumiditySensor, SoilMoistureSensor, LightIntensitySensor, \
    NPKSensor


@shared_task
def process_sensor_data(topic, payload):
    try:
        payload = json.loads(payload)
        if topic == "devices/status/all":
            device_id = payload.get("device_id")
            status = payload.get("status", "").strip().lower() == "online"
            Device.objects.update_or_create(
                device_id=device_id,
                defaults={"status": status}
            )
        elif topic.startswith("devices/") and topic.endswith("/sensors"):
            timestamp = datetime.fromisoformat(payload.get("timestamp"))
            d_id = payload.get("device_id", 0)
            device, _ = Device.objects.get_or_create(device_id=d_id)
            sensor_type = payload.get("sensor_type")
            if sensor_type == "temperature_sensor":
                TemperatureSensor.objects.create(
                    device=device,
                    timestamp=timestamp,
                    temperature=payload.get("temperature")
                )
            elif sensor_type == "humidity_sensor":
                HumiditySensor.objects.create(
                    device=device,
                    timestamp=timestamp,
                    humidity=payload.get("humidity")
                )
            elif sensor_type == "moisture_sensor":
                SoilMoistureSensor.objects.create(
                    device=device,
                    timestamp=timestamp,
                    moisture=payload.get("moisture")
                )
            elif sensor_type == "light_intensity_sensor":
                LightIntensitySensor.objects.create(
                    device=device,
                    timestamp=timestamp,
                    light_intensity=payload.get("light_intensity")
                )
            elif sensor_type == "npk_sensor":
                NPKSensor.objects.create(
                    device=device,
                    timestamp=timestamp,
                    nitrogen=payload.get("nitrogen"),
                    phosphorus=payload.get("phosphorus"),
                    potassium=payload.get("potassium")
                )
        print(f"Processed sensor data from topic: {topic}")
    except json.JSONDecodeError:
        print(f"Invalid JSON payload: {payload}")
    except Exception as e:
        print(f"Error processing sensor data: {e}")
