from django.urls import path
from api.views.authentication import RegisterView, LoginView, LogoutView
from api.views.diseases_views import DiseasesListAll, DiseaseDetailView, DiseaseGet2RandomView, DiseaseSearchView
from api.views.fcm_tokens_views import AddFCMTokenView, DeleteFCMTokenView
from api.views.notifications_views import GetDeviceNotificationsView, SendNotificationView
from api.views.plants_views import PlantsListAll, PlantDetailView, PlantGet2RandomView, PlantSearchView
from api.views.devices_views import DeviceLatestStatus, SensorsDataLatestValues, UserDevices, RegisterUserDevice

urlpatterns = [
    path('auth/register/', RegisterView.as_view(), name='register'),
    path('auth/login/', LoginView.as_view(), name='login'),
    path('auth/logout/', LogoutView.as_view(), name='logout'),

    path('user/devices/register/<int:device_id>/', RegisterUserDevice.as_view(), name='register-user-device'),
    path('user/devices/', UserDevices.as_view(), name='user-devices'),
    path('devices/<int:device_id>/latest-status/', DeviceLatestStatus.as_view(), name='device-latest-status'),
    path('devices/<int:device_id>/sensors/latest/', SensorsDataLatestValues.as_view(), name='sensors-latest-values'),
    # Notification URLs
    path('devices/notifications/', SendNotificationView.as_view(), name='send-notification'),
    path('devices/notifications/<int:device_id>/', GetDeviceNotificationsView.as_view(), name='get-notifications'),

    path('users/fcm/add-token/', AddFCMTokenView.as_view(), name='fcm-token'),
    path('users/fcm/delete-token/', DeleteFCMTokenView.as_view(), name='delete-fcm-token'),

    path('diseases/', DiseasesListAll.as_view(), name='disease-list-create'),
    path('diseases/2randoms/', DiseaseGet2RandomView.as_view(), name='disease-random2'),
    path('diseases/<str:disease_id>/', DiseaseDetailView.as_view(), name='disease-detail'),
    path('diseases/search', DiseaseSearchView.as_view(), name='disease-search'),

    path('plants/', PlantsListAll.as_view(), name='plant-list-create'),
    path('plants/2randoms/', PlantGet2RandomView.as_view(), name='plant-random2'),
    path('plants/<str:plant_id>/', PlantDetailView.as_view(), name='plant-detail'),
    path('plants/search', PlantSearchView.as_view(), name='plant-search'),
]
