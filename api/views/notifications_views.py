import datetime
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
from devices.models import Device, UserDevice
from guide.models import Disease
from notifications.models import Notification, DiseaseNotification, SensorNotification
from notifications.serializers import NotificationSerializer, DiseaseNotificationSerializer, \
    SensorNotificationSerializer
from notifications.services import get_fcm_tokens_by_device_id
from uuid import uuid4


class SendNotificationView(APIView):
    permission_classes = [AllowAny]

    def upload_image_to_s3(self, image_file, device_id):
        s3_client = boto3.client(
            's3',
            aws_access_key_id=settings.AWS_ACCESS_KEY_ID,
            aws_secret_access_key=settings.AWS_SECRET_ACCESS_KEY,
            region_name=settings.AWS_S3_REGION_NAME
        )
        file_extension = os.path.splitext(image_file.name)[1]
        unique_filename = f"notifications/detected_diseases/{device_id}/{datetime.datetime.now()}/{uuid4()}{file_extension}"
        try:
            s3_client.upload_fileobj(
                image_file,
                settings.AWS_STORAGE_BUCKET_NAME,
                unique_filename,
                ExtraArgs={'ContentType': image_file.content_type}
            )
            image_url = f"https://{settings.AWS_STORAGE_BUCKET_NAME}.s3.{settings.AWS_S3_REGION_NAME}.amazonaws.com/{unique_filename}"
            return image_url
        except Exception as e:
            return None

    def send_websocket_notification(self, device_id, notification_data):
        try:
            # Get the notification type and ID
            notification_type = notification_data.get("notification_type")
            notification_id = notification_data.get("id")

            # Create notification with unquoted keys using dict constructor
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

            # Add type-specific details with unquoted keys
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

            # Send the formatted notification through websocket
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

    def post(self, request):
        try:
            device_id = request.data.get('device_id')
            notification_type = request.data.get('notification_type')
            title = request.data.get('title')
            message = request.data.get('message')
            severity = request.data.get('severity', 'low')

            if notification_type not in ['disease', 'sensor', 'other']:
                return JsonResponse(
                    {"success": False, "error": "Invalid notification type."},
                    status=status.HTTP_400_BAD_REQUEST
                )
            if message is None or message.strip() == "":
                return JsonResponse(
                    {"success": False, "error": "Message cannot be empty."},
                    status=status.HTTP_400_BAD_REQUEST
                )
            if device_id is None or device_id.strip() == "":
                return JsonResponse(
                    {"success": False, "error": "Device ID cannot be empty."},
                    status=status.HTTP_400_BAD_REQUEST
                )

            device = Device.objects.get(device_id=device_id)
            if device is None:
                return JsonResponse(
                    {"success": False, "error": "Invalid device ID."},
                    status=status.HTTP_400_BAD_REQUEST
                )

            if notification_type.lower() == 'disease':
                image_file = request.data.get('disease_image')
                disease_id = request.data.get('disease_id')
                if image_file is None:
                    return JsonResponse(
                        {"success": False, "error": "Disease image is required."},
                        status=status.HTTP_400_BAD_REQUEST
                    )
                disease_img_url = self.upload_image_to_s3(image_file, device_id)
                if disease_img_url is None:
                    return JsonResponse(
                        {"success": False, "error": "Failed to upload image."},
                        status=status.HTTP_500_INTERNAL_SERVER_ERROR
                    )
                notification = Notification.objects.create(
                    device_id=device,
                    notification_type='disease',
                    title=title,
                    message=message,
                    severity=severity
                )
                disease_notification = DiseaseNotification.objects.create(
                    notification=notification,
                    disease_id=disease_id,
                    disease_image_url=disease_img_url
                )
                notification_data = NotificationSerializer(notification).data
                disease_notification_data = DiseaseNotificationSerializer(disease_notification).data
                response_data = {**notification_data, **disease_notification_data}

            elif notification_type.lower() == 'sensor':
                sensor_type = request.data.get('sensor_type')
                if sensor_type is None or sensor_type.strip() == "":
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

            else:
                notification = Notification.objects.create(
                    device_id=device,
                    notification_type='other',
                    title=title,
                    message=message,
                    severity=severity
                )
                notification_serializer = NotificationSerializer(notification)
                response_data = notification_serializer.data
            self.send_websocket_notification(device_id, response_data)
            fcm_tokens = get_fcm_tokens_by_device_id(device_id)
            if fcm_tokens:
                fcm_message = messaging.MulticastMessage(
                    notification=messaging.Notification(
                        title=title,
                        body=message,
                    ),
                    tokens=fcm_tokens
                )
                if notification_type.lower() == 'disease' and disease_img_url:
                    fcm_message.notification.image = disease_img_url
                messaging.send_each_for_multicast(fcm_message)
            return JsonResponse(
                {"success": True, "notification": response_data},
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
