class BatchModel {
  final int id;
  final String name;

  BatchModel({
    required this.id,
    required this.name,
  });

  factory BatchModel.fromJson(Map<String, dynamic> json) {
    String batchName = json['name'] ?? json['batch_name'] ?? '';
    if (batchName.isEmpty && json['batch_ke'] != null) {
      batchName = 'Batch ${json['batch_ke']}';
    }
    
    return BatchModel(
      id: json['id'] ?? 0,
      name: batchName,
    );
  }
}
