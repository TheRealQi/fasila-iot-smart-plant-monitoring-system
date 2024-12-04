from rest_framework import serializers
from .models import TemperatureSensor, HumiditySensor, SoilMoistureSensor, LightIntensitySensor, NPKSensor, Device

class DeviceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Device
        fields = ['device_id', 'status', 'last_online']

class TemperatureSensorSerializer(serializers.ModelSerializer):
    class Meta:
        model = TemperatureSensor
        fields = ['id', 'device', 'timestamp', 'temperature']

class HumiditySensorSerializer(serializers.ModelSerializer):
    class Meta:
        model = HumiditySensor
        fields = ['id', 'device', 'timestamp', 'humidity']

class SoilMoistureSensorSerializer(serializers.ModelSerializer):
    class Meta:
        model = SoilMoistureSensor
        fields = ['id', 'device', 'timestamp', 'moisture']

class LightIntensitySensorSerializer(serializers.ModelSerializer):
    class Meta:
        model = LightIntensitySensor
        fields = ['id', 'device', 'timestamp', 'light_intensity']

class NPKSensorSerializer(serializers.ModelSerializer):
    class Meta:
        model = NPKSensor
        fields = ['id', 'device', 'timestamp', 'nitrogen', 'phosphorus', 'potassium']