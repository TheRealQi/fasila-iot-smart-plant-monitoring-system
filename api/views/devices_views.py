from datetime import timedelta
from django.utils.timezone import now
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from bson.objectid import ObjectId
from devices.models import Device
from devices.serializers import DeviceSerializer
from devices.models import SensorsData
from devices.serializers import SensorsDataSerializer


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
            latest_data = SensorsData.objects.filter(device_id=device_id).latest('timestamp')
            print(latest_data.timestamp)
            if latest_data is None:
                return Response({"error": "No data found"}, status=status.HTTP_404_NOT_FOUND)
            serializer = SensorsDataSerializer(latest_data)
            return Response(serializer.data, status=status.HTTP_200_OK)
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
            duration = date_ranges.get(date_range, None)
            if duration is not None:
                start_date = now() - duration
                queryset = SensorsData.objects.filter(
                    device_id=device_id,
                    timestamp__gte=start_date
                )
            else:
                queryset = SensorsData.objects.filter(device_id=device_id)
            if sensor_type in ['temperature', 'humidity', 'moisture', 'light_intensity', 'nitrogen', 'phosphorus',
                               'potassium']:
                queryset = queryset.values('timestamp', sensor_type)
            serializer = SensorsDataSerializer(queryset, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
