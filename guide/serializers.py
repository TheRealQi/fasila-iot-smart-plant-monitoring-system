from rest_framework import serializers
from .models import (
    Plant, Disease, PlantDisease, ChemicalControl,
    OrganicControl, DiseaseRecommendedAction
)


class ChemicalControlSerializer(serializers.ModelSerializer):
    class Meta:
        model = ChemicalControl
        fields = [
            'id',
            'name',
            'type',
            'active_ingredients',
            'preparation_methods',
            'application_methods'
        ]


class OrganicControlSerializer(serializers.ModelSerializer):
    class Meta:
        model = OrganicControl
        fields = [
            'id',
            'name',
            'active_ingredients',
            'preparation_steps',
            'application_methods'
        ]


class PlantSerializer(serializers.ModelSerializer):
    class Meta:
        model = Plant
        fields = [
            'id',
            'botanical_name',
            'common_name',
            'description',
            'type',
            'height',
            'difficulty',
            'light',
            'alternate_light',
            'water_consumption',
            'watering',
            'soil_depth',
            'seeding_depth',
            'seed_spacing',
            'germination_time',
            'optimal_germination_temperature',
            'growth_time',
            'recommended_temperature',
            'image_urls'
        ]


class DiseaseSerializer(serializers.ModelSerializer):
    chemical_control = ChemicalControlSerializer(many=True, read_only=True)
    organic_control = OrganicControlSerializer(many=True, read_only=True)

    class Meta:
        model = Disease
        fields = [
            'id',
            'name',
            'type',
            'description',
            'spread',
            'symptoms',
            'causes',
            'cultural_control',
            'chemical_control',
            'organic_control',
            'prevention',
            'image_urls'
        ]


class PlantDiseaseSerializer(serializers.ModelSerializer):
    plant = PlantSerializer(read_only=True)
    disease = DiseaseSerializer(read_only=True)

    class Meta:
        model = PlantDisease
        fields = ['id', 'plant', 'disease']


class DiseaseRecommendedActionSerializer(serializers.ModelSerializer):
    disease = DiseaseSerializer(read_only=True)
    recommended_chemical_medicine = ChemicalControlSerializer(read_only=True)
    recommended_organic_medicine = OrganicControlSerializer(read_only=True)

    class Meta:
        model = DiseaseRecommendedAction
        fields = [
            'id',
            'disease',
            'actions',
            'recommended_chemical_medicine',
            'recommended_organic_medicine'
        ]


class PlantListSerializer(serializers.ModelSerializer):
    class Meta:
        model = Plant
        fields = ['id', 'botanical_name', 'common_name', 'type', 'image_urls']


class DiseaseListSerializer(serializers.ModelSerializer):
    class Meta:
        model = Disease
        fields = ['id', 'name', 'type', 'symptoms', 'image_urls']
