import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/models/visibility_type.dart';
import '../../../providers/post_providers.dart';

class VisibilityDropdown extends ConsumerWidget {
  const VisibilityDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createPostNotifierProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButton<VisibilityType>(
            value: state.visibility,
            underline: const SizedBox.shrink(),
            borderRadius: BorderRadius.circular(12),
            items: VisibilityType.values.map((type) {
              return DropdownMenuItem<VisibilityType>(
                value: type,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(type.icon, size: 18),
                    const SizedBox(width: 8),
                    Text(type.displayName),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                ref
                    .read(createPostNotifierProvider.notifier)
                    .setVisibility(value);
              }
          },
      ),
    );
  }
}
