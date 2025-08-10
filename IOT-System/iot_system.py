import spidev
import time
from gpiozero import OutputDevice, Motor, DistanceSensor
import adafruit_dht
import board
import serial
from smbus2 import SMBus
import json
import paho.mqtt.client as mqtt
from datetime import datetime
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# MQTT Configuration
MQTT_BROKER = "05351218d78548feaefac83186a8c274.s1.eu.hivemq.cloud"
MQTT_PORT = 8883
MQTT_USERNAME = "device"
MQTT_PASSWORD = "Device1@"
DEVICE_ID = 1

STATUS_TOPIC = "devices/status/all"

LWT_PAYLOAD = json.dumps({
    "device_id": 1,
    "status": "offline",
})

# Initialize MQTT Client
client = mqtt.Client()
client.username_pw_set(MQTT_USERNAME, MQTT_PASSWORD)
client.tls_set()

# Hardware Constants
SOIL_SENSOR_CHANNEL = 0
RELAY1_PIN = 17
RELAY2_PIN = 27
CALIBRATION_DRY = 500
CALIBRATION_WET = 248
THRESHOLD_PERCENTAGE = 40
NPK_THRESHOLD = 12
MOTOR_FORWARD_PIN = 26
MOTOR_BACKWARD_PIN = 16
BH1750_ADDRESS = 0x23
CONT_HRES_MODE = 0x10
LUX_THRESHOLD = 100
TANK1_TRIGGER_PIN = 6
TANK1_ECHO_PIN = 5
TANK2_TRIGGER_PIN = 23
TANK2_ECHO_PIN = 24
# Initialize Hardware
relay1 = OutputDevice(RELAY1_PIN, active_high=True, initial_value=False)
relay2 = OutputDevice(RELAY2_PIN, active_high=True, initial_value=False)
spi = spidev.SpiDev()
spi.open(0, 0)
spi.max_speed_hz = 70000
dht_device = adafruit_dht.DHT22(board.D4)
mod = serial.Serial('/dev/ttyAMA0', baudrate=9600, timeout=2)
bus = SMBus(1)
motor = Motor(forward=MOTOR_FORWARD_PIN, backward=MOTOR_BACKWARD_PIN)

# NPK inquiry frames
nitro = bytearray([0x01, 0x03, 0x00, 0x1e, 0x00, 0x01, 0xe4, 0x0c])
phos = bytearray([0x01, 0x03, 0x00, 0x1f, 0x00, 0x01, 0xb5, 0xcc])
pota = bytearray([0x01, 0x03, 0x00, 0x20, 0x00, 0x01, 0x85, 0xc0])

# Initialize sensors
tank1_sensor = DistanceSensor(echo=TANK1_ECHO_PIN, trigger=TANK1_TRIGGER_PIN)
tank2_sensor = DistanceSensor(echo=TANK2_ECHO_PIN, trigger=TANK2_TRIGGER_PIN)

RELAY3_PIN = 22  # GPIO pin for fan relay
TEMP_THRESHOLD = 10  # Temperature threshold in Celsius
HUMIDITY_THRESHOLD = 80  # Humidity threshold in percentage
relay3 = OutputDevice(RELAY3_PIN, active_high=True, initial_value=False)


def control_fan(temperature, humidity):
    """
    Control the fan based on temperature and humidity thresholds.
    Turns the fan on if either temperature or humidity exceeds the threshold.
    """
    if temperature > TEMP_THRESHOLD or humidity > HUMIDITY_THRESHOLD:
        print("Threshold exceeded: Turning on the fan.")
        relay3.on()
    else:
        print("Threshold not met: Turning off the fan.")
        relay3.off()


def on_connect(client, userdata, flags, rc):
    if rc == 0:
        print("Connected to MQTT broker")
        # Send online status
        publish_device_status("online")
        # Subscribe to command topic
        client.subscribe(f"devices/{DEVICE_ID}/commands")
    else:
        print(f"Connection failed with code {rc}")

def on_message(client, userdata, msg):
    pass


def publish_sensor_data(sensor_type, data):
    payload = {
        "device_id": DEVICE_ID,
        "sensor_type": sensor_type,
        "timestamp": datetime.now().isoformat(),
        **data
    }
    client.publish(f"devices/{DEVICE_ID}/sensors", json.dumps(payload))


def publish_device_status(status):
    payload = {
        "device_id": DEVICE_ID,
        "status": status
    }
    client.publish("devices/status/all", json.dumps(payload))


def publish_cover_status(is_open):
    payload = {
        "device_id": DEVICE_ID,
        "value": str(is_open).lower()
    }
    client.publish(f"devices/top_cover", json.dumps(payload))


def publish_tank_level(tank_type, level):
    payload = {
        "device_id": DEVICE_ID,
        "tank_type": tank_type,
        "water_level": level,
        "timestamp": datetime.now().isoformat(),
    }
    client.publish(f"devices/{DEVICE_ID}/sensors", json.dumps(payload))


