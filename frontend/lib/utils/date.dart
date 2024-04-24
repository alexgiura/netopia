extension DateTimeExtension on DateTime {
  DateTime get startOfDay {
    return DateTime(this.year, this.month, this.day);
  }
}
