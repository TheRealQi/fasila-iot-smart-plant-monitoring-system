from random import sample
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from bson.objectid import ObjectId
from guide.models import plants_collection
from guide.serializers import PlantSerializer


class PlantsListAll(APIView):
    def get(self, request):
        plants = list(plants_collection.find())
        for plant in plants:
            plant['_id'] = str(plant['_id'])
        serializer = PlantSerializer(plants, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class PlantGet2RandomView(APIView):
    def get(self, request):
        plants = list(plants_collection.find())
        if len(plants) >= 2:
            random_plants = sample(plants, 2)
            for plant in random_plants:
                plant['_id'] = str(plant['_id'])
            serializer = PlantSerializer(random_plants, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response({'error': 'Not enough plants found'}, status=status.HTTP_404_NOT_FOUND)


class PlantDetailView(APIView):
    def get(self, request, plant_id):
        try:
            plant = plants_collection.find_one({'_id': ObjectId(plant_id)})
            if plant:
                plant['_id'] = str(plant['_id'])
                serializer = PlantSerializer(plant)
                return Response(serializer.data, status=status.HTTP_200_OK)
            return Response({'error': 'Plant not found'}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

class PlantSearchView(APIView):
    def get(self, request):
        query = request.query_params.get('query', '')
        if not query:
            return Response({'error': 'Query parameter is required'}, status=status.HTTP_400_BAD_REQUEST)
        plants = list(plants_collection.find({'name': {'$regex': query, '$options': 'i'}}))
        for plant in plants:
            plant['_id'] = str(plant['_id'])
        serializer = PlantSerializer(plants, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)