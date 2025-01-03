from django.db.models import Q
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView
from guide.models import Disease, Plant, PlantDisease
from guide.serializers import PlantSerializer


class PlantsViewAll(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        try:
            plants = Plant.objects.all()
            data = []
            for plant in plants:
                data.append({
                    "id": plant.id,
                    "botanical_name": plant.botanical_name,
                    "common_name": plant.common_name,
                    "description": plant.description,
                    "type": plant.type,
                    "height": plant.height,
                    "difficulty": plant.difficulty,
                    "light": plant.light,
                    "alternate_light": plant.alternate_light,
                    "water_consumption": plant.water_consumption,
                    "watering": plant.watering,
                    "soil_depth": plant.soil_depth,
                    "seeding_depth": plant.seeding_depth,
                    "seed_spacing": plant.seed_spacing,
                    "germination_time": plant.germination_time,
                    "optimal_germination_temperature": plant.optimal_germination_temperature,
                    "growth_time": plant.growth_time,
                    "recommended_temperature": plant.recommended_temperature,
                    "image_urls": plant.image_urls
                })
            return Response(data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)


class PlantDetailsView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, plant_id):
        try:
            plant = Plant.objects.get(id=plant_id)
            data = {
                "id": plant.id,
                "botanical_name": plant.botanical_name,
                "common_name": plant.common_name,
                "description": plant.description,
                "type": plant.type,
                "height": plant.height,
                "difficulty": plant.difficulty,
                "light": plant.light,
                "alternate_light": plant.alternate_light,
                "water_consumption": plant.water_consumption,
                "watering": plant.watering,
                "soil_depth": plant.soil_depth,
                "seeding_depth": plant.seeding_depth,
                "seed_spacing": plant.seed_spacing,
                "germination_time": plant.germination_time,
                "optimal_germination_temperature": plant.optimal_germination_temperature,
                "growth_time": plant.growth_time,
                "recommended_temperature": plant.recommended_temperature,
                "image_urls": plant.image_urls
            }
            return Response(data, status=status.HTTP_200_OK)
        except Plant.DoesNotExist:
            return Response({"error": "Plant not found"}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)


class PlantFetchDiseases(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, plant_id):
        try:
            plant = Plant.objects.get(id=plant_id)
            plant_diseases = PlantDisease.objects.filter(plant=plant)
            data = []
            for plant_disease in plant_diseases:
                disease = plant_disease.disease
                data.append({
                    "id": disease.id,
                    "name": disease.name,
                    "image_url": disease.image_urls[0]
                })
            return Response(data, status=status.HTTP_200_OK)
        except Plant.DoesNotExist:
            return Response({"error": "Plant not found"}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)


class PlantFetch2Randoms(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        try:
            plants = Plant.objects.all().order_by('?')[:2]
            data = []
            for plant in plants:
                data.append({
                    "id": plant.id,
                    "botanical_name": plant.botanical_name,
                    "common_name": plant.common_name,
                    "description": plant.description,
                    "type": plant.type,
                    "height": plant.height,
                    "difficulty": plant.difficulty,
                    "light": plant.light,
                    "alternate_light": plant.alternate_light,
                    "water_consumption": plant.water_consumption,
                    "watering": plant.watering,
                    "soil_depth": plant.soil_depth,
                    "seeding_depth": plant.seeding_depth,
                    "seed_spacing": plant.seed_spacing,
                    "germination_time": plant.germination_time,
                    "optimal_germination_temperature": plant.optimal_germination_temperature,
                    "growth_time": plant.growth_time,
                    "recommended_temperature": plant.recommended_temperature,
                    "image_urls": plant.image_urls
                })
            return Response(data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)


class PlantSearchView(APIView):
    permission_classes = [IsAuthenticated]
    def get(self, request):
        query = request.query_params.get('query', '')
        if not query:
            return Response(
                {'error': 'Query parameter is required'},
                status=status.HTTP_400_BAD_REQUEST
            )
        plants = Plant.objects.filter(
            Q(common_name__icontains=query) |
            Q(botanical_name__icontains=query)
        )
        serializer = PlantSerializer(plants, many=True)
        print(serializer.data)
        return Response(serializer.data, status=status.HTTP_200_OK)
