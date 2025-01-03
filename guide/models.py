from django.db import models


class Plant(models.Model):
    LIGHT_CHOICES = [
        ("Full Sun", "Full Sun"),
        ("Partial Sun", "Partial Sun"),
    ]
    WATER_CONSUMPTION_CHOICES = [
        ("Low", "Low"),
        ("Medium", "Medium"),
        ("High", "High"),
    ]
    DIFFICULTY_CHOICES = [
        ('Easy', 'Easy'),
        ('Medium', 'Medium'),
        ('Hard', 'Hard'),
    ]
    id = models.AutoField(primary_key=True)
    botanical_name = models.CharField(max_length=255)
    common_name = models.CharField(max_length=255)
    description = models.TextField()
    type = models.CharField(max_length=255)
    height = models.JSONField(default=dict)
    difficulty = models.CharField(max_length=255, choices=DIFFICULTY_CHOICES, default='easy')
    light = models.CharField(max_length=255, choices=LIGHT_CHOICES)
    alternate_light = models.CharField(max_length=255, choices=LIGHT_CHOICES)
    water_consumption = models.CharField(max_length=255, choices=WATER_CONSUMPTION_CHOICES)
    watering = models.TextField()
    soil_depth = models.JSONField(default=dict)
    seeding_depth = models.DecimalField(default=0.0, max_digits=5, decimal_places=2)
    seed_spacing = models.JSONField(default=dict)
    germination_time = models.JSONField(default=dict)
    optimal_germination_temperature = models.JSONField(default=dict)
    growth_time = models.JSONField(default=dict)
    recommended_temperature = models.JSONField(default=dict)
    image_urls = models.JSONField(default=list)

    def __str__(self):
        return self.common_name


class Disease(models.Model):
    DISASE_TYPE_CHOICES = [
        ("bacterial", "Bacterial"),
        ("fungal", "Fungal"),
        ("viral", "Viral"),
        ("parasitic", "Parasitic"),
    ]
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=255)
    type = models.CharField(max_length=255, choices=DISASE_TYPE_CHOICES)
    description = models.TextField()
    spread = models.TextField()
    symptoms = models.JSONField(default=list, blank=True)
    causes = models.JSONField(default=list, blank=True)
    cultural_control = models.JSONField(default=list)
    chemical_control = models.ManyToManyField('ChemicalControl')
    prevention = models.JSONField(default=list, blank=True)
    image_urls = models.JSONField(default=list, blank=True)

    def __str__(self):
        return self.name


class PlantDisease(models.Model):
    plant = models.ForeignKey(Plant, on_delete=models.CASCADE)
    disease = models.ForeignKey(Disease, on_delete=models.CASCADE)


class ChemicalControl(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=255)
    type = models.CharField(max_length=255)
    active_ingredients = models.JSONField(default=list)
    preparation_methods = models.TextField(default="Check product label for preparation instructions.")
    application_methods = models.JSONField(default=list)



class DiseaseRecommendedAction(models.Model):
    disease = models.ForeignKey(Disease, on_delete=models.CASCADE)
    actions = models.JSONField(default=list)
    recommended_chemical_medicine = models.ForeignKey(ChemicalControl, on_delete=models.CASCADE, blank=True, null=True)