import datetime
from datetime import datetime as dt
import os
import boto3
from asgiref.sync import async_to_sync
from channels.layers import get_channel_layer
from django.conf import settings
from firebase_admin import messaging
from django.http import JsonResponse
from rest_framework.views import APIView
from rest_framework import status
from rest_framework.permissions import IsAuthenticated, AllowAny
from devices.models import Device, UserDevice, DeviceDisease
from guide.models import Disease
from notifications.models import Notification, DiseaseNotification, SensorNotification, WaterTankNotification
from notifications.serializers import NotificationSerializer, DiseaseNotificationSerializer, \
    SensorNotificationSerializer, WaterTankNotificationSerializer
from notifications.services import get_fcm_tokens_by_device_id
from uuid import uuid4


class BaseNotificationView(APIView):
    permission_classes = [AllowAny]

    def upload_image_to_s3(self, image_file, device_id):
        s3_client = boto3.client(
            's3',
            aws_access_key_id=settings.AWS_ACCESS_KEY_ID,
            aws_secret_access_key=settings.AWS_SECRET_ACCESS_KEY,
            region_name=settings.AWS_S3_REGION_NAME
        )
        file_extension = os.path.splitext(image_file.name)[1]
        unique_filename = f"notifications/detected_diseases/{device_id}/{datetime.datetime.today().date()}/{uuid4()}{file_extension}"
        try:
            s3_client.upload_fileobj(
                image_file,
                settings.AWS_STORAGE_BUCKET_NAME,
                unique_filename,
                ExtraArgs={'ContentType': image_file.content_type}
            )
            return f"https://{settings.AWS_STORAGE_BUCKET_NAME}.s3.{settings.AWS_S3_REGION_NAME}.amazonaws.com/{unique_filename}"
        except Exception as e:
            return None

    def send_websocket_notification(self, device_id, notification_data):
        try:
            notification_type = notification_data.get("notification_type")
            notification_id = notification_data.get("id")

            formatted_notification = dict(
                id=notification_id,
                notification_type=notification_type,
                title=notification_data.get("title"),
                message=notification_data.get("message"),
                severity=notification_data.get("severity"),
                is_read=notification_data.get("is_read", False),
                timestamp=notification_data.get("timestamp"),
                device_id=notification_data.get("device_id")
            )
            if notification_type == "sensor":
                sensor_notification = SensorNotification.objects.filter(
                    notification_id=notification_id
                ).first()
                if sensor_notification:
                    formatted_notification["sensor_details"] = dict(
                        notification=notification_id,
                        sensor_type=sensor_notification.sensor_type
                    )
            elif notification_type == "disease":
                disease_notification = DiseaseNotification.objects.filter(
                    notification_id=notification_id
                ).first()
                if disease_notification:
                    formatted_notification["disease_details"] = dict(
                        notification=notification_id,
                        disease_id=disease_notification.disease_id,
                        disease_image_url=disease_notification.disease_image_url
                    )

            channel_layer = get_channel_layer()
            async_to_sync(channel_layer.group_send)(
                f"{device_id}",
                dict(
                    type="notification",
                    device_id=device_id,
                    notification=formatted_notification,
                )
            )
        except Exception as e:
            print(f"WebSocket notification error: {str(e)}")

    def validate_device(self, device_id):
        if not device_id or device_id.strip() == "":
            return None, "Device ID cannot be empty."
        try:
            device = Device.objects.get(device_id=device_id)
            return device, None
        except Device.DoesNotExist:
            return None, "Invalid device ID."

    def send_fcm_notification(self, device_id, title, message, image_url=None):
        fcm_tokens = get_fcm_tokens_by_device_id(device_id)
        if fcm_tokens:
            fcm_message = messaging.MulticastMessage(
                notification=messaging.Notification(
                    title=title,
                    body=message,
                ),
                tokens=fcm_tokens
            )
            if image_url:
                fcm_message.notification.image = image_url
            messaging.send_each_for_multicast(fcm_message)


