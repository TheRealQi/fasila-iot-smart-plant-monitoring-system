from django.db.models.signals import post_save
from django.dispatch import receiver
from .models import SensorsData, Device
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync


@receiver(post_save, sender=SensorsData)
def new_sensors_data(sender, instance, created, **kwargs):
    if created:
        channel_layer = get_channel_layer()
        async_to_sync(channel_layer.group_send)(
            f"{instance.device_id}",
            {
                "type": "sensors.data",
                "device_id": instance.device_id,
                "timestamp": instance.timestamp.isoformat(),
                "temperature": instance.temperature,
                "humidity": instance.humidity,
                "moisture": instance.moisture,
                "light_intensity": instance.light_intensity,
                "nitrogen": instance.nitrogen,
                "phosphorus": instance.phosphorus,
                "potassium": instance.potassium
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
