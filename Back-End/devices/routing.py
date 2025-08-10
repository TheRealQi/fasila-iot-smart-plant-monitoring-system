from django.urls import re_path
from devices.consumers import SensorsDataConsumer



websocket_urlpatterns = [
    re_path(r'ws/sensorsdata/(?P<device_id>\w+)/$', SensorsDataConsumer.as_asgi()),
]