class DiseaseNotificationView(BaseNotificationView):
    def send_healthy_status(self, device_id):
        try:
            print(f"Sending healthy status update for device_id: {device_id}")
            channel_layer = get_channel_layer()
            async_to_sync(channel_layer.group_send)(
                f"{device_id}",
                {
                    "type": "device.status",
                    "device_id": device_id,
                    "timestamp": datetime.datetime.now().isoformat(),
                    "healthy": False
                }
            )
        except Exception as e:
            print(f"WebSocket notification error in send_healthy_status: {str(e)}")

    def post(self, request):
        try:
            print("Received request data:", request.data)
            device_id = request.data.get('device_id')
            title = request.data.get('title')
            message = request.data.get('message')
            severity = request.data.get('severity', 'low')
            image_file = request.data.get('disease_image')
            disease_id = request.data.get('disease_id')
            timestamp = request.data.get('timestamp')

            print("Parsed values:", device_id, title, message, severity, disease_id, timestamp)

            # Parse timestamp and validate device
            timestamp = datetime.datetime.fromisoformat(timestamp)
            device, error = self.validate_device(device_id)
            if error:
                print("Device validation error:", error)
                return JsonResponse({"success": False, "error": error}, status=status.HTTP_400_BAD_REQUEST)

            if not image_file:
                print("Disease image not provided in the request.")
                return JsonResponse(
                    {"success": False, "error": "Disease image is required."},
                    status=status.HTTP_400_BAD_REQUEST
                )

            # Upload image to S3
            disease_img_url = self.upload_image_to_s3(image_file, device_id)
            if not disease_img_url:
                print("Failed to upload image to S3.")
                return JsonResponse(
                    {"success": False, "error": "Failed to upload image."},
                    status=status.HTTP_500_INTERNAL_SERVER_ERROR
                )

            # Fetch disease details
            try:
                disease = Disease.objects.get(id=disease_id)
                print("Fetched disease:", disease)
            except Disease.DoesNotExist:
                print(f"Disease with ID {disease_id} not found.")
                return JsonResponse(
                    {"success": False, "error": "Disease not found."},
                    status=status.HTTP_404_NOT_FOUND
                )

            # Record disease detection
            disease_detection = DeviceDisease.objects.create(
                device=device,
                disease=disease,
                disease_image_url=disease_img_url,
                timestamp=timestamp
            )
            print("Created DeviceDisease record:", disease_detection)

            # Update device status
            device.healthy = False
            device.save()
            print(f"Updated device {device_id} healthy status to False.")

            # Create notification records
            notification = Notification.objects.create(
                device_id=device,
                notification_type='disease',
                title=title,
                message=message,
                severity=severity
            )
            print("Created Notification record:", notification)

            disease_notification = DiseaseNotification.objects.create(
                notification=notification,
                disease_id=disease_id,
                disease_image_url=disease_img_url
            )
            print("Created DiseaseNotification record:", disease_notification)

            # Serialize and send notifications
            notification_data = NotificationSerializer(notification).data
            disease_notification_data = DiseaseNotificationSerializer(disease_notification).data
            response_data = {**notification_data, **disease_notification_data}
            print("Serialized response data:", response_data)

            self.send_websocket_notification(device_id, response_data)
            self.send_fcm_notification(device_id, title, message, disease_img_url)

            return JsonResponse(
                {"success": True, "notification": response_data},
                status=status.HTTP_201_CREATED
            )
        except Exception as e:
            print("Exception occurred:", str(e))
            return JsonResponse({"success": False, "error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class SensorNotificationView(BaseNotificationView):
    def post(self, request):
        try:
            device_id = request.data.get('device_id')
            title = request.data.get('title')
            message = request.data.get('message')
            severity = request.data.get('severity', 'low')
            sensor_type = request.data.get('sensor_type')

            device, error = self.validate_device(device_id)
            if error:
                return JsonResponse({"success": False, "error": error}, status=status.HTTP_400_BAD_REQUEST)

            if not sensor_type or sensor_type.strip() == "":
                return JsonResponse(
                    {"success": False, "error": "Sensor type is required."},
                    status=status.HTTP_400_BAD_REQUEST
                )

            notification = Notification.objects.create(
                device_id=device,
                notification_type='sensor',
                title=title,
                message=message,
                severity=severity
            )

            sensor_notification = SensorNotification.objects.create(
                notification=notification,
                sensor_type=sensor_type
            )

            notification_data = NotificationSerializer(notification).data
            sensor_notification_data = SensorNotificationSerializer(sensor_notification).data
            response_data = {**notification_data, **sensor_notification_data}

            self.send_websocket_notification(device_id, response_data)
            self.send_fcm_notification(device_id, title, message)

            return JsonResponse(
                {"success": True, "notification": response_data},
                status=status.HTTP_201_CREATED
            )
        except Exception as e:
            return JsonResponse({"success": False, "error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class WaterTankNotificationView(BaseNotificationView):
    def post(self, request):
        try:
            device_id = request.data.get('device_id')
            title = request.data.get('title')
            message = request.data.get('message')
            severity = request.data.get('severity', 'low')
            tank_type = request.data.get('tank_type')
            water_level = request.data.get('water_level')

            device, error = self.validate_device(device_id)
            if error:
                return JsonResponse({"success": False, "error": error}, status=status.HTTP_400_BAD_REQUEST)

            if not tank_type or tank_type.strip() == "":
                return JsonResponse(
                    {"success": False, "error": "Tank type is required."},
                    status=status.HTTP_400_BAD_REQUEST
                )
            if water_level is None:
                return JsonResponse(
                    {"success": False, "error": "Water level is required."},
                    status=status.HTTP_400_BAD_REQUEST
                )
            notification = Notification.objects.create(
                device_id=device,
                notification_type='water_tank',
                title=title,
                message=message,
                severity=severity
            )
            water_tank_notification = WaterTankNotification.objects.create(
                notification=notification,
                tank_type=tank_type,
                water_level=water_level
            )
            notification_data = NotificationSerializer(notification).data
            water_tank_notification_data = WaterTankNotificationSerializer(water_tank_notification).data
            response_data = {**notification_data, **water_tank_notification_data}
            self.send_websocket_notification(device_id, response_data)
            self.send_fcm_notification(device_id, title, message)
            return JsonResponse(
                {"success": True, "notification": response_data},
                status=status.HTTP_201_CREATED
            )
        except Exception as e:
            return JsonResponse({"success": False, "error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class GeneralNotificationView(BaseNotificationView):
    def post(self, request):
        try:
            device_id = request.data.get('device_id')
            title = request.data.get('title')
            message = request.data.get('message')
            severity = request.data.get('severity', 'low')

            device, error = self.validate_device(device_id)
            if error:
                return JsonResponse({"success": False, "error": error}, status=status.HTTP_400_BAD_REQUEST)

            notification = Notification.objects.create(
                device_id=device,
                notification_type='other',
                title=title,
                message=message,
                severity=severity
            )

            notification_data = NotificationSerializer(notification).data

            self.send_websocket_notification(device_id, notification_data)
            self.send_fcm_notification(device_id, title, message)

            return JsonResponse(
                {"success": True, "notification": notification_data},
                status=status.HTTP_201_CREATED
            )
        except Exception as e:
            return JsonResponse({"success": False, "error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class GetDeviceNotificationsView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, device_id):
        try:
            device = Device.objects.get(device_id=device_id)
            if not device:
                return JsonResponse(
                    {"success": False, "error": "Device not found."},
                    status=status.HTTP_404_NOT_FOUND
                )
            user_device = UserDevice.objects.filter(user=request.user, device=device)
            if not user_device.exists():
                return JsonResponse(
                    {"success": False, "error": "You don't have access to this device."},
                    status=status.HTTP_403_FORBIDDEN
                )
            notifications = device.device_notifications.all().order_by('-timestamp')
            serialized_notifications = []
            for notification in notifications:
                notification_data = NotificationSerializer(notification).data
                if notification.notification_type == 'disease':
                    disease_notification = DiseaseNotification.objects.filter(notification=notification).first()
                    if disease_notification:
                        disease_details = DiseaseNotificationSerializer(disease_notification).data
                        notification_data['disease_details'] = disease_details
                elif notification.notification_type == 'sensor':
                    sensor_notification = SensorNotification.objects.filter(notification=notification).first()
                    if sensor_notification:
                        sensor_details = SensorNotificationSerializer(sensor_notification).data
                        notification_data['sensor_details'] = sensor_details
                serialized_notifications.append(notification_data)
            return JsonResponse(
                {"success": True, "notifications": serialized_notifications},
                status=status.HTTP_200_OK
            )
        except Device.DoesNotExist:
            return JsonResponse(
                {"success": False, "error": "Device not found."},
                status=status.HTTP_404_NOT_FOUND
            )
        except Exception as e:
            return JsonResponse(
                {"success": False, "error": str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )


class GetDiseaseNotificationDiseaseView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, notification_id):
        try:
            notification = Notification.objects.get(id=notification_id)
            if not notification:
                return JsonResponse(
                    {"success": False, "error": "Notification not found."},
                    status=status.HTTP_404_NOT_FOUND
                )
            disease_notification = DiseaseNotification.objects.filter(notification=notification).first()
            if not disease_notification:
                return JsonResponse(
                    {"success": False, "error": "Disease notification not found."},
                    status=status.HTTP_404_NOT_FOUND
                )
            disease_details = Disease.objects.get(id=disease_notification.disease_id)
            if not disease_details:
                return JsonResponse(
                    {"success": False, "error": "Disease details not found."},
                    status=status.HTTP_404_NOT_FOUND
                )
            data = {
                "id": disease_details.id,
                "name": disease_details.name,
                "image_url": disease_details.image_urls[0],
            }
            return JsonResponse(
                data,
                status=status.HTTP_200_OK
            )
        except Exception as e:
            return JsonResponse(
                {"success": False, "error": str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )
