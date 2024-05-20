class StatisticDataPoint {
  late final dynamic value;
  late final DateTime date;

  StatisticDataPoint.loadFromMap(Map<String, dynamic> data) {
    value = data["value"];
    date = DateTime.parse(data["date"]);
  }

  static List<StatisticDataPoint> getDataPointsFromBody(List<dynamic> body) {
    return List<StatisticDataPoint>.from(
      body.map((p) => StatisticDataPoint.loadFromMap(p)),
    );
  }
}
