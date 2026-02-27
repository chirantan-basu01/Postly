import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/post_providers.dart';
import 'animated_media_preview.dart';

class MediaPreviewGrid extends ConsumerWidget {
  const MediaPreviewGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createPostNotifierProvider);
    final mediaItems = state.mediaItems;

    if (mediaItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: mediaItems.length == 1 ? 1 : 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: mediaItems.length == 1 ? 16 / 9 : 1,
        ),
        itemCount: mediaItems.length,
        itemBuilder: (context, index) {
          return AnimatedMediaPreview(
            key: ValueKey(mediaItems[index].id),
            mediaItem: mediaItems[index],
            onRemove: () => ref
                .read(createPostNotifierProvider.notifier)
                .removeMedia(mediaItems[index].id),
          );
        },
      ),
    );
  }
}
