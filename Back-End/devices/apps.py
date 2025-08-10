# apps.py or models.py
from django.apps import AppConfig

class YourAppConfig(AppConfig):
    name = 'devices'

    def ready(self):
        from . import signals
        from . import mqtt_client
        mqtt_client.client.loop_start()