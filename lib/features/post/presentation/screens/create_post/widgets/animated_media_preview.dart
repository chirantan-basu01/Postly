import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../data/models/media_item_model.dart';

class AnimatedMediaPreview extends StatefulWidget {
  final MediaItemModel mediaItem;
  final VoidCallback onRemove;

  const AnimatedMediaPreview({
    super.key,
    required this.mediaItem,
    required this.onRemove,
  });

  @override
  State<AnimatedMediaPreview> createState() => _AnimatedMediaPreviewState();
}

class _AnimatedMediaPreviewState extends State<AnimatedMediaPreview>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildMediaContent(),
              Positioned(
                top: 8,
                right: 8,
                child: _buildRemoveButton(),
              ),
              if (widget.mediaItem.type == MediaType.video)
                const Center(
                  child: Icon(
                    Icons.play_circle_outline,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaContent() {
    if (widget.mediaItem.type == MediaType.video) {
      return Container(
        color: Colors.black87,
        child: const Center(
          child: Icon(
            Icons.videocam,
            size: 48,
            color: Colors.white54,
          ),
        ),
      );
    }

    return Image.file(
      File(widget.mediaItem.filePath),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey.shade300,
          child: const Center(
            child: Icon(Icons.broken_image, size: 48),
          ),
        );
      },
    );
  }

  Widget _buildRemoveButton() {
    return GestureDetector(
      onTap: widget.onRemove,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.close,
          size: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
