from random import sample
from rest_framework import status
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView
from bson.objectid import ObjectId
from guide.models import diseases_collection
from guide.serializers import DiseaseSerializer


class DiseasesListAll(APIView):
    permission_classes = [IsAuthenticated]
    def get(self, request):
        diseases = list(diseases_collection.find())
        for disease in diseases:
            disease['_id'] = str(disease['_id'])
        serializer = DiseaseSerializer(diseases, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class DiseaseGet2RandomView(APIView):
    permission_classes = [IsAuthenticated]
    def get(self, request):
        diseases = list(diseases_collection.find())
        if len(diseases) >= 2:
            random_diseases = sample(diseases, 2)
            for disease in random_diseases:
                disease['_id'] = str(disease['_id'])
            serializer = DiseaseSerializer(random_diseases, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response({'error': 'Not enough diseases found'}, status=status.HTTP_404_NOT_FOUND)


class DiseaseDetailView(APIView):
    permission_classes = [IsAuthenticated]
    def get(self, request, disease_id):
        try:
            disease = diseases_collection.find_one({'_id': ObjectId(disease_id)})
            if disease:
                disease['_id'] = str(disease['_id'])
                serializer = DiseaseSerializer(disease)
                return Response(serializer.data, status=status.HTTP_200_OK)
            return Response({'error': 'Disease not found'}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

class DiseaseSearchView(APIView):
    permission_classes = [IsAuthenticated]
    def get(self, request):
        query = request.query_params.get('query', '')
        if not query:
            return Response({'error': 'Query parameter is required'}, status=status.HTTP_400_BAD_REQUEST)
        diseases = list(diseases_collection.find({'name': {'$regex': query, '$options': 'i'}}))
        for disease in diseases:
            disease['_id'] = str(disease['_id'])
        serializer = DiseaseSerializer(diseases, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)