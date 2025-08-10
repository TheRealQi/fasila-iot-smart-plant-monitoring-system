import json
from datetime import datetime
from channels.generic.websocket import AsyncWebsocketConsumer


class SensorsDataConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        self.device_id = self.scope["url_route"]["kwargs"]["device_id"]
        self.room_group_name = f"{self.device_id}"
        await self.channel_layer.group_add(
            self.room_group_name,
            self.channel_name
        )
        await self.accept()

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard(
            self.room_group_name,
            self.channel_name
        )

    async def sensors_data(self, event):
        print(f"Sending data to {self.device_id}")
        await self.send(text_data=json.dumps({
            "type": event["type"],
            "device_id": event["device_id"],
            "timestamp": event["timestamp"],
            **{k: v for k, v in event.items() if k not in ["type", "device_id", "timestamp"]}
        }))

    async def device_status(self, event):
        await self.send(text_data=json.dumps({
            "type": event["type"],
            "device_id": event["device_id"],
            "status": event["status"]
        }))
