import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/storage_keys.dart';
import '../models/post_model.dart';

abstract class PostLocalDataSource {
  Future<List<PostModel>> getPosts();
  Future<bool> savePosts(List<PostModel> posts);
  Future<List<PostModel>> getDrafts();
  Future<bool> saveDrafts(List<PostModel> drafts);
}

class PostLocalDataSourceImpl implements PostLocalDataSource {
  final SharedPreferences sharedPreferences;

  PostLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<PostModel>> getPosts() async {
    final jsonString = sharedPreferences.getString(StorageKeys.postsKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    final jsonList = jsonDecode(jsonString) as List<dynamic>;
    final posts = jsonList
        .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
        .toList();

    posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return posts;
  }

  @override
  Future<bool> savePosts(List<PostModel> posts) async {
    final jsonList = posts.map((post) => post.toJson()).toList();
    return sharedPreferences.setString(
      StorageKeys.postsKey,
      jsonEncode(jsonList),
    );
  }

  @override
  Future<List<PostModel>> getDrafts() async {
    final jsonString = sharedPreferences.getString(StorageKeys.draftsKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    final jsonList = jsonDecode(jsonString) as List<dynamic>;
    final drafts = jsonList
        .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
        .toList();

    drafts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return drafts;
  }

  @override
  Future<bool> saveDrafts(List<PostModel> drafts) async {
    final jsonList = drafts.map((draft) => draft.toJson()).toList();
    return sharedPreferences.setString(
      StorageKeys.draftsKey,
      jsonEncode(jsonList),
    );
  }
}
