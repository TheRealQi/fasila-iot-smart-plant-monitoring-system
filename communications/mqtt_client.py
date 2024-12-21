import json
import os
from pathlib import Path
from datetime import datetime
import paho.mqtt.client as mqtt
from dotenv import load_dotenv

load_dotenv()
BASE_DIR = Path(__file__).resolve().parent.parent
MQTT_BROKER = os.getenv('MQTT_BROKER')
MQTT_PORT = int(os.getenv('MQTT_PORT'))
MQTT_USERNAME = os.getenv('MQTT_USERNAME')
MQTT_PASSWORD = os.getenv('MQTT_PASSWORD')

MQTT_TOPIC = "#"


def on_connect(client, userdata, flags, rc):
    if rc == 0:
        print(f"Connected successfully to MQTT broker.")
        client.subscribe(MQTT_TOPIC)
        print(f"Subscribed to {MQTT_TOPIC}")
    else:
        print(f"Failed to connect to MQTT broker. Return code: {rc}")


def on_disconnect(client, userdata, rc):
    print(f"Disconnected from MQTT broker with return code: {rc}")


def on_message(client, userdata, msg):
    from devices.models import Device, TemperatureSensor, HumiditySensor, SoilMoistureSensor, LightIntensitySensor, \
        NPKSensor
    try:
        payload = json.loads(msg.payload.decode())
        if not msg.payload:
            print(f"Received empty message from topic: {msg.topic}")
        elif msg.topic == "devices/status/all":
            print(f"Received status message: {payload}")
            d_id = payload.get("device_id")
            status = payload.get("status").strip().lower() == "online"
            Device.objects.update_or_create(
                device_id=d_id,
                defaults={"status": status}
            )
        elif msg.topic.startswith("devices/") and msg.topic.endswith("/sensors"):
            timestamp = datetime.fromisoformat(payload.get("timestamp"))
            d_id = payload.get("device_id", 0)
            device, _ = Device.objects.get_or_create(device_id=d_id)
            if payload.get("sensor_type") == "temperature_sensor":
                TemperatureSensor.objects.create(
                    device=device,
                    timestamp=timestamp,
                    temperature=payload.get("temperature")
                )
            elif payload.get("sensor_type") == "humidity_sensor":
                HumiditySensor.objects.create(
                    device=device,
                    timestamp=timestamp,
                    humidity=payload.get("humidity")
                )
            elif payload.get("sensor_type") == "moisture_sensor":
                SoilMoistureSensor.objects.create(
                    device=device,
                    timestamp=timestamp,
                    moisture=payload.get("moisture")
                )
            elif payload.get("sensor_type") == "light_intensity_sensor":
                LightIntensitySensor.objects.create(
                    device=device,
                    timestamp=timestamp,
                    light_intensity=payload.get("light_intensity")
                )
            elif payload.get("sensor_type") == "npk_sensor":
                NPKSensor.objects.create(
                    device=device,
                    timestamp=timestamp,
                    nitrogen=payload.get("nitrogen"),
                    phosphorus=payload.get("phosphorus"),
                    potassium=payload.get("potassium")
                )
            print(f"Received sensor data: {payload}")
    except json.JSONDecodeError as e:
        print(f"Failed to decode JSON from message: {e} | Payload: {msg.payload.decode()} from topic: {msg.topic}")
    except Exception as e:
        print(f"An error occurred: {e}!!!!!!!!!!!!!!!!!!!!!!!")

def publish_command(command):
    print(f"Publishing command: {command}")
    client.publish("devices/commands", json.dumps(command), qos=1)

client = mqtt.Client()
client.username_pw_set(MQTT_USERNAME, MQTT_PASSWORD)
client.tls_set()
client.on_connect = on_connect
client.on_message = on_message
client.on_disconnect = on_disconnect
client.enable_logger()
client.connect(MQTT_BROKER, MQTT_PORT, 120)
