class Plant {
  final int id;
  final String commonName;
  final String botanicalName;
  final String description;
  final String type;
  final Map<String, dynamic> height;
  final String waterConsumption;
  final String light;
  final String alternativeLight;
  final String difficulty;
  final Map<String, dynamic> soilDepth;
  final double seedingDepth;
  final Map<String, dynamic> seedSpacing;
  final Map<String, dynamic> germinationTime;
  final Map<String, dynamic> optimalGerminationTemperature;
  final Map<String, dynamic> growthTime;
  final Map<String, dynamic> recommendedTemperature;
  final List<String> imageUrls;
  final String watering;

  Plant({
    required this.id,
    required this.commonName,
    required this.botanicalName,
    required this.description,
    required this.type,
    required this.waterConsumption,
    required this.light,
    required this.alternativeLight,
    required this.difficulty,
    required this.soilDepth,
    required this.seedingDepth,
    required this.seedSpacing,
    required this.height,
    required this.germinationTime,
    required this.optimalGerminationTemperature,
    required this.growthTime,
    required this.recommendedTemperature,
    required this.imageUrls,
    required this.watering,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'] ?? 0,
      commonName: json['common_name'] ?? '',
      botanicalName: json['botanical_name'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      waterConsumption: json['water_consumption'] ?? '',
      light: json['light'] ?? '',
      alternativeLight: json['alternative_light'] ?? '',
      difficulty: json['difficulty'] ?? 'easy',
      soilDepth: json['soil_depth'] ?? {},
      seedingDepth: json['seeding_depth'] ?? 0.0,
      seedSpacing: json['seed_spacing'] ?? {},
      height: json['height'] ?? {},
      germinationTime: json['germination_time'] ?? {},
      optimalGerminationTemperature: json['optimal_germination_temperature'] ?? {},
      growthTime: json['growth_time'] ?? {},
      recommendedTemperature: json['recommended_temperature'] ?? {},
      imageUrls: json['image_urls'] != null ? List<String>.from(json['image_urls']) : [],
      watering: json['watering'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'common_name': commonName,
      'botanical_name': botanicalName,
      'description': description,
      'water_consumption': waterConsumption,
      'light': light,
      'alternative_light': alternativeLight,
      'difficulty': difficulty,
      'soil_depth': soilDepth,
      'seeding_depth': seedingDepth,
      'seed_spacing': seedSpacing,
      'height': height,
      'germination_time': germinationTime,
      'optimal_germination_temperature': optimalGerminationTemperature,
      'growth_time': growthTime,
      'recommended_temperature': recommendedTemperature,
      'image_urls': imageUrls,
      'watering': watering,
    };
  }
}
