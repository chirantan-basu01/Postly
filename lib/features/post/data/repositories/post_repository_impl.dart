import '../datasources/media_local_datasource.dart';
import '../datasources/post_local_datasource.dart';
import '../models/media_item_model.dart';
import '../models/post_model.dart';
import 'post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostLocalDataSource postDataSource;
  final MediaLocalDataSource mediaDataSource;

  PostRepositoryImpl({
    required this.postDataSource,
    required this.mediaDataSource,
  });

  @override
  Future<List<PostModel>> getPosts() async {
    return postDataSource.getPosts();
  }

  @override
  Future<PostModel?> getPostById(String id) async {
    final posts = await postDataSource.getPosts();
    try {
      return posts.firstWhere((post) => post.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> createPost(PostModel post) async {
    final posts = await postDataSource.getPosts();
    posts.insert(0, post);
    return postDataSource.savePosts(posts);
  }

  @override
  Future<bool> updatePost(PostModel updatedPost) async {
    final posts = await postDataSource.getPosts();
    final index = posts.indexWhere((post) => post.id == updatedPost.id);
    if (index != -1) {
      posts[index] = updatedPost;
      return postDataSource.savePosts(posts);
    }
    return false;
  }

  @override
  Future<bool> deletePost(String id) async {
    final posts = await postDataSource.getPosts();
    posts.removeWhere((post) => post.id == id);
    return postDataSource.savePosts(posts);
  }

  @override
  Future<List<PostModel>> getDrafts() async {
    return postDataSource.getDrafts();
  }

  @override
  Future<bool> saveDraft(PostModel draft) async {
    final drafts = await postDataSource.getDrafts();
    final index = drafts.indexWhere((d) => d.id == draft.id);
    if (index != -1) {
      drafts[index] = draft;
    } else {
      drafts.insert(0, draft);
    }
    return postDataSource.saveDrafts(drafts);
  }

  @override
  Future<bool> deleteDraft(String id) async {
    final drafts = await postDataSource.getDrafts();
    drafts.removeWhere((draft) => draft.id == id);
    return postDataSource.saveDrafts(drafts);
  }

  @override
  Future<List<MediaItemModel>> pickImages() async {
    return mediaDataSource.pickImages();
  }

  @override
  Future<MediaItemModel?> pickVideo() async {
    return mediaDataSource.pickVideo();
  }

  @override
  Future<MediaItemModel?> captureImage() async {
    return mediaDataSource.captureImage();
  }

  @override
  Future<void> deleteMedia(String filePath) async {
    return mediaDataSource.deleteMediaFile(filePath);
  }
}