def read_and_publish_soil_moisture():
    soil_moisture = read_adc(SOIL_SENSOR_CHANNEL)
    moisture_percentage = adc_to_percentage(soil_moisture)
    publish_sensor_data("moisture_sensor", {"moisture": moisture_percentage})
    return moisture_percentage


def read_and_publish_dht():
    try:
        temperature = dht_device.temperature
        humidity = dht_device.humidity
        publish_sensor_data("temperature_sensor", {"temperature": temperature})
        publish_sensor_data("humidity_sensor", {"humidity": humidity})
        return temperature, humidity
    except RuntimeError as err:
        print(f"DHT sensor error: {err.args[0]}")
        return None, None


def read_and_publish_npk():
    nitrogen = request_and_print("Nitrogen (N)", nitro)
    phosphorus = request_and_print("Phosphorus (P)", phos)
    potassium = request_and_print("Potassium (K)", pota)
    if all(v is not None for v in [nitrogen, phosphorus, potassium]):
        publish_sensor_data("npk_sensor", {
            "nitrogen": nitrogen,
            "phosphorus": phosphorus,
            "potassium": potassium
        })
    return nitrogen, phosphorus, potassium


def read_and_publish_light():
    lux = read_lux()
    if lux is not None:
        publish_sensor_data("light_intensity_sensor", {"light_intensity": lux})
    return lux


# Original helper functions remain the same
def read_adc(channel):
    if channel < 0 or channel > 7:
        raise ValueError("Channel must be between 0 and 7.")
    adc = spi.xfer2([1, (8 + channel) << 4, 0])
    return ((adc[1] & 3) << 8) + adc[2]


def adc_to_percentage(adc_value):
    adc_value = max(min(adc_value, CALIBRATION_DRY), CALIBRATION_WET)
    return 100 * (CALIBRATION_DRY - adc_value) / (CALIBRATION_DRY - CALIBRATION_WET)


def request_and_print(element_name, inquiry):
    mod.write(inquiry)
    time.sleep(1)
    values = mod.read(7)
    if len(values) == 7:
        value = (values[3] << 8) | values[4]
        return value
    return None


def read_lux():
    try:
        data = bus.read_i2c_block_data(BH1750_ADDRESS, CONT_HRES_MODE, 2)
        lux = (data[0] << 8) | data[1]
        return lux / 1.2
    except Exception as e:
        print(f"BH1750 sensor error: {e}")
        return None


def get_tank_level(distance):
    if distance >= 25:
        return 0
    elif distance >= 20:
        return 25
    elif distance >= 15:
        return 50
    elif distance >= 10:
        return 75
    else:
        return 100
        
# Set up MQTT callbacks
client.on_connect = on_connect
client.on_message = on_message


# Main loop
def main():
    try:
        # Connect to MQTT broker'
        client.will_set(STATUS_TOPIC, LWT_PAYLOAD, qos=1, retain=True)
        client.connect(MQTT_BROKER, MQTT_PORT, 120)
        client.loop_start()

        last_state = None
        while True:
            # Soil moisture monitoring and control
            moisture_percentage = read_and_publish_soil_moisture()
            relay1.on() if moisture_percentage < THRESHOLD_PERCENTAGE else relay1.off()

            # Temperature and humidity monitoring
            temperature, humidity = read_and_publish_dht()
            if temperature is not None and humidity is not None:
                control_fan(temperature, humidity)
            # NPK monitoring and control
            npk_values = read_and_publish_npk()
            if npk_values and any(n < NPK_THRESHOLD for n in npk_values if n is not None):
                relay2.on()
            else:
                relay2.off()

            # Tank level monitoring
            tank1_level = get_tank_level(tank1_sensor.distance * 100)
            tank2_level = get_tank_level(tank2_sensor.distance * 100)
            publish_tank_level("irrigation", tank1_level)
            publish_tank_level("npk", tank2_level)

            # Light intensity monitoring and control
            lux = read_and_publish_light()
            if lux is not None:
                if lux > LUX_THRESHOLD and last_state != "forward":
                    motor.forward()
                    time.sleep(4)
                    motor.stop()
                    last_state = "forward"
                    publish_cover_status(True)
                elif lux <= LUX_THRESHOLD and last_state != "backward":
                    motor.backward()
                    time.sleep(4)
                    motor.stop()
                    last_state = "backward"
                    publish_cover_status(False)

            time.sleep(5)

    except KeyboardInterrupt:
        print("Exiting program")
        publish_device_status("offline")
    finally:
        relay1.off()
        relay2.off()
        spi.close()
        mod.close()
        bus.close()
        client.loop_stop()
        client.disconnect()


if _name_ == "_main_":
    main()
