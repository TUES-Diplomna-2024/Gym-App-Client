class DateOnly {
  late final int year;
  late final int month;
  late final int day;

  DateOnly({
    required this.year,
    required this.month,
    required this.day,
  });

  DateOnly.fromString(String date) {
    try {
      final List<int> numbers =
          date.split('-').map((e) => int.parse(e)).toList();

      year = numbers[0];
      month = numbers[1];
      day = numbers[2];
    } catch (e) {
      throw FormatException('Invalid date format: $date');
    }
  }

  @override
  String toString() => "$year-$month-$day";
}
