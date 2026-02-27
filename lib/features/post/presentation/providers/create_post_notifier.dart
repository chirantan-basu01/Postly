import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/media_item_model.dart';
import '../../data/models/post_model.dart';
import '../../data/models/visibility_type.dart';
import '../../data/repositories/post_repository.dart';

class CreatePostState {
  final String content;
  final List<MediaItemModel> mediaItems;
  final VisibilityType visibility;
  final bool isLoading;
  final String? error;

  const CreatePostState({
    this.content = '',
    this.mediaItems = const [],
    this.visibility = VisibilityType.public,
    this.isLoading = false,
    this.error,
  });

  bool get canPost => content.trim().isNotEmpty || mediaItems.isNotEmpty;

  bool get hasContent => content.trim().isNotEmpty || mediaItems.isNotEmpty;

  CreatePostState copyWith({
    String? content,
    List<MediaItemModel>? mediaItems,
    VisibilityType? visibility,
    bool? isLoading,
    String? error,
  }) {
    return CreatePostState(
      content: content ?? this.content,
      mediaItems: mediaItems ?? this.mediaItems,
      visibility: visibility ?? this.visibility,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class CreatePostNotifier extends StateNotifier<CreatePostState> {
  final PostRepository _repository;

  CreatePostNotifier(this._repository) : super(const CreatePostState());

  void updateContent(String value) {
    state = state.copyWith(content: value);
  }

  void setVisibility(VisibilityType type) {
    state = state.copyWith(visibility: type);
  }

  Future<void> addImages() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final images = await _repository.pickImages();
      state = state.copyWith(
        mediaItems: [...state.mediaItems, ...images],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> addVideo() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final video = await _repository.pickVideo();
      if (video != null) {
        state = state.copyWith(
          mediaItems: [...state.mediaItems, video],
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> captureImage() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final image = await _repository.captureImage();
      if (image != null) {
        state = state.copyWith(
          mediaItems: [...state.mediaItems, image],
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void removeMedia(String mediaId) {
    final item = state.mediaItems.firstWhere((m) => m.id == mediaId);
    _repository.deleteMedia(item.filePath);
    state = state.copyWith(
      mediaItems: state.mediaItems.where((m) => m.id != mediaId).toList(),
    );
  }

  Future<PostModel?> createPost() async {
    if (!state.canPost) return null;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final post = PostModel(
        id: const Uuid().v4(),
        content: state.content.trim(),
        mediaItems: state.mediaItems,
        visibility: state.visibility,
        createdAt: DateTime.now(),
        hashtags: _extractHashtags(),
        mentions: _extractMentions(),
      );

      await _repository.createPost(post);
      reset();
      return post;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      return null;
    }
  }

  Future<void> saveAsDraft() async {
    if (!state.canPost) return;

    final draft = PostModel(
      id: const Uuid().v4(),
      content: state.content.trim(),
      mediaItems: state.mediaItems,
      visibility: state.visibility,
      createdAt: DateTime.now(),
      hashtags: _extractHashtags(),
      mentions: _extractMentions(),
      isDraft: true,
    );

    await _repository.saveDraft(draft);
  }

  void reset() {
    state = const CreatePostState();
  }

  List<String> _extractHashtags() {
    final regex = RegExp(r'#(\w+)');
    return regex.allMatches(state.content).map((m) => m.group(1)!).toList();
  }

  List<String> _extractMentions() {
    final regex = RegExp(r'@(\w+)');
    return regex.allMatches(state.content).map((m) => m.group(1)!).toList();
  }
}
