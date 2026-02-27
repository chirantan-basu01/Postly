import 'package:flutter/material.dart';

import '../../../../../../core/utils/date_formatter.dart';
import '../../../../data/models/post_model.dart';

class PostHeader extends StatelessWidget {
  final PostModel post;

  const PostHeader({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.person,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Row(
                children: [
                  Text(
                    DateFormatter.getRelativeTime(post.createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.circle,
                    size: 4,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    post.visibility.icon,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ],
    );
  }
}
