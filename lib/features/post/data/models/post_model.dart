import 'media_item_model.dart';
import 'visibility_type.dart';

class PostModel {
  final String id;
  final String content;
  final List<MediaItemModel> mediaItems;
  final VisibilityType visibility;
  final DateTime createdAt;
  final List<String> hashtags;
  final List<String> mentions;
  final bool isDraft;
  final int likeCount;
  final List<String> comments;

  const PostModel({
    required this.id,
    required this.content,
    required this.mediaItems,
    required this.visibility,
    required this.createdAt,
    this.hashtags = const [],
    this.mentions = const [],
    this.isDraft = false,
    this.likeCount = 0,
    this.comments = const [],
  });

  bool get hasContent => content.trim().isNotEmpty || mediaItems.isNotEmpty;

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      content: json['content'] as String,
      mediaItems: (json['mediaItems'] as List<dynamic>?)
              ?.map((item) =>
                  MediaItemModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      visibility: VisibilityType.fromString(json['visibility'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      hashtags: (json['hashtags'] as List<dynamic>?)?.cast<String>() ?? [],
      mentions: (json['mentions'] as List<dynamic>?)?.cast<String>() ?? [],
      isDraft: json['isDraft'] as bool? ?? false,
      likeCount: json['likeCount'] as int? ?? 0,
      comments: (json['comments'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'mediaItems': mediaItems.map((item) => item.toJson()).toList(),
      'visibility': visibility.value,
      'createdAt': createdAt.toIso8601String(),
      'hashtags': hashtags,
      'mentions': mentions,
      'isDraft': isDraft,
      'likeCount': likeCount,
      'comments': comments,
    };
  }

  PostModel copyWith({
    String? id,
    String? content,
    List<MediaItemModel>? mediaItems,
    VisibilityType? visibility,
    DateTime? createdAt,
    List<String>? hashtags,
    List<String>? mentions,
    bool? isDraft,
    int? likeCount,
    List<String>? comments,
  }) {
    return PostModel(
      id: id ?? this.id,
      content: content ?? this.content,
      mediaItems: mediaItems ?? this.mediaItems,
      visibility: visibility ?? this.visibility,
      createdAt: createdAt ?? this.createdAt,
      hashtags: hashtags ?? this.hashtags,
      mentions: mentions ?? this.mentions,
      isDraft: isDraft ?? this.isDraft,
      likeCount: likeCount ?? this.likeCount,
      comments: comments ?? this.comments,
    );
  }
}
