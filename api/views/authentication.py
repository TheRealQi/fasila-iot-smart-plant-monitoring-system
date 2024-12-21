from django.contrib.auth import authenticate
from rest_framework.permissions import AllowAny
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework_simplejwt.tokens import RefreshToken
from users.models import CustomUser


class RegisterView(APIView):
    permission_classes = [AllowAny]
    def post(self, request, *args, **kwargs):
        try:
            username = request.data.get('username')
            email = request.data.get('email')
            password = request.data.get('password')
            if not username or not email or not password:
                return Response({'error': 'All fields are required'}, status=status.HTTP_400_BAD_REQUEST)
            if CustomUser.objects.filter(username=username).exists():
                return Response({'error': 'Username already exists'}, status=status.HTTP_400_BAD_REQUEST)
            if CustomUser.objects.filter(email=email).exists():
                return Response({'error': 'Email already exists'}, status=status.HTTP_400_BAD_REQUEST)
            CustomUser.objects.create_user(username=username, email=email, password=password)
            return Response({'message': 'Registration complete. Please log in to continue.'}, status=status.HTTP_201_CREATED)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)


class LoginView(APIView):
    permission_classes = [AllowAny]
    def post(self, request, *args, **kwargs):
        try:
            username = request.data.get('username')
            password = request.data.get('password')
            user = authenticate(request, username=username, password=password)
            if user is not None:
                refresh = RefreshToken.for_user(user)
                return Response({
                    'refresh': str(refresh),
                    'access': str(refresh.access_token),
                    'user_id': user.id,
                    'username': user.username,
                    'email': user.email
                }, status=status.HTTP_200_OK)
            else:
                return Response({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)


class LogoutView(APIView):
    def post(self, request, *args, **kwargs):
        refresh_token = request.data.get('refresh')
        if not refresh_token:
            return Response({'error': 'Refresh token is required'}, status=status.HTTP_400_BAD_REQUEST)
        try:
            token = RefreshToken(refresh_token)
            token.blacklist()
            return Response({"message": "Logout successful"}, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({'error': 'Invalid or expired refresh token'}, status=status.HTTP_400_BAD_REQUEST)