from firebase_admin import messaging
from django.http import JsonResponse
from pycparser.ply.yacc import token
from rest_framework.views import APIView
from rest_framework import status


class SendNotificationView(APIView):
    def post(self, request):
        try:
            token = request.data.get('token')
            message = messaging.Message(
                notification=messaging.Notification(
                    title=request.data.get('title'),
                    body=request.data.get('body'),
                ),
                token=token,
            )
            response = messaging.send(message)

            return JsonResponse({"success": True, "message": response}, status=status.HTTP_200_OK)

        except Exception as e:
            return JsonResponse({"success": False, "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)


class BroadcastNotificationView(APIView):
    def post(self, request):
        try:
            title = request.data.get('title')
            body = request.data.get('body')
            topic = 'all'
            message = messaging.Message(
                notification=messaging.Notification(
                    title=title,
                    body=body,
                ),
                topic=topic,
            )
            response = messaging.send(message)
            return JsonResponse({"success": True, "message": response}, status=status.HTTP_200_OK)
        except Exception as e:
            return JsonResponse({"success": False, "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
