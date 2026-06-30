class TrainingModel {
  final int id;
  final String name;
  final String description;
  final String? imageUrl;

  TrainingModel({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
  });

  factory TrainingModel.fromJson(Map<String, dynamic> json) {
    return TrainingModel(
      id: json['id'] ?? 0,
      name: json['title'] ?? json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'],
    );
  }
}
