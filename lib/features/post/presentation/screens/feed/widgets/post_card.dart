import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/models/post_model.dart';
import '../../../providers/post_providers.dart';
import 'post_header.dart';
import 'post_media_gallery.dart';

class PostCard extends ConsumerWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostHeader(post: post),
            if (post.content.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                post.content,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
            if (post.mediaItems.isNotEmpty) ...[
              const SizedBox(height: 12),
              PostMediaGallery(mediaItems: post.mediaItems),
            ],
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ActionButton(
                  icon: Icons.thumb_up_outlined,
                  label: post.likeCount > 0 ? '${post.likeCount}' : 'Like',
                  onTap: () => ref
                      .read(feedNotifierProvider.notifier)
                      .toggleLike(post.id),
                ),
                _ActionButton(
                  icon: Icons.comment_outlined,
                  label: post.comments.isNotEmpty
                      ? '${post.comments.length}'
                      : 'Comment',
                  onTap: () => _showCommentDialog(context, ref),
                ),
                _ActionButton(
                  icon: Icons.share_outlined,
                  label: 'Share',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCommentDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Comment'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Write a comment...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref
                    .read(feedNotifierProvider.notifier)
                    .addComment(post.id, controller.text.trim());
                Navigator.pop(ctx);
              }
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey.shade700),
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
