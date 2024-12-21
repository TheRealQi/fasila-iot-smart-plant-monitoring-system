from rest_framework import serializers
from .models import Notification, DiseaseNotification, SensorNotification

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
