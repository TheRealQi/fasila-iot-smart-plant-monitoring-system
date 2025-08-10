class Disease {
  int id;
  String name;
  String type;
  String description;
  String spread;
  List<String> imageUrls;
  List<String> symptoms;
  List<String> causes;
  List<String> culturalControl;
  String? recommendedAction;
  List<String> prevention;

  Disease({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.spread,
    required this.imageUrls,
    required this.symptoms,
    required this.causes,
    required this.culturalControl,
    this.recommendedAction,
    required this.prevention,
  });

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      spread: json['spread'] ?? '',
      imageUrls: List<String>.from(json['image_urls'] ?? []),
      symptoms: List<String>.from(json['symptoms'] ?? []),
      causes: List<String>.from(json['causes'] ?? []),
      culturalControl: List<String>.from(json['cultural_control'] ?? []),
      recommendedAction: json['recommended_action'],
      prevention: List<String>.from(json['prevention'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
      'spread': spread,
      'image_urls': imageUrls,
      'symptoms': symptoms,
      'causes': causes,
      'cultural_control': culturalControl,
      'recommended_action': recommendedAction,
      'prevention': prevention,
    };
  }
}

class DiseaseSummary {
  final int id;
  final String name;
  final String imageUrl;
  DiseaseSummary({required this.id, required this.name, required this.imageUrl});

  factory DiseaseSummary.fromJson(Map<String, dynamic> json) {
    return DiseaseSummary(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
    );
  }
}

