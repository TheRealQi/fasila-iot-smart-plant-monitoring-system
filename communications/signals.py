import re

from django.db.models.signals import post_save
from django.dispatch import receiver

from notifications.models import Notification
from devices.models import TemperatureSensor, HumiditySensor, SoilMoistureSensor, LightIntensitySensor, NPKSensor, Device
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync


@receiver(post_save, sender=TemperatureSensor)
def new_temperature_data(sender, instance, created, **kwargs):
    if created:
        channel_layer = get_channel_layer()
        async_to_sync(channel_layer.group_send)(
            f"{instance.device.device_id}",
            {
                "type": "sensors.data",
                "device_id": instance.device.device_id,
                "timestamp": instance.timestamp.isoformat(),
                "temperature": instance.temperature,
            }
        )


@receiver(post_save, sender=HumiditySensor)
def new_humidity_data(sender, instance, created, **kwargs):
    if created:
        channel_layer = get_channel_layer()
        async_to_sync(channel_layer.group_send)(
            f"{instance.device.device_id}",
            {
                "type": "sensors.data",
                "device_id": instance.device.device_id,
                "timestamp": instance.timestamp.isoformat(),
                "humidity": instance.humidity,
            }
        )


@receiver(post_save, sender=SoilMoistureSensor)
def new_moisture_data(sender, instance, created, **kwargs):
    if created:
        channel_layer = get_channel_layer()
        async_to_sync(channel_layer.group_send)(
            f"{instance.device.device_id}",
            {
                "type": "sensors.data",
                "device_id": instance.device.device_id,
                "timestamp": instance.timestamp.isoformat(),
                "moisture": instance.moisture,
            }
        )


@receiver(post_save, sender=LightIntensitySensor)
def new_light_intensity_data(sender, instance, created, **kwargs):
    if created:
        channel_layer = get_channel_layer()
        async_to_sync(channel_layer.group_send)(
            f"{instance.device.device_id}",
            {
                "type": "sensors.data",
                "device_id": instance.device.device_id,
                "timestamp": instance.timestamp.isoformat(),
                "light_intensity": instance.light_intensity,
            }
        )


@receiver(post_save, sender=NPKSensor)
def new_npk_data(sender, instance, created, **kwargs):
    if created:
        channel_layer = get_channel_layer()
        async_to_sync(channel_layer.group_send)(
            f"{instance.device.device_id}",
            {
                "type": "sensors.data",
                "device_id": instance.device.device_id,
                "timestamp": instance.timestamp.isoformat(),
                "nitrogen": instance.nitrogen,
                "phosphorus": instance.phosphorus,
                "potassium": instance.potassium,
            }
        )


@receiver(post_save, sender=Device)
def new_device_status(sender, instance, created, **kwargs):
    channel_layer = get_channel_layer()
    async_to_sync(channel_layer.group_send)(
        f"{instance.device_id}",
        {
            "type": "device.status",
            "device_id": instance.device_id,
            "status": instance.status,
        }
    )


@receiver(post_save, sender=Notification)
def new_notification(sender, instance, created, **kwargs):
    channel_layer = get_channel_layer()
    device_group = re.sub(r'\D', '', str(instance.device_id))
    async_to_sync(channel_layer.group_send)(
        device_group,
        {
            "type": "notification",
            "device_id": device_group,
            "notification_id": instance.notification_id,
            "title": instance.title,
            "message": instance.message,
            "notification_type": instance.type,
            "priority": instance.priority,
            "timestamp": instance.timestamp.isoformat(),
        }
    )
