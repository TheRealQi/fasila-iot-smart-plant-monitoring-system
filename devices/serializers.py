from rest_framework import serializers
from .models import SensorsData, Device


class DeviceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Device
        fields = ['device_id', 'status', 'last_online']

class SensorsDataSerializer(serializers.ModelSerializer):
    class Meta:
        model = SensorsData
        fields = ['id', 'timestamp', 'device_id', 'temperature', 'humidity', 'moisture', 'light_intensity', 'nitrogen', 'phosphorus', 'potassium']