import datetime

from django.db import models


def disease_image_path(instance, filename):
    return f'notifications/disease_images/{instance.device_id}/{datetime.datetime.now()}/{filename}'


class Notification(models.Model):
    SEVERITY_CHOICES = [
        ('low', 'Low'),
        ('medium', 'Medium'),
        ('high', 'High'),
        ('critical', 'Critical'),
    ]
    TYPE_CHOICES = [
        ('disease', 'Disease'),
        ('sensor', 'Sensor'),
        ('other', 'Other')
    ]
    device_id = models.ForeignKey('devices.Device', on_delete=models.CASCADE, related_name='device_notifications')
    notification_id = models.AutoField(primary_key=True)
    notification_type = models.CharField(max_length=255, choices=TYPE_CHOICES, default='other')
    title = models.CharField(max_length=255, blank=True, null=True, default="No Title")
    message = models.TextField()
    severity = models.CharField(max_length=255, choices=SEVERITY_CHOICES, default='low')
    is_read = models.BooleanField(default=False)
    timestamp = models.DateTimeField(auto_now_add=True)


class DiseaseNotification(models.Model):
    notification = models.OneToOneField(Notification, on_delete=models.CASCADE, related_name='disease_notification',
                                        primary_key=True)
    disease_id = models.CharField(max_length=255)
    disease_image_url = models.CharField(max_length=255, blank=True, null=True)


class SensorNotification(models.Model):
    SENSOR_CHOICES = [
        ('temperature', 'Temperature'),
        ('humidity', 'Humidity'),
        ('moisture', 'Moisture'),
        ('light_intensity', 'Light Intensity'),
        ('npk', 'NPK'),
    ]
    notification = models.OneToOneField(Notification, on_delete=models.CASCADE, related_name='sensor_notification',
                                        primary_key=True)
    sensor_type = models.CharField(max_length=255, choices=SENSOR_CHOICES)
