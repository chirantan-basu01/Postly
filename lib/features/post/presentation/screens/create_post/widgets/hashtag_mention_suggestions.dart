import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/constants/mock_data.dart';
import '../../../providers/post_providers.dart';

class HashtagMentionSuggestions extends ConsumerWidget {
  const HashtagMentionSuggestions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createPostNotifierProvider);
    final content = state.content;

    // Check if user is typing a hashtag or mention
    final lastWord = _getLastWord(content);

    if (lastWord.isEmpty) {
      return const SizedBox.shrink();
    }

    List<String> suggestions = [];

    if (lastWord.startsWith('#')) {
      final query = lastWord.substring(1).toLowerCase();
      suggestions = MockData.hashtags
          .where((tag) => tag.toLowerCase().contains(query))
          .take(5)
          .toList();
    } else if (lastWord.startsWith('@')) {
      final query = lastWord.substring(1).toLowerCase();
      suggestions = MockData.mentions
          .where((mention) => mention.toLowerCase().contains(query))
          .take(5)
          .toList();
    }

    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: suggestions.map((suggestion) {
          return ActionChip(
            label: Text(suggestion),
            onPressed: () {
              final notifier = ref.read(createPostNotifierProvider.notifier);
              final newContent = _replaceLastWord(content, suggestion);
              notifier.updateContent(newContent);
            },
          );
        }).toList(),
      ),
    );
  }

  String _getLastWord(String text) {
    if (text.isEmpty) return '';

    final words = text.split(RegExp(r'\s'));
    return words.isNotEmpty ? words.last : '';
  }

  String _replaceLastWord(String text, String replacement) {
    if (text.isEmpty) return replacement;

    final lastSpaceIndex = text.lastIndexOf(RegExp(r'\s'));
    if (lastSpaceIndex == -1) {
      return '$replacement ';
    }

    return '${text.substring(0, lastSpaceIndex + 1)}$replacement ';
  }
}
