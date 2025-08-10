import os

from channels.security.websocket import AllowedHostsOriginValidator
from django.core.asgi import get_asgi_application

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "fasila.settings")
asgi_application = get_asgi_application()

from django.core.asgi import get_asgi_application
from channels.routing import ProtocolTypeRouter, URLRouter
from communications.jwt_middleware import JwtAuthMiddleware
from communications import routing

application = ProtocolTypeRouter({
    "http": get_asgi_application(),
    "websocket":
        JwtAuthMiddleware(
            URLRouter(
                routing.websocket_urlpatterns
            )
        ),
})
