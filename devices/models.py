from django.utils.timezone import now
from django.db import models


class Device(models.Model):
    device_id = models.BigAutoField(primary_key=True)
    status = models.BooleanField(default=False, null=False)
    last_online = models.DateTimeField(default=now)
    unread_notifications = models.IntegerField(default=0)
    healthy = models.BooleanField(default=True)
    top_cover = models.BooleanField(default=False)
    latest_update = models.DateTimeField(default=now)

    def __str__(self):
        return f'Device {self.device_id}'


class UserDevice(models.Model):
    user = models.ForeignKey('users.CustomUser', on_delete=models.CASCADE)
    device = models.ForeignKey(Device, on_delete=models.CASCADE)

    def __str__(self):
        return f'Device {self.device} assigned to User {self.user}'


class TemperatureSensor(models.Model):
    id = models.AutoField(primary_key=True)
    device = models.ForeignKey(Device, on_delete=models.CASCADE, related_name='temperature_data')
    timestamp = models.DateTimeField(default=now)
    temperature = models.FloatField(default=0.0)

    def __str__(self):
        return f'Temperature {self.temperature} from Device {self.device} at {self.timestamp}'

    class Meta:
        ordering = ['-timestamp']


class HumiditySensor(models.Model):
    id = models.AutoField(primary_key=True)
    device = models.ForeignKey(Device, on_delete=models.CASCADE, related_name='humidity_data')
    timestamp = models.DateTimeField(default=now)
    humidity = models.FloatField(default=0.0)

    def __str__(self):
        return f'Humidity {self.humidity} from Device {self.device} at {self.timestamp}'

    class Meta:
        ordering = ['-timestamp']


class SoilMoistureSensor(models.Model):
    id = models.AutoField(primary_key=True)
    device = models.ForeignKey(Device, on_delete=models.CASCADE, related_name='moisture_data')
    timestamp = models.DateTimeField(default=now)
    moisture = models.FloatField(default=0.0)

    def __str__(self):
        return f'Soil Moisture {self.moisture} from Device {self.device} at {self.timestamp}'

    class Meta:
        ordering = ['-timestamp']


class LightIntensitySensor(models.Model):
    id = models.AutoField(primary_key=True)
    device = models.ForeignKey(Device, on_delete=models.CASCADE, related_name='light_data')
    timestamp = models.DateTimeField(default=now)
    light_intensity = models.FloatField(default=0.0)

    def __str__(self):
        return f'Light Intensity {self.light_intensity} from Device {self.device} at {self.timestamp}'

    class Meta:
        ordering = ['-timestamp']


class NPKSensor(models.Model):
    id = models.AutoField(primary_key=True)
    device = models.ForeignKey(Device, on_delete=models.CASCADE, related_name='nutrient_data')
    timestamp = models.DateTimeField(default=now)
    nitrogen = models.FloatField(default=0.0)
    phosphorus = models.FloatField(default=0.0)
    potassium = models.FloatField(default=0.0)

    def __str__(self):
        return (f'Nitrogen: {self.nitrogen}, Phosphorus: {self.phosphorus}, '
                f'Potassium: {self.potassium} from Device {self.device} at {self.timestamp}')

    class Meta:
        ordering = ['-timestamp']


class WaterTank(models.Model):
    TYPES = [
        ('irrigation', 'Irrigation'),
        ('npk', 'NPK'),
    ]
    id = models.AutoField(primary_key=True)
    device = models.ForeignKey(Device, on_delete=models.CASCADE, related_name='water_tank_data')
    tank_type = models.CharField(max_length=255, default='irrigation')
    water_level = models.FloatField(default=0.0)
    timestamp = models.DateTimeField(default=now)

    def __str__(self):
        return f'Water Level {self.water_level} from Device {self.device} at {self.timestamp} for {self.tank_type}'

    class Meta:
        ordering = ['-timestamp']


class DeviceDisease(models.Model):
    device = models.ForeignKey(Device, on_delete=models.CASCADE, related_name='disease_detection_data')
    disease = models.ForeignKey('guide.Disease', on_delete=models.CASCADE, related_name='disease_detection_data')
    disease_image_url = models.CharField(max_length=255, blank=True, null=True)
    timestamp = models.DateTimeField(default=now)

    def __str__(self):
        return f'Disease: {self.disease} from Device {self.device} at {self.timestamp}'

    class Meta:
        ordering = ['-timestamp']
