import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/feed_notifier.dart';
import '../../providers/post_providers.dart';
import '../../widgets/common/empty_feed_widget.dart';
import 'widgets/post_card.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(feedNotifierProvider.notifier).loadPosts(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(feedNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Postly'),
      ),
      body: _buildBody(state),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/create');
          if (result == true) {
            ref.read(feedNotifierProvider.notifier).loadPosts();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(FeedState state) {
    if (state.isLoading && state.posts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text('Error: ${state.error}'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () =>
                  ref.read(feedNotifierProvider.notifier).loadPosts(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.posts.isEmpty) {
      return const EmptyFeedWidget();
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(feedNotifierProvider.notifier).loadPosts(),
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: state.posts.length,
        itemBuilder: (context, index) => PostCard(post: state.posts[index]),
      ),
    );
  }
}
