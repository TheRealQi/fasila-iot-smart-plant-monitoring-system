import json
import os
from pathlib import Path
from datetime import datetime
import pytz
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
    from devices.models import SensorsData, Device
    try:
        payload = json.loads(msg.payload.decode())
        if msg.topic == "devices/status/all":
            print(f"Received status message: {payload}")
            device_id = payload.get("device_id")
            status = payload.get("status").strip().lower() == "online"
            Device.objects.update_or_create(
                device_id=device_id,
                defaults={"status": status}
            )
        elif msg.topic == "devices/sensors/all":
            timestamp = datetime.fromisoformat(payload.get("timestamp"))
            d_id = payload.get("device_id", 0)
            device, _ = Device.objects.get_or_create(device_id=d_id)
            sensors = payload.get("sensors", {})
            temperature = sensors.get("temperature")
            humidity = sensors.get("humidity")
            moisture = sensors.get("moisture")
            light_intensity = sensors.get("light")
            nitrogen = sensors.get("nitrogen")
            phosphorus = sensors.get("phosphorus")
            potassium = sensors.get("potassium")
            SensorsData.objects.create(
                device=device,
                timestamp=timestamp,
                temperature=temperature,
                humidity=humidity,
                moisture=moisture,
                light_intensity=light_intensity,
                nitrogen=nitrogen,
                phosphorus=phosphorus,
                potassium=potassium
            )
    except json.JSONDecodeError as e:
        print(f"Failed to decode JSON from message: {e} | Payload: {msg.payload.decode()}")
    except Exception as e:
        print(f"An error occurred: {e}")

client = mqtt.Client()
client.username_pw_set(MQTT_USERNAME, MQTT_PASSWORD)
client.tls_set()
client.on_connect = on_connect
client.on_message = on_message
client.on_disconnect = on_disconnect
client.enable_logger()
client.connect(MQTT_BROKER, MQTT_PORT, 120)