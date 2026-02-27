enum MediaType { image, video }

class MediaItemModel {
  final String id;
  final String filePath;
  final MediaType type;
  final DateTime addedAt;

  const MediaItemModel({
    required this.id,
    required this.filePath,
    required this.type,
    required this.addedAt,
  });

  factory MediaItemModel.fromJson(Map<String, dynamic> json) {
    return MediaItemModel(
      id: json['id'] as String,
      filePath: json['filePath'] as String,
      type: MediaType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MediaType.image,
      ),
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filePath': filePath,
      'type': type.name,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  MediaItemModel copyWith({
    String? id,
    String? filePath,
    MediaType? type,
    DateTime? addedAt,
  }) {
    return MediaItemModel(
      id: id ?? this.id,
      filePath: filePath ?? this.filePath,
      type: type ?? this.type,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}
