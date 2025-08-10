from django.urls import path
from api.views.authentication import RegisterView, LoginView, LogoutView
from api.views.fcm_tokens_views import AddFCMTokenView, DeleteFCMTokenView
from api.views.guide_views.diseases_views import DiseaseDetailsView, DiseaseFetch2Randoms, DiseasesViewAll, \
    DiseaseChemicalControls, DiseaseSearchView, FetchDiseaseRecommendedActionsView
from api.views.guide_views.plants_views import PlantsViewAll, PlantDetailsView, PlantFetch2Randoms, \
    PlantFetchDiseases, PlantSearchView
from api.views.notifications_views import GetDeviceNotificationsView, \
    GetDiseaseNotificationDiseaseView, DiseaseNotificationView, SensorNotificationView, GeneralNotificationView, \
    WaterTankNotificationView
from api.views.devices_views import DeviceLatestStatus, SensorsDataLatestValues, UserDevices, RegisterUserDevice, \
    DeviceDiseaseDetectionView, UpdateDeviceHealthyStatusView
from notifications.models import WaterTankNotification

urlpatterns = [
    path('auth/register/', RegisterView.as_view(), name='register'),
    path('auth/login/', LoginView.as_view(), name='login'),
    path('auth/logout/', LogoutView.as_view(), name='logout'),

    path('user/devices/', UserDevices.as_view(), name='user-devices'),
    path('devices/<int:device_id>/latest-status/', DeviceLatestStatus.as_view(), name='device-latest-status'),
    path('devices/<int:device_id>/sensors/latest/', SensorsDataLatestValues.as_view(), name='sensors-latest-values'),
    path('devices/<int:device_id>/disease-detections/', DeviceDiseaseDetectionView.as_view(),
         name='device-disease-detections'),

    # Notification URLs
    path('devices/notification/disease/', DiseaseNotificationView.as_view(), name='send-disease-notification'),
    path('devices/notification/sensor/', SensorNotificationView.as_view(), name='send-sensor-notification'),
    path('devices/notification/water-tank/', WaterTankNotificationView.as_view(), name='send-watertank-notification'),
    path('devices/notification/other/', GeneralNotificationView.as_view(), name='send-sensor-notification'),
    path('devices/<int:device_id>/healthy-status/', UpdateDeviceHealthyStatusView.as_view(),
         name='send-healthy-status'),

    path('devices/notifications/<int:device_id>/', GetDeviceNotificationsView.as_view(), name='get-notifications'),
    path('devices/notifications/<int:notification_id>/disease/', GetDiseaseNotificationDiseaseView.as_view(),
         name='get-disease-notification'),
    path('user/add-device/', RegisterUserDevice.as_view(), name='add-device'),
    path('users/fcm/add-token/', AddFCMTokenView.as_view(), name='fcm-token'),
    path('users/fcm/delete-token/', DeleteFCMTokenView.as_view(), name='delete-fcm-token'),

    path('diseases/', DiseasesViewAll.as_view(), name='disease-list-create'),
    path('diseases/2randoms/', DiseaseFetch2Randoms.as_view(), name='disease-random2'),
    path('diseases/<str:disease_id>/', DiseaseDetailsView.as_view(), name='disease-detail'),
    path('diseases/<int:disease_id>/chemical-controls/', DiseaseChemicalControls.as_view(),
         name='disease-chemical-control'),
    path('diseases/<int:disease_id>/recommended-actions/', FetchDiseaseRecommendedActionsView.as_view(),
         name='disease-recommended-actions'),
    path('diseases/search', DiseaseSearchView.as_view(), name='disease-search'),
    path('plants/', PlantsViewAll.as_view(), name='plant-list-create'),
    path('plants/2randoms/', PlantFetch2Randoms.as_view(), name='plant-random2'),
    path('plants/<str:plant_id>/', PlantDetailsView.as_view(), name='plant-detail'),
    path('plants/<str:plant_id>/diseases/', PlantFetchDiseases.as_view(), name='plant-diseases'),
    path('plants/search', PlantSearchView.as_view(), name='plant-search'),
]
