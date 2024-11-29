from datetime import datetime
from django.db import models


class Device(models.Model):
    device_id = models.BigAutoField(primary_key=True)
    status = models.BooleanField(default=False, null=False)
    last_online = models.DateTimeField(default=datetime.now)

    def __str__(self):
        return f'{self.device_id}'


class SensorsData(models.Model):
    id = models.AutoField(primary_key=True)
    timestamp = models.DateTimeField(default=datetime.now)
    device = models.ForeignKey(Device, on_delete=models.CASCADE)
    temperature = models.FloatField(default=0.0)
    humidity = models.FloatField(default=0.0)
    moisture = models.FloatField(default=0.0)
    light_intensity = models.FloatField(default=0.0)
    nitrogen = models.FloatField(default=0.0)
    phosphorus = models.FloatField(default=0.0)
    potassium = models.FloatField(default=0.0)

    def __str__(self):
        return f"Data from Device {self.device} at {self.timestamp}"

    class Meta:
        ordering = ['-timestamp']