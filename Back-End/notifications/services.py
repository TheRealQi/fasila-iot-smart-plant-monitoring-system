from devices.models import Device, UserDevice
from .models import UserFCMTokens

def get_fcm_tokens_by_device_id(device_id):
    try:
        if not Device.objects.filter(device_id=device_id).exists():
            return {"error": "Device not found", "fcm_tokens": []}
        user_ids = UserDevice.objects.filter(device_id=device_id).values_list('user_id', flat=True)
        fcm_tokens = UserFCMTokens.objects.filter(user_id__in=user_ids).values_list('fcm_token', flat=True)
        return list(fcm_tokens)
    except Exception as e:
        return {"error": str(e), "fcm_tokens": []}