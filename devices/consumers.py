import json
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
        print(f"Received device sensors update: {event}")
        await self.send(text_data=json.dumps({
            "device_id": event["device_id"],
            "timestamp": event["timestamp"],
            "temperature": event["temperature"],
            "humidity": event["humidity"],
            "moisture": event["moisture"],
            "light_intensity": event["light_intensity"],
            "nitrogen": event["nitrogen"],
            "phosphorus": event["phosphorus"],
            "potassium": event["potassium"]
        }))

    async def device_status(self, event):
        await self.send(text_data=json.dumps({
            "device_id": event["device_id"],
            "status": event["status"]
        }))