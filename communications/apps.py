from django.apps import AppConfig

class YourAppConfig(AppConfig):
    name = 'communications'

    def ready(self):
        from communications import mqtt_client
        mqtt_client.client.loop_start()