import '../models/media_item_model.dart';
import '../models/post_model.dart';

abstract class PostRepository {
  Future<List<PostModel>> getPosts();
  Future<PostModel?> getPostById(String id);
  Future<bool> createPost(PostModel post);
  Future<bool> updatePost(PostModel post);
  Future<bool> deletePost(String id);
  Future<List<PostModel>> getDrafts();
  Future<bool> saveDraft(PostModel draft);
  Future<bool> deleteDraft(String id);
  Future<List<MediaItemModel>> pickImages();
  Future<MediaItemModel?> pickVideo();
  Future<MediaItemModel?> captureImage();
  Future<void> deleteMedia(String filePath);
}
