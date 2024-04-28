String formatTimestamp(DateTime timestamp) {
  final now = DateTime.now();
  final difference = now.difference(timestamp);

  if (difference.inDays > 365) {
    return '${difference.inDays ~/ 365}y';
  } else if (difference.inDays > 30) {
    return '${difference.inDays ~/ 30} months';
  } else if (difference.inDays > 0) {
    return '${difference.inDays}d';
  } else if (difference.inHours > 0) {
    return '${difference.inHours}h';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} min';
  } else {
    return 'Now';
  }
}
