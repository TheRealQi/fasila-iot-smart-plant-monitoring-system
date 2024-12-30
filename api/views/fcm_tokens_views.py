from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from users.models import CustomUser
from rest_framework.permissions import IsAuthenticated
from notifications.models import UserFCMTokens


class AddFCMTokenView(APIView):
    permission_classes = [IsAuthenticated]
    def post(self, request):
        user_id = request.user.id
        fcm_token = request.data.get('fcm_token')
        if not user_id or not fcm_token:
            return Response({'error': 'User ID and FCM token are required'}, status=status.HTTP_400_BAD_REQUEST)
        try:
            user = CustomUser.objects.get(id=user_id)
        except CustomUser.DoesNotExist:
            return Response({'error': 'User not found'}, status=status.HTTP_404_NOT_FOUND)
        fcm_token_instance, _ = UserFCMTokens.objects.get_or_create(user=user, fcm_token=fcm_token)
        return Response({'message': 'FCM token added'}, status=status.HTTP_201_CREATED)


class DeleteFCMTokenView(APIView):
    permission_classes = [IsAuthenticated]
    def delete(self, request):
        user_id = request.user.id
        fcm_token = request.data.get('fcm_token')
        if not user_id or not fcm_token:
            return Response({"error": "user_id and fcm_token are required."}, status=status.HTTP_400_BAD_REQUEST)
        try:
            fcm_token_instance = UserFCMTokens.objects.get(id=user_id, fcm_token=fcm_token)
        except UserFCMTokens.DoesNotExist:
            return Response(
                {"error": "FCM token not found for the specified user."}, status=status.HTTP_404_NOT_FOUND)
        fcm_token_instance.delete()
        return Response(
            {"message": "FCM token deleted successfully."},
            status=status.HTTP_200_OK
        )
