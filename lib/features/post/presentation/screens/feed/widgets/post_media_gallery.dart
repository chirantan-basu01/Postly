import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../../../../core/utils/media_path_resolver.dart';
import '../../../../data/models/media_item_model.dart';
import 'video_player_screen.dart';

class PostMediaGallery extends StatelessWidget {
  final List<MediaItemModel> mediaItems;

  const PostMediaGallery({super.key, required this.mediaItems});

  @override
  Widget build(BuildContext context) {
    if (mediaItems.isEmpty) return const SizedBox.shrink();

    if (mediaItems.length == 1) {
      return _buildSingleMedia(context, mediaItems.first);
    }

    return _buildMediaGrid(context);
  }

  Widget _buildSingleMedia(BuildContext context, MediaItemModel media) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: _MediaItemWidget(media: media),
      ),
    );
  }

  Widget _buildMediaGrid(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: mediaItems.length == 2 ? 1 : 1,
        ),
        itemCount: mediaItems.length > 4 ? 4 : mediaItems.length,
        itemBuilder: (context, index) {
          if (index == 3 && mediaItems.length > 4) {
            return Stack(
              fit: StackFit.expand,
              children: [
                _MediaItemWidget(media: mediaItems[index]),
                Container(
                  color: Colors.black54,
                  child: Center(
                    child: Text(
                      '+${mediaItems.length - 4}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return _MediaItemWidget(media: mediaItems[index]);
        },
      ),
    );
  }
}

class _MediaItemWidget extends StatefulWidget {
  final MediaItemModel media;

  const _MediaItemWidget({required this.media});

  @override
  State<_MediaItemWidget> createState() => _MediaItemWidgetState();
}

class _MediaItemWidgetState extends State<_MediaItemWidget> {
  String? _resolvedPath;
  Uint8List? _videoThumbnail;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _resolvePath();
  }

  Future<void> _resolvePath() async {
    try {
      final resolved = await MediaPathResolver.resolveFilePath(widget.media.filePath);
      final file = File(resolved);
      final exists = await file.exists();

      if (!exists) {
        if (mounted) {
          setState(() {
            _hasError = true;
            _isLoading = false;
          });
        }
        return;
      }

      _resolvedPath = resolved;

      // Generate thumbnail for videos
      if (widget.media.type == MediaType.video) {
        await _generateVideoThumbnail(resolved);
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _generateVideoThumbnail(String videoPath) async {
    try {
      final thumbnail = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 512,
        quality: 75,
      );
      if (mounted) {
        setState(() {
          _videoThumbnail = thumbnail;
        });
      }
    } catch (e) {
      // Thumbnail generation failed, will show placeholder
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.grey.shade200,
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (_hasError || _resolvedPath == null) {
      return Container(
        color: Colors.grey.shade300,
        child: const Center(
          child: Icon(Icons.broken_image, size: 48),
        ),
      );
    }

    if (widget.media.type == MediaType.video) {
      return GestureDetector(
        onTap: () => _playVideo(context),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_videoThumbnail != null)
              Image.memory(
                _videoThumbnail!,
                fit: BoxFit.cover,
              )
            else
              Container(color: Colors.black87),
            Container(
              color: Colors.black26,
              child: const Center(
                child: Icon(
                  Icons.play_circle_outline,
                  size: 48,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () => _viewImage(context),
      child: Image.file(
        File(_resolvedPath!),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.shade300,
            child: const Center(
              child: Icon(Icons.broken_image, size: 48),
            ),
          );
        },
      ),
    );
  }

  void _playVideo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(videoPath: _resolvedPath!),
      ),
    );
  }

  void _viewImage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _FullScreenImage(imagePath: _resolvedPath!),
      ),
    );
  }
}

class _FullScreenImage extends StatelessWidget {
  final String imagePath;

  const _FullScreenImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.file(
            File(imagePath),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
