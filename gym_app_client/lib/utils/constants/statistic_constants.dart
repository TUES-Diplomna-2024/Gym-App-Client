import 'package:gym_app_client/utils/common/enums/statistic_period.dart';

class StatisticConstants {
  static const Map<StatisticPeriod, String> periods = {
    StatisticPeriod.oneWeek: "1 Week",
    StatisticPeriod.oneMonth: "1 Month",
    StatisticPeriod.twoMonths: "2 Months",
    StatisticPeriod.threeMonths: "3 Months",
    StatisticPeriod.sixMonths: "6 Months",
    StatisticPeriod.oneYear: "1 Year",
    StatisticPeriod.all: "All"
  };
}
