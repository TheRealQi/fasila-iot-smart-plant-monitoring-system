from django.db.models.signals import post_save
from django.dispatch import receiver
from notifications.models import Notification, SensorNotification, DiseaseNotification
from devices.models import TemperatureSensor, HumiditySensor, SoilMoistureSensor, LightIntensitySensor, NPKSensor, \
    Device, WaterTank
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

@receiver(post_save, sender=WaterTank)
def new_water_tank_level_data(sender, instance, created, **kwargs):
    if created:
        channel_layer = get_channel_layer()
        async_to_sync(channel_layer.group_send)(
            f"{instance.device.device_id}",
            {
                "type": "water_tanks.data",
                "device_id": instance.device.device_id,
                "timestamp": instance.timestamp.isoformat(),
                "tank_type": instance.tank_type,
                "water_level": instance.water_level,
            }
        )

@receiver(post_save, sender=Device)
def device_status(sender, instance, created, **kwargs):
    try:
        channel_layer = get_channel_layer()
        message = {
            "type": "device.status",
            "device_id": instance.device_id,
            "status": instance.status
        }
        async_to_sync(channel_layer.group_send)(
            f"{instance.device_id}",
            message
        )
    except Exception as e:
        print(f"Error sending device status: {e}")
