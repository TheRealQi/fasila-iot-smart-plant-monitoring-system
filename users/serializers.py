from rest_framework import serializers
from .models import CustomUser, UserFCMTokens


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = ['user_id', 'username', 'email', 'created_at', 'updated_at']
        read_only_fields = ['user_id', 'created_at', 'updated_at']


class UserRegistrationSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = CustomUser
        fields = ['username', 'email', 'password']

    def create(self, validated_data):
        user = CustomUser(
            username=validated_data['username'],
            email=validated_data['email'],
        )
        user.set_password(validated_data['password'])
        user.save()
        return user


class UserFCMTokensSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserFCMTokens
        fields = ['id', 'user_id', 'fcm_token', 'created_at']
        read_only_fields = ['id', 'created_at']
