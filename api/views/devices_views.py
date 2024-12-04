from datetime import timedelta
from django.utils.timezone import now
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from bson.objectid import ObjectId
from devices.models import Device
from devices.serializers import DeviceSerializer
from devices.models import TemperatureSensor, HumiditySensor, SoilMoistureSensor, LightIntensitySensor, NPKSensor
from devices.serializers import TemperatureSensorSerializer, HumiditySensorSerializer, SoilMoistureSensorSerializer, LightIntensitySensorSerializer, NPKSensorSerializer



class DeviceLatestStatus(APIView):
    def get(self, request, device_id):
        try:
            device = Device.objects.get(device_id=device_id)
            serializer = DeviceSerializer(device)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Device.DoesNotExist:
            return Response({"error": "Device not found"}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class SensorsDataLatestValues(APIView):
    def get(self, request, device_id):
        try:
            device = Device.objects.get(device_id=device_id)
            temperature = device.temperature_data.first()
            humidity = device.humidity_data.first()
            moisture = device.moisture_data.first()
            light_intensity = device.light_data.first()
            nutrient = device.nutrient_data.first()
            data = {
                "temperature": TemperatureSensorSerializer(temperature).data if temperature else None,
                "humidity": HumiditySensorSerializer(humidity).data if humidity else None,
                "moisture": SoilMoistureSensorSerializer(moisture).data if moisture else None,
                "light_intensity": LightIntensitySensorSerializer(light_intensity).data if light_intensity else None,
                "nitrogen": nutrient.nitrogen if nutrient else None,
                "phosphorus": nutrient.phosphorus if nutrient else None,
                "potassium": nutrient.potassium if nutrient else None,
            }
            return Response(data, status=status.HTTP_200_OK)
        except Device.DoesNotExist:
            return Response({"error": "Device not found"}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class SensorsDataHistory(APIView):
    def get(self, request, device_id, sensor_type, date_range):
        try:
            date_ranges = {
                '1d': timedelta(days=1),
                '5d': timedelta(days=5),
                '1w': timedelta(days=7),
                '1m': timedelta(days=30),
                '3m': timedelta(days=90),
                '6m': timedelta(days=180),
                '1y': timedelta(days=365),
                'max': None,
            }
            duration = date_ranges.get(date_range)
            start_date = now() - duration if duration else None

            sensor_models = {
                "temperature": TemperatureSensor,
                "humidity": HumiditySensor,
                "moisture": SoilMoistureSensor,
                "light_intensity": LightIntensitySensor,
                "nutrients": NPKSensor,
            }

            model = sensor_models.get(sensor_type)
            if not model:
                return Response({"error": "Invalid sensor type"}, status=status.HTTP_400_BAD_REQUEST)

            # Filter based on date range
            queryset = model.objects.filter(device_id=device_id)
            if start_date:
                queryset = queryset.filter(timestamp__gte=start_date)

            # Serialize the queryset
            serializer = {
                "temperature": TemperatureSensorSerializer,
                "humidity": HumiditySensorSerializer,
                "moisture": SoilMoistureSensorSerializer,
                "light_intensity": LightIntensitySensorSerializer,
                "nutrients": NPKSensorSerializer,
            }[sensor_type](queryset, many=True)

            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
