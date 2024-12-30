from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from devices.models import Device, UserDevice
from devices.serializers import DeviceSerializer
from devices.serializers import TemperatureSensorSerializer, HumiditySensorSerializer, SoilMoistureSensorSerializer, \
    LightIntensitySensorSerializer, NPKSensorSerializer


class RegisterUserDevice(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        try:
            device_id = request.data.get('device_id')
            try:
                device = Device.objects.get(device_id=device_id)
            except Device.DoesNotExist:
                return Response(
                    {"error": "Device not found"},
                    status=status.HTTP_404_NOT_FOUND
                )
            if UserDevice.objects.filter(user=request.user, device=device).exists():
                return Response(
                    {"error": "Device already registered to user"},
                    status=status.HTTP_400_BAD_REQUEST
                )
            user_device = UserDevice.objects.create(user=request.user, device=device)
            return Response(
                {
                    "message": "Device registered successfully",
                    "device": DeviceSerializer(device).data
                },
                status=status.HTTP_201_CREATED
            )

        except Exception as e:
            return Response(
                {"error": "Unable to register device", "details": str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR  # Added status code
            )


class UserDevices(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        try:
            user_devices = UserDevice.objects.filter(user=request.user)
            devices_data = []
            for user_device in user_devices:
                device = user_device.device
                device_serializer = DeviceSerializer(device)
                device_data = device_serializer.data
                device_data['unread_notifications'] = device.unread_notifications
                devices_data.append(device_data)
            return Response(devices_data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response(
                {"error": "Unable to retrieve user devices", "details": str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )


class DeviceLatestStatus(APIView):
    permission_classes = [IsAuthenticated]
    def get(self, request, device_id):
        try:
            device = Device.objects.get(device_id=device_id)
            if not UserDevice.objects.filter(user=request.user, device=device).exists():
                return Response({"error": "Device not found or you don't have access to this device"},
                                status=status.HTTP_404_NOT_FOUND)
            serializer = DeviceSerializer(device)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Device.DoesNotExist:
            return Response({"error": "Device not found"}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class SensorsDataLatestValues(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, device_id):
        try:
            device = Device.objects.get(device_id=device_id)
            if not UserDevice.objects.filter(user=request.user, device=device).exists():
                return Response({"error": "Device not found or you don't have access to this device"},
                                status=status.HTTP_404_NOT_FOUND)
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
                "nutrient": NPKSensorSerializer(nutrient).data if nutrient else None,
            }
            return Response(data, status=status.HTTP_200_OK)
        except Device.DoesNotExist:
            return Response({"error": "Device not found"}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
