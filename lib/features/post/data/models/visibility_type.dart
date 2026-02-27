import 'package:flutter/material.dart';

enum VisibilityType {
  public('Public', 'public'),
  friends('Friends', 'friends'),
  onlyMe('Only Me', 'only_me');

  final String displayName;
  final String value;

  const VisibilityType(this.displayName, this.value);

  static VisibilityType fromString(String value) {
    return VisibilityType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => VisibilityType.public,
    );
  }

  IconData get icon {
    switch (this) {
      case VisibilityType.public:
        return Icons.public;
      case VisibilityType.friends:
        return Icons.people;
      case VisibilityType.onlyMe:
        return Icons.lock;
    }
  }
}
