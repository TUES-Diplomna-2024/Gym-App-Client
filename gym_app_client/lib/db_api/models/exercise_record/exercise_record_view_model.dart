import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class ExerciseRecordViewModel {
  late final String id;
  late final String onCreated;
  late final UnsignedInt sets;
  late final UnsignedInt reps;
  late final Duration duration;
  late final double weight;

  ExerciseRecordViewModel.loadFromMap(Map<String, dynamic> data) {
    id = data["id"];
    onCreated = _formatDate(data["onCreated"]);
    sets = data["sets"];
    reps = data["reps"];
    duration = Duration(seconds: data["duration"]);
    weight = double.parse(data["weight"].toStringAsFixed(1));
  }

  static List<ExerciseRecordViewModel> getRecordViewsFromResponse(
      Response response) {
    List<dynamic> body = json.decode(response.body);

    return List<ExerciseRecordViewModel>.from(
      body.map((r) => ExerciseRecordViewModel.loadFromMap(r)),
    );
  }

  String _formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat('MMM d, yyyy').format(dateTime);
    return formattedDate;
  }
}
