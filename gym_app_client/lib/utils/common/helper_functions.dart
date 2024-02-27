import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String capitalizeFirstLetter(String data) {
  if (data.isEmpty) return data;
  return "${data[0].toUpperCase()}${data.substring(1)}";
}

double normalizeDouble(num value) => double.parse(value.toStringAsFixed(1));

String getWeightString(double weight) => "${normalizeDouble(weight)} kg";

String getHeightString(double height) => "${normalizeDouble(height)} cm";

String normalizeDateString(String dateString) {
  DateTime? dateTime = DateTime.tryParse(dateString);

  if (dateTime == null) return dateString;

  String formattedDate = DateFormat('MMM d, yyyy').format(dateTime);
  return formattedDate;
}

String durationToString(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");

  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

  return "${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds";
}

Color hexToColor(String hexColor) {
  if (hexColor.startsWith('#')) hexColor = hexColor.substring(1);
  if (hexColor.length == 6) hexColor = "FF$hexColor";
  return Color(int.parse(hexColor, radix: 16));
}
