/// Utility methods for formatting dates and times across DoseLens
class DateFormatters {
  DateFormatters._();

  static String formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static String formatDate(DateTime dateTime) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
  }

  static String formatShortDate(DateTime dateTime) {
    return '${dateTime.month}/${dateTime.day}';
  }

  static String formatDateTime(DateTime dateTime) {
    return '${formatDate(dateTime)} · ${formatTime(dateTime)}';
  }
}
