from rest_framework import serializers
from .models import Notification, DiseaseNotification, SensorNotification, UserFCMTokens


class NotificationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Notification
        fields = '__all__'


class DiseaseNotificationSerializer(serializers.ModelSerializer):
    class Meta:
        model = DiseaseNotification
        fields = '__all__'


class SensorNotificationSerializer(serializers.ModelSerializer):
    class Meta:
        model = SensorNotification
        fields = '__all__'

class UserFCMTokensSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserFCMTokens
        fields = ['id', 'user_id', 'fcm_token', 'created_at']
        read_only_fields = ['id', 'created_at']