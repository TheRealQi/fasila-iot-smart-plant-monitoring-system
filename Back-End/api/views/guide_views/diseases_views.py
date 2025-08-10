from django.db.models import Q
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView
from guide.models import Disease, DiseaseRecommendedAction, ChemicalControl
from guide.serializers import DiseaseSerializer, DiseaseRecommendedActionSerializer


class DiseasesViewAll(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        try:
            diseases = Disease.objects.all()
            data = []
            for disease in diseases:
                data.append({
                    "id": disease.id,
                    "name": disease.name,
                    "type": disease.type,
                    "description": disease.description,
                    "spread": disease.spread,
                    "symptoms": disease.symptoms,
                    "causes": disease.causes,
                    "cultural_control": disease.cultural_control,
                    "chemical_control": [str(med.id) for med in disease.chemical_control.all()],
                    "prevention": disease.prevention,
                    "image_urls": disease.image_urls
                })
            return Response(data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)


class DiseaseDetailsView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, disease_id):
        try:
            disease = Disease.objects.get(id=disease_id)
            data = {
                "id": disease.id,
                "name": disease.name,
                "type": disease.type,
                "description": disease.description,
                "spread": disease.spread,
                "symptoms": disease.symptoms,
                "causes": disease.causes,
                "cultural_control": disease.cultural_control,
                "chemical_control": [str(med.id) for med in disease.chemical_control.all()],
                "prevention": disease.prevention,
                "image_urls": disease.image_urls
            }
            return Response(data, status=status.HTTP_200_OK)
        except Disease.DoesNotExist:
            return Response({"error": "Disease not found"}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)


class DiseaseChemicalControls(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, disease_id):
        try:
            disease = Disease.objects.get(id=disease_id)
        except Disease.DoesNotExist:
            return Response(
                {"error": "Disease not found."},
                status=status.HTTP_404_NOT_FOUND
            )
        chemical_controls = disease.chemical_control.all()
        chemical_control_data = [
            {
                "id": control.id,
                "name": control.name,
                "type": control.type,
                "active_ingredients": control.active_ingredients,
                "preparation_methods": control.preparation_methods,
                "application_methods": control.application_methods,
            }
            for control in chemical_controls
        ]
        return Response(
            {
                "chemical_controls": chemical_control_data,
            },
            status=status.HTTP_200_OK
        )


class DiseaseFetch2Randoms(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        try:
            diseases = Disease.objects.all().order_by('?')[:2]
            data = []
            for disease in diseases:
                data.append({
                    "id": disease.id,
                    "name": disease.name,
                    "type": disease.type,
                    "description": disease.description,
                    "spread": disease.spread,
                    "symptoms": disease.symptoms,
                    "causes": disease.causes,
                    "cultural_control": disease.cultural_control,
                    "chemical_control": [str(med.id) for med in disease.chemical_control.all()],
                    "prevention": disease.prevention,
                    "image_urls": disease.image_urls
                })
            return Response(data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)


class DiseaseSearchView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        query = request.query_params.get('query', '')
        if not query:
            return Response(
                {'error': 'Query parameter is required'},
                status=status.HTTP_400_BAD_REQUEST
            )

        diseases = Disease.objects.filter(
            name__icontains=query
        )

        serializer = DiseaseSerializer(diseases, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


import logging
from django.conf import settings
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
import traceback

logger = logging.getLogger(__name__)


class FetchDiseaseRecommendedActionsView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, disease_id):
        logger.info(f"Fetching recommended actions for disease_id: {disease_id}")

        if not disease_id:
            logger.warning("Request missing disease_id parameter")
            return Response({"error": "disease_id parameter is required"}, status=400)

        try:
            # Log the query we're about to make
            logger.debug(f"Querying DiseaseRecommendedAction with disease_id={disease_id}")

            # First verify the disease exists
            try:
                disease = Disease.objects.get(id=disease_id)
            except Disease.DoesNotExist:
                logger.warning(f"Disease with id {disease_id} not found")
                return Response(
                    {"error": f"Disease with id {disease_id} not found"},
                    status=404
                )

            # Get recommended actions
            recommended_actions = DiseaseRecommendedAction.objects.filter(
                disease_id=disease_id
            )

            # Log the query results
            logger.debug(f"Found {recommended_actions.count()} recommended actions")

            if not recommended_actions.exists():
                logger.info(f"No recommended actions found for disease_id: {disease_id}")
                return Response(
                    {"error": f"No recommended actions found for disease_id: {disease_id}"},
                    status=404,
                )

            serializer = DiseaseRecommendedActionSerializer(
                recommended_actions, many=True
            )

            # Log successful response
            logger.info(f"Successfully retrieved {len(serializer.data)} recommended actions")
            return Response({"recommended_actions": serializer.data}, status=200)

        except Exception as e:
            # Get the full stack trace
            stack_trace = traceback.format_exc()

            # Log the detailed error
            logger.error(
                f"Error processing request for disease_id {disease_id}:\n"
                f"Error: {str(e)}\n"
                f"Stack trace:\n{stack_trace}"
            )

            # In development, return detailed error info
            if settings.DEBUG:
                error_response = {
                    "error": "An unexpected error occurred while fetching recommended actions",
                    "detail": str(e),
                    "stack_trace": stack_trace
                }
            else:
                error_response = {
                    "error": "An unexpected error occurred while fetching recommended actions"
                }

            return Response(error_response, status=500)
