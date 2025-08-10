from channels.middleware import BaseMiddleware
from channels.db import database_sync_to_async
from django.contrib.auth.models import AnonymousUser
from jwt import decode
from django.conf import settings
from rest_framework_simplejwt.tokens import UntypedToken
from rest_framework_simplejwt.exceptions import InvalidToken, TokenError
from urllib.parse import parse_qs


class JwtAuthMiddleware(BaseMiddleware):
    def __init__(self, inner):
        super().__init__(inner)

    async def __call__(self, scope, receive, send):
        query_string = scope["query_string"].decode()
        query_params = parse_qs(query_string)
        token = query_params.get('token', [None])[0]
        if token:
            try:
                UntypedToken(token)
                decoded_data = decode(
                    token,
                    settings.SECRET_KEY,
                    algorithms=["HS256"]
                )
                user = await self.get_user(decoded_data)
                scope['user'] = user
            except (InvalidToken, TokenError) as e:
                scope['user'] = AnonymousUser()
        else:
            scope['user'] = AnonymousUser()
        return await super().__call__(scope, receive, send)

    @database_sync_to_async
    def get_user(self, validated_token):
        try:
            user_id = validated_token['user_id']
            from users.models import CustomUser
            return CustomUser.objects.get(id=user_id)
        except Exception as e:
            return AnonymousUser()
