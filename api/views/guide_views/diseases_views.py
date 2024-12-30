from django.db.models import Q
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView
from guide.models import Disease


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
                    "organic_control": [str(med.id) for med in disease.organic_control.all()],
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
                "organic_control": [str(med.id) for med in disease.organic_control.all()],
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
                    "organic_control": [str(med.id) for med in disease.organic_control.all()],
                    "prevention": disease.prevention,
                    "image_urls": disease.image_urls
                })
            return Response(data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)


class DiseaseSearch(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        try:
            query = request.GET.get('query', '').strip()
            diseases = Disease.objects.filter(Q(name__icontains=query))
            data = [{
                "id": disease.id,
                "name": disease.name,
            } for disease in diseases]
            return Response(data, status=status.HTTP_200_OK)
        except Exception as e:
            print(query)
            return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
