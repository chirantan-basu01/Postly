import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/post_model.dart';
import '../../data/repositories/post_repository.dart';

class FeedState {
  final List<PostModel> posts;
  final bool isLoading;
  final String? error;

  const FeedState({
    this.posts = const [],
    this.isLoading = false,
    this.error,
  });

  FeedState copyWith({
    List<PostModel>? posts,
    bool? isLoading,
    String? error,
  }) {
    return FeedState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class FeedNotifier extends StateNotifier<FeedState> {
  final PostRepository _repository;

  FeedNotifier(this._repository) : super(const FeedState());

  Future<void> loadPosts() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final posts = await _repository.getPosts();
      state = state.copyWith(posts: posts, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void addPost(PostModel post) {
    state = state.copyWith(posts: [post, ...state.posts]);
  }

  Future<void> deletePost(String id) async {
    await _repository.deletePost(id);
    state = state.copyWith(
      posts: state.posts.where((p) => p.id != id).toList(),
    );
  }

  Future<void> toggleLike(String postId) async {
    final index = state.posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = state.posts[index];
      final updated = post.copyWith(likeCount: post.likeCount + 1);
      await _repository.updatePost(updated);

      final newPosts = [...state.posts];
      newPosts[index] = updated;
      state = state.copyWith(posts: newPosts);
    }
  }

  Future<void> addComment(String postId, String comment) async {
    final index = state.posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = state.posts[index];
      final updatedComments = [...post.comments, comment];
      final updated = post.copyWith(comments: updatedComments);
      await _repository.updatePost(updated);

      final newPosts = [...state.posts];
      newPosts[index] = updated;
      state = state.copyWith(posts: newPosts);
    }
  }
}
