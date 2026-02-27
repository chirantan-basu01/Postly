import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../models/media_item_model.dart';

abstract class MediaLocalDataSource {
  Future<List<MediaItemModel>> pickImages();
  Future<MediaItemModel?> pickVideo();
  Future<MediaItemModel?> captureImage();
  Future<void> deleteMediaFile(String filePath);
}

class MediaLocalDataSourceImpl implements MediaLocalDataSource {
  final ImagePicker imagePicker;
  final Uuid uuid;

  MediaLocalDataSourceImpl({
    required this.imagePicker,
    required this.uuid,
  });

  @override
  Future<List<MediaItemModel>> pickImages() async {
    final images = await imagePicker.pickMultiImage(
      imageQuality: 80,
      maxWidth: 1920,
      maxHeight: 1080,
    );

    if (images.isEmpty) {
      return [];
    }

    return _processPickedFiles(images, MediaType.image);
  }

  @override
  Future<MediaItemModel?> pickVideo() async {
    final video = await imagePicker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(minutes: 5),
    );

    if (video == null) {
      return null;
    }

    final items = await _processPickedFiles([video], MediaType.video);
    return items.isNotEmpty ? items.first : null;
  }

  @override
  Future<MediaItemModel?> captureImage() async {
    final image = await imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (image == null) {
      return null;
    }

    final items = await _processPickedFiles([image], MediaType.image);
    return items.isNotEmpty ? items.first : null;
  }

  @override
  Future<void> deleteMediaFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<List<MediaItemModel>> _processPickedFiles(
    List<XFile> files,
    MediaType type,
  ) async {
    final List<MediaItemModel> mediaItems = [];
    final appDir = await getApplicationDocumentsDirectory();
    final mediaDir = Directory('${appDir.path}/media');

    if (!await mediaDir.exists()) {
      await mediaDir.create(recursive: true);
    }

    for (final file in files) {
      final id = uuid.v4();
      final extension = file.path.split('.').last;
      final newPath = '${mediaDir.path}/$id.$extension';

      await File(file.path).copy(newPath);

      mediaItems.add(MediaItemModel(
        id: id,
        filePath: newPath,
        type: type,
        addedAt: DateTime.now(),
      ));
    }

    return mediaItems;
  }
}
