import 'dart:io';

import 'package:path_provider/path_provider.dart';

class MediaPathResolver {
  static String? _cachedMediaDirPath;

  static Future<String> getMediaDirectory() async {
    if (_cachedMediaDirPath != null) {
      return _cachedMediaDirPath!;
    }
    final appDir = await getApplicationDocumentsDirectory();
    _cachedMediaDirPath = '${appDir.path}/media';
    return _cachedMediaDirPath!;
  }

  /// Resolves a stored path (which might be absolute or relative) to a valid absolute path
  static Future<String> resolveFilePath(String storedPath) async {
    // If it's already a valid file, return as is
    if (await File(storedPath).exists()) {
      return storedPath;
    }

    // Extract just the filename and try to find it in media directory
    final filename = storedPath.split('/').last;
    final mediaDir = await getMediaDirectory();
    final resolvedPath = '$mediaDir/$filename';

    return resolvedPath;
  }

  /// Gets just the filename from a path for storage
  static String getFilename(String path) {
    return path.split('/').last;
  }
}
