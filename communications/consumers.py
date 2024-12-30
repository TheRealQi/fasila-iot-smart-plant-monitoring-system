import json
from channels.db import database_sync_to_async
from channels.generic.websocket import AsyncWebsocketConsumer
import devices.models


class DevicesDataConsumer(AsyncWebsocketConsumer):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.room_group_name = None
        self.device_id = None

    async def connect(self):
        if self.scope["user"].is_anonymous:
            await self.close()
            return
        try:
            self.device_id = self.scope["url_route"]["kwargs"]["device_id"]
            has_access = await self.can_access_device(self.device_id)
            if not has_access:
                await self.close()
                return
            self.room_group_name = str(self.device_id)
            try:
                await self.channel_layer.group_add(
                    self.room_group_name,
                    self.channel_name
                )
            except Exception as e:
                await self.close()
                return
            await self.accept()
        except Exception as e:
            await self.close()
            return

    @database_sync_to_async
    def can_access_device(self, device_id):
        try:
            device = devices.models.Device.objects.get(device_id=device_id)
            has_access = devices.models.UserDevice.objects.filter(
                user=self.scope["user"],
                device=device
            ).exists()
            return has_access
        except Exception as e:
            return False

    async def disconnect(self, close_code):
        try:
            if self.room_group_name:
                await self.channel_layer.group_discard(
                    self.room_group_name,
                    self.channel_name
                )
        except Exception as e:
            print(f"Error during disconnect: {str(e)}")

    async def receive(self, text_data):
        try:
            command = json.loads(text_data)
            message_type = command.get("type")
            if message_type == "command.top_cover_panel":
                from .mqtt_client import publish_command
                await publish_command(command)
            else:
                print(f"Unknown message type: {message_type}")
        except Exception as e:
            print(f"Error receiving message: {str(e)}")

    async def sensors_data(self, event):
        try:
            await self.send(text_data=json.dumps({
                "type": event["type"],
                "device_id": event["device_id"],
                "timestamp": event["timestamp"],
                **{k: v for k, v in event.items() if k not in ["type", "device_id", "timestamp"]}
            }))
        except Exception as e:
            print(f"Error sending sensors data: {str(e)}")

    async def notification(self, event):
        try:
            notification_data = event.copy()
            del notification_data["type"]
            await self.send(text_data=json.dumps({
                "type": "notification",
                "device_id": event["device_id"],
                **notification_data
            }))
        except Exception as e:
            print(f"Error sending notification: {str(e)}")

    async def device_status(self, event):
        try:
            await self.send(text_data=json.dumps({
                "type": event["type"],
                "status": event["status"],
            }))
        except Exception as e:
            print(f"Error sending device status: {str(e)}")
