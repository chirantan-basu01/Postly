import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/post_providers.dart';
import 'widgets/hashtag_mention_suggestions.dart';
import 'widgets/media_picker_section.dart';
import 'widgets/media_preview_grid.dart';
import 'widgets/post_text_field.dart';
import 'widgets/visibility_dropdown.dart';

class CreatePostScreen extends ConsumerWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createPostNotifierProvider);

    return PopScope(
      canPop: !state.hasContent,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldDiscard = await _showDiscardDialog(context);
        if (shouldDiscard == true && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Post'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _handleClose(context, ref),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilledButton(
                onPressed: state.canPost ? () => _handlePost(context, ref) : null,
                child: state.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Post'),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const VisibilityDropdown(),
                    const Divider(height: 1),
                    const PostTextField(),
                    const MediaPreviewGrid(),
                  ],
                ),
              ),
            ),
            const HashtagMentionSuggestions(),
            SafeArea(
              top: false,
              child: const MediaPickerSection(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleClose(BuildContext context, WidgetRef ref) async {
    final state = ref.read(createPostNotifierProvider);

    if (!state.hasContent) {
      Navigator.of(context).pop();
      return;
    }

    final shouldDiscard = await _showDiscardDialog(context);
    if (shouldDiscard == true && context.mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<bool?> _showDiscardDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Discard Post?'),
        content: const Text(
          'You have unsaved changes. Are you sure you want to discard this post?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Keep Editing'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePost(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(createPostNotifierProvider.notifier);
    final post = await notifier.createPost();

    if (post != null && context.mounted) {
      ref.read(feedNotifierProvider.notifier).addPost(post);
      Navigator.of(context).pop(true);
    }
  }
}
