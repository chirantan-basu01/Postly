import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/post_providers.dart';

class MediaPickerSection extends ConsumerWidget {
  const MediaPickerSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          _MediaButton(
            icon: Icons.photo_library,
            label: 'Photo',
            color: Colors.green,
            onTap: () =>
                ref.read(createPostNotifierProvider.notifier).addImages(),
          ),
          const SizedBox(width: 16),
          _MediaButton(
            icon: Icons.videocam,
            label: 'Video',
            color: Colors.red,
            onTap: () =>
                ref.read(createPostNotifierProvider.notifier).addVideo(),
          ),
          const SizedBox(width: 16),
          _MediaButton(
            icon: Icons.camera_alt,
            label: 'Camera',
            color: Colors.blue,
            onTap: () =>
                ref.read(createPostNotifierProvider.notifier).captureImage(),
          ),
        ],
      ),
    );
  }
}

class _MediaButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _MediaButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
