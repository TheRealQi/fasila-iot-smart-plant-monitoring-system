class Chemical {
  int id;
  String name;
  String type;
  String activeIngredients;
  String preparationMethods;
  List<String> applicationMethods;

  Chemical({
    required this.id,
    required this.name,
    required this.type,
    required this.preparationMethods,
    required this.activeIngredients,
    required this.applicationMethods,
  });

  factory Chemical.fromJson(Map<String, dynamic> json) {
    return Chemical(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      activeIngredients: json['active_ingredients'] ?? '',
      preparationMethods: json['preparation_methods'] ?? '',
      applicationMethods: List<String>.from(json['application_methods'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'active_ingredients': activeIngredients,
      'preparation_methods': preparationMethods,
      'application_methods': applicationMethods,
    };
  }
}