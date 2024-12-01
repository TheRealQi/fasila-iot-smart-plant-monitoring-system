from django.urls import path

from api.views.diseases_views import DiseasesListAll, DiseaseDetailView, DiseaseGet2RandomView, DiseaseSearchView
from api.views.notifications_views import SendNotificationView, BroadcastNotificationView
from api.views.plants_views import PlantsListAll, PlantDetailView, PlantGet2RandomView, PlantSearchView
from api.views.devices_views import DeviceLatestStatus, SensorsDataLatestValues, SensorsDataHistory

urlpatterns = [
    # Disease URLs
    path('diseases/', DiseasesListAll.as_view(), name='disease-list-create'),
    path('diseases/2randoms/', DiseaseGet2RandomView.as_view(), name='disease-random2'),
    path('diseases/<str:disease_id>/', DiseaseDetailView.as_view(), name='disease-detail'),
    path('diseases/search', DiseaseSearchView.as_view(), name='disease-search'),

    # Plant URLs
    path('plants/', PlantsListAll.as_view(), name='plant-list-create'),
    path('plants/2randoms/', PlantGet2RandomView.as_view(), name='plant-random2'),
    path('plants/<str:plant_id>/', PlantDetailView.as_view(), name='plant-detail'),
    path('plants/search', PlantSearchView.as_view(), name='plant-search'),


    # Devices URLs
    path('devices/<int:device_id>/latest-status/', DeviceLatestStatus.as_view(), name='device-latest-status'),
    path('devices/<int:device_id>/sensors/latest/', SensorsDataLatestValues.as_view(), name='sensors-latest-values'),
    path('devices/<int:device_id>/sensors/history/<str:sensor_type>/<str:date_range>/', SensorsDataHistory.as_view(), name='sensors-history'),

    # Notification URLs
    path('notifications/send/', SendNotificationView.as_view(), name='send-notification'),
    path('notifications/broadcast/', BroadcastNotificationView.as_view(), name='broadcast-notification'),
]
