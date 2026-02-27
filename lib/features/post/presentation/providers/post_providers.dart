import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../data/datasources/media_local_datasource.dart';
import '../../data/datasources/post_local_datasource.dart';
import '../../data/repositories/post_repository.dart';
import '../../data/repositories/post_repository_impl.dart';
import 'create_post_notifier.dart';
import 'feed_notifier.dart';

// SharedPreferences provider - must be overridden in main.dart
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main.dart');
});

// Data source providers
final postLocalDataSourceProvider = Provider<PostLocalDataSource>((ref) {
  return PostLocalDataSourceImpl(
    sharedPreferences: ref.watch(sharedPreferencesProvider),
  );
});

final mediaLocalDataSourceProvider = Provider<MediaLocalDataSource>((ref) {
  return MediaLocalDataSourceImpl(
    imagePicker: ImagePicker(),
    uuid: const Uuid(),
  );
});

// Repository provider
final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepositoryImpl(
    postDataSource: ref.watch(postLocalDataSourceProvider),
    mediaDataSource: ref.watch(mediaLocalDataSourceProvider),
  );
});

// State notifier providers
final feedNotifierProvider =
    StateNotifierProvider<FeedNotifier, FeedState>((ref) {
  return FeedNotifier(ref.watch(postRepositoryProvider));
});

final createPostNotifierProvider =
    StateNotifierProvider.autoDispose<CreatePostNotifier, CreatePostState>(
        (ref) {
  return CreatePostNotifier(ref.watch(postRepositoryProvider));
});
