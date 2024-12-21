from django.urls import re_path
from django_channels_jwt.views import AsgiValidateTokenView
from communications.consumers import DevicesDataConsumer

websocket_urlpatterns = [
    re_path(r'ws/(?P<device_id>\d+)/data/$', DevicesDataConsumer.as_asgi()),
]
