import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/post/presentation/screens/create_post/create_post_screen.dart';
import 'features/post/presentation/screens/feed/feed_screen.dart';

class PostlyApp extends StatelessWidget {
  const PostlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Postly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const FeedScreen(),
        '/create': (context) => const CreatePostScreen(),
      },
    );
  }
}
