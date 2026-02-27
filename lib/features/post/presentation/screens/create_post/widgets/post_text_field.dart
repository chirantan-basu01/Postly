import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/post_providers.dart';

class PostTextField extends ConsumerWidget {
  const PostTextField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createPostNotifierProvider);

    return TextField(
      controller: TextEditingController(text: state.content)
        ..selection = TextSelection.collapsed(offset: state.content.length),
      onChanged: (value) =>
          ref.read(createPostNotifierProvider.notifier).updateContent(value),
      decoration: const InputDecoration(
        hintText: "What's on your mind?",
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(16),
      ),
      maxLines: null,
      minLines: 5,
      textCapitalization: TextCapitalization.sentences,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}
