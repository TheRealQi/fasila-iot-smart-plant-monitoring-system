from asgiref.sync import async_to_sync
from channels.layers import get_channel_layer
from django.utils import timezone
from datetime import datetime
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated, AllowAny
from devices.models import Device, UserDevice, DeviceDisease
from devices.serializers import DeviceSerializer, WaterTankSerializer
from devices.serializers import TemperatureSensorSerializer, HumiditySensorSerializer, SoilMoistureSensorSerializer, \
    LightIntensitySensorSerializer, NPKSensorSerializer
import datetime


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
            irrigation_water_tank = device.water_tank_data.filter(tank_type='irrigation').order_by('-timestamp').first()
            npk_water_tank = device.water_tank_data.filter(tank_type='npk').order_by('-timestamp').first()
            data = {
                "temperature": TemperatureSensorSerializer(temperature).data if temperature else None,
                "humidity": HumiditySensorSerializer(humidity).data if humidity else None,
                "moisture": SoilMoistureSensorSerializer(moisture).data if moisture else None,
                "light_intensity": LightIntensitySensorSerializer(light_intensity).data if light_intensity else None,
                "nutrient": NPKSensorSerializer(nutrient).data if nutrient else None,
                "irrigation_water_tank": WaterTankSerializer(irrigation_water_tank).data if irrigation_water_tank else None,
                "npk_water_tank": WaterTankSerializer(npk_water_tank).data if npk_water_tank else None,
            }
            return Response(data, status=status.HTTP_200_OK)
        except Device.DoesNotExist:
            return Response({"error": "Device not found"}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class DeviceHealthStatus(APIView):
    permission_classes = [IsAuthenticated]
    def put(self, request, device_id):
        try:
            device = Device.objects.get(device_id=device_id)
            if not UserDevice.objects.filter(user=request.user, device=device).exists():
                return Response(
                    {"error": "Device not found or you don't have access to this device"},
                    status=status.HTTP_404_NOT_FOUND
                )
            health_status = request.data.get('health_status')
            if health_status is None:
                return Response(
                    {"error": "health_status field is required"},
                    status=status.HTTP_400_BAD_REQUEST
                )
            if not isinstance(health_status, bool):
                return Response(
                    {"error": "health_status must be a boolean value"},
                    status=status.HTTP_400_BAD_REQUEST
                )
            device.health_status = health_status
            device.save()
            return Response({
                "message": "Device health status updated successfully",
                "health_status": device.health_status
            }, status=status.HTTP_200_OK)

        except Device.DoesNotExist:
            return Response(
                {"error": "Device not found"},
                status=status.HTTP_404_NOT_FOUND
            )
        except Exception as e:
            return Response(
                {"error": f"Unable to update device health status: {str(e)}"},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )


class DeviceDiseaseDetectionView(APIView):
    def get(self, request, device_id):
        try:
            latest_detection = DeviceDisease.objects.filter(
                device__device_id=device_id
            ).order_by('-timestamp').first()
            if latest_detection:
                latest_timestamp = latest_detection.timestamp
                latest_detections = DeviceDisease.objects.filter(
                    device__device_id=device_id,
                    timestamp=latest_timestamp
                ).select_related('disease')
                response_data = [
                    {
                        'id': detection.id,
                        'disease_name': detection.disease.name,
                        'disease_image_url': detection.disease_image_url,
                        'timestamp': detection.timestamp,
                        'disease_id': detection.disease.id
                    }
                    for detection in latest_detections
                ]
                return Response({
                    'success': True,
                    'detections': response_data
                }, status=status.HTTP_200_OK)
            return Response({
                'success': True,
                'detections': []
            }, status=status.HTTP_200_OK)

        except Exception as e:
            return Response({
                'success': False,
                'error': str(e)
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)



class UpdateDeviceHealthyStatusView(APIView):
    permission_classes = [AllowAny]
    def get(self, request, device_id):
        try:
            device = Device.objects.get(device_id=device_id)
            device.health_status = True
            device.save()
            channel_layer = get_channel_layer()
            async_to_sync(channel_layer.group_send)(
                f"{device_id}",
                {
                    "type": "device.status",
                    "device_id": device_id,
                    "timestamp": datetime.datetime.now().isoformat(),
                    "healthy": True
                }
            )
            return Response({
                "message": "Device health status updated successfully",
                "health_status": device.health_status
            }, status=status.HTTP_200_OK)
        except Device.DoesNotExist:
            return Response({"error": "Device not found"}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
