import json
import os
from pathlib import Path
from datetime import datetime
import paho.mqtt.client as mqtt
from asgiref.sync import async_to_sync
from channels.layers import get_channel_layer
from dotenv import load_dotenv

from devices.models import WaterTank

load_dotenv()
BASE_DIR = Path(__file__).resolve().parent.parent
MQTT_BROKER = os.getenv('MQTT_BROKER')
MQTT_PORT = int(os.getenv('MQTT_PORT'))
MQTT_USERNAME = os.getenv('MQTT_USERNAME')
MQTT_PASSWORD = os.getenv('MQTT_PASSWORD')

MQTT_TOPIC = "#"


def on_connect(client, userdata, flags, rc):
    if rc == 0:
        client.subscribe(MQTT_TOPIC)


def on_disconnect(client, userdata, rc):
    pass


def on_message(client, userdata, msg):
    from devices.models import Device, TemperatureSensor, HumiditySensor, SoilMoistureSensor, LightIntensitySensor, \
        NPKSensor
    try:
        payload = json.loads(msg.payload.decode())
        if not msg.payload:
            return
        elif msg.topic == "devices/status/all":
            d_id = payload.get("device_id")
            status = payload.get("status").strip().lower() == "online"
            Device.objects.update_or_create(
                device_id=d_id,
                defaults={"status": status}
            )
        elif msg.topic == "devices/top_cover":
            print(f"Received top cover status: {payload}")
            d_id = payload.get("device_id")
            value = payload.get("value").strip().lower() == "closed"
            try:
                device, created = Device.objects.update_or_create(
                    device_id=d_id,
                    defaults={"top_cover": value}
                )
                channel_layer = get_channel_layer()
                async_to_sync(channel_layer.group_send)(
                    f"device_updates_{d_id}",
                    {
                        "type": "top.cover",
                        "message": {
                            "device_id": d_id,
                            "top_cover": value,
                        },
                    },
                )
            except Exception as e:
                print(f"Error updating top cover: {e}")
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
            elif payload.get("tank_type") in ["npk", "irrigation"]:
                WaterTank.objects.create(
                    device=device,
                    timestamp=timestamp,
                    tank_type=payload.get("tank_type"),
                    water_level=payload.get("water_level")
                )
    except Exception as e:
        print(f"Error processing message: {e}")


def publish_command(command):
    pass


client = mqtt.Client()
client.username_pw_set(MQTT_USERNAME, MQTT_PASSWORD)
client.tls_set()
client.on_connect = on_connect
client.on_message = on_message
client.on_disconnect = on_disconnect
client.enable_logger()
client.connect(MQTT_BROKER, MQTT_PORT, 120)
